import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Order, OrderStatus, PaymentStatus, PaymentMethod } from '../../entities/order.entity';
import { OrderItem } from '../../entities/order-item.entity';
import { Product } from '../../entities/product.entity';
import { Customer } from '../../entities/customer.entity';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderStatusDto } from './dto/update-order-status.dto';
import { WebpayService } from './webpay.service';
import { ShippingService } from './shipping.service';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private ordersRepository: Repository<Order>,
    @InjectRepository(OrderItem)
    private orderItemsRepository: Repository<OrderItem>,
    @InjectRepository(Product)
    private productsRepository: Repository<Product>,
    @InjectRepository(Customer)
    private customersRepository: Repository<Customer>,
    private webpayService: WebpayService,
    private shippingService: ShippingService,
  ) {}

  async create(createOrderDto: CreateOrderDto, customerId?: string): Promise<Order> {
    const productIds = createOrderDto.items.map(item => item.productId);
    const products = await this.productsRepository.find({
      where: { id: In(productIds) },
    });

    if (products.length !== productIds.length) {
      throw new BadRequestException('Uno o más productos no existen');
    }

    let subtotal = 0;
    const orderItems: Partial<OrderItem>[] = [];

    for (const item of createOrderDto.items) {
      const product = products.find(p => p.id === item.productId);
      if (!product) {
        throw new BadRequestException(`Producto ${item.productId} no encontrado`);
      }

      if (!product.isActive) {
        throw new BadRequestException(`Producto ${product.name} no está disponible`);
      }

      if (product.stock < item.quantity) {
        throw new BadRequestException(`Stock insuficiente para ${product.name}`);
      }

      // Calcular precio base del item
      let itemSubtotal = Number(product.price) * item.quantity;
      
      // Agregar precio de bordado si aplica
      let embroideryPrice = 0;
      if (item.isEmbroidered && product.canBeEmbroidered) {
        // Usar embroideryPrice del producto si existe, sino un precio por defecto
        const embroideryPricePerUnit = Number(product.embroideryPrice || 2500);
        embroideryPrice = embroideryPricePerUnit * item.quantity;
        itemSubtotal += embroideryPrice;
      }

      subtotal += itemSubtotal;

      orderItems.push({
        productId: product.id,
        productName: product.name,
        unitPrice: Number(product.price),
        quantity: item.quantity,
        subtotal: itemSubtotal,
        isEmbroidered: item.isEmbroidered || false,
        embroideryName: item.embroideryName || null,
        embroideryPrice: embroideryPrice,
      });
    }

    let customer: Customer | null = null;
    if (customerId) {
      customer = await this.customersRepository.findOne({ where: { id: customerId } });
      if (customer) {
        createOrderDto.customerName = customer.fullName;
        createOrderDto.customerEmail = customer.email;
        createOrderDto.customerPhone = customer.phone;
        if (!createOrderDto.shippingAddress && customer.address) {
          createOrderDto.shippingAddress = customer.address;
        }
      }
    }

    const orderNumber = await this.generateOrderNumber();

    let shippingCost = 0;
    if (createOrderDto.shippingType) {
      const shippingOptions = this.shippingService.getAvailableShippingTypes();
      const selectedShipping = shippingOptions.find(s => s.type === createOrderDto.shippingType);
      if (selectedShipping) {
        shippingCost = selectedShipping.price;
      }
    }

    const order = this.ordersRepository.create({
      orderNumber,
      customerId: customerId || null,
      customerName: createOrderDto.customerName,
      customerEmail: createOrderDto.customerEmail,
      customerPhone: createOrderDto.customerPhone,
      shippingAddress: createOrderDto.shippingAddress || (customer ? customer.address : null),
      shippingType: createOrderDto.shippingType || null,
      subtotal,
      discount: createOrderDto.discount || 0,
      total: subtotal - (createOrderDto.discount || 0) + shippingCost,
      paymentMethod: createOrderDto.paymentMethod || PaymentMethod.WEBPAY,
      status: OrderStatus.PENDING,
      paymentStatus: PaymentStatus.PENDING,
      notes: createOrderDto.notes,
    });

    const savedOrder = await this.ordersRepository.save(order) as Order;

    const savedItems = orderItems.map(item => ({
      ...item,
      orderId: savedOrder.id,
    }));

    await this.orderItemsRepository.save(savedItems);

    for (const item of createOrderDto.items) {
      const product = products.find(p => p.id === item.productId);
      if (product) {
        product.stock -= item.quantity;
        await this.productsRepository.save(product);
      }
    }

    return this.findOne(savedOrder.id);
  }

  async findAll(filters?: { status?: OrderStatus; paymentStatus?: PaymentStatus; customerId?: string }): Promise<Order[]> {
    try {
      const query = this.ordersRepository.createQueryBuilder('order')
        .leftJoinAndSelect('order.items', 'items')
        .orderBy('order.createdAt', 'DESC');

      const conditions: string[] = [];
      const params: Record<string, any> = {};

      if (filters?.status) {
        conditions.push('order.status = :status');
        params.status = filters.status;
      }

      if (filters?.paymentStatus) {
        conditions.push('order.paymentStatus = :paymentStatus');
        params.paymentStatus = filters.paymentStatus;
      }

      if (filters?.customerId) {
        conditions.push('order.customerId = :customerId');
        params.customerId = filters.customerId;
      }

      if (conditions.length > 0) {
        query.where(conditions.join(' AND '), params);
      }

      return await query.getMany();
    } catch (error) {
      console.error('Error in findAll orders:', error);
      return [];
    }
  }

  async findOne(id: string): Promise<Order> {
    const order = await this.ordersRepository.findOne({
      where: { id },
      relations: ['items', 'items.product', 'customer'],
    });

    if (!order) {
      throw new NotFoundException(`Orden con ID ${id} no encontrada`);
    }

    return order;
  }

  async updateStatus(id: string, updateStatusDto: UpdateOrderStatusDto): Promise<Order> {
    const order = await this.findOne(id);
    order.status = updateStatusDto.status || order.status;
    
    if (updateStatusDto.paymentStatus) {
      order.paymentStatus = updateStatusDto.paymentStatus;
    }

    if (updateStatusDto.trackingNumber) {
      order.trackingNumber = updateStatusDto.trackingNumber;
    }

    if (updateStatusDto.status === OrderStatus.SHIPPED && order.shippingType && !order.trackingNumber) {
      try {
        const shipment = await this.shippingService.createShipment(
          order.shippingType,
          order.orderNumber,
          order.customerName,
          order.shippingAddress || '',
          order.customerPhone,
        );
        order.trackingNumber = shipment.trackingNumber;
      } catch (error) {
        console.error('Error al crear envío:', error);
      }
    }

    return await this.ordersRepository.save(order);
  }

  async initiateWebpayPayment(orderId: string): Promise<{ token: string; url: string }> {
    const order = await this.findOne(orderId);

    if (order.paymentStatus !== PaymentStatus.PENDING) {
      throw new BadRequestException('La orden ya fue procesada');
    }

    const webpayResponse = await this.webpayService.createTransaction({
      amount: order.total,
      buyOrder: order.orderNumber,
      sessionId: order.id,
      returnUrl: `${process.env.FRONTEND_URL || 'http://localhost:3000'}/checkout/confirm`,
    });

    order.webpayToken = webpayResponse.token;
    await this.ordersRepository.save(order);

    return {
      token: webpayResponse.token,
      url: webpayResponse.url,
    };
  }

  async confirmWebpayPayment(token: string): Promise<Order> {
    const order = await this.ordersRepository.findOne({
      where: { webpayToken: token },
      relations: ['items'],
    });

    if (!order) {
      throw new NotFoundException('Orden no encontrada');
    }

    const webpayResponse = await this.webpayService.commitTransaction(token);

    if (webpayResponse.responseCode === 0) {
      order.paymentStatus = PaymentStatus.APPROVED;
      order.status = OrderStatus.PAID;
      order.webpayTransactionId = webpayResponse.buyOrder;
    } else {
      order.paymentStatus = PaymentStatus.REJECTED;
      for (const item of order.items) {
        const product = await this.productsRepository.findOne({ where: { id: item.productId } });
        if (product) {
          product.stock += item.quantity;
          await this.productsRepository.save(product);
        }
      }
    }

    return await this.ordersRepository.save(order);
  }

  private async generateOrderNumber(): Promise<string> {
    const year = new Date().getFullYear();
    const startOfYear = new Date(`${year}-01-01T00:00:00.000Z`);
    
    const count = await this.ordersRepository
      .createQueryBuilder('order')
      .where('order.createdAt >= :startOfYear', { startOfYear })
      .getCount();

    const sequence = (count + 1).toString().padStart(4, '0');
    return `XIC-${year}-${sequence}`;
  }
}
