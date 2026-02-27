import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ShippingType } from '../../entities/order.entity';

export interface ShippingOption {
  type: ShippingType;
  name: string;
  description: string;
  estimatedDays: number;
  price: number;
  enabled: boolean;
}

@Injectable()
export class ShippingService {
  constructor(private configService: ConfigService) {}

  /**
   * Obtiene todos los tipos de envío disponibles
   */
  getAvailableShippingTypes(): ShippingOption[] {
    return [
      {
        type: ShippingType.CHILEXPRESS,
        name: 'Chilexpress',
        description: 'Envío rápido y seguro a todo Chile',
        estimatedDays: 2,
        price: this.getShippingPrice(ShippingType.CHILEXPRESS),
        enabled: this.isShippingEnabled(ShippingType.CHILEXPRESS),
      },
      {
        type: ShippingType.CORREOS_CHILE,
        name: 'Correos de Chile',
        description: 'Envío económico por correo postal',
        estimatedDays: 5,
        price: this.getShippingPrice(ShippingType.CORREOS_CHILE),
        enabled: this.isShippingEnabled(ShippingType.CORREOS_CHILE),
      },
      {
        type: ShippingType.STARKEN,
        name: 'Starken',
        description: 'Envío confiable a todo el país',
        estimatedDays: 3,
        price: this.getShippingPrice(ShippingType.STARKEN),
        enabled: this.isShippingEnabled(ShippingType.STARKEN),
      },
      {
        type: ShippingType.RETIRO_TIENDA,
        name: 'Retiro en Tienda',
        description: 'Retira tu pedido en nuestro local',
        estimatedDays: 0,
        price: 0,
        enabled: true,
      },
    ].filter(option => option.enabled);
  }

  /**
   * Obtiene el precio de envío según el tipo
   */
  private getShippingPrice(type: ShippingType): number {
    const basePrices: Record<ShippingType, number> = {
      [ShippingType.CHILEXPRESS]: 5000,
      [ShippingType.CORREOS_CHILE]: 3000,
      [ShippingType.STARKEN]: 4500,
      [ShippingType.RETIRO_TIENDA]: 0,
    };

    const envKey = `SHIPPING_${type.toUpperCase()}_PRICE`;
    const envPrice = this.configService.get<number>(envKey);
    
    return envPrice || basePrices[type] || 0;
  }

  /**
   * Verifica si un tipo de envío está habilitado
   */
  private isShippingEnabled(type: ShippingType): boolean {
    const envKey = `SHIPPING_${type.toUpperCase()}_ENABLED`;
    const envEnabled = this.configService.get<string>(envKey);
    
    if (envEnabled !== undefined) {
      return envEnabled.toLowerCase() === 'true';
    }

    return true;
  }

  /**
   * Simula la creación de un envío con el proveedor
   */
  async createShipment(
    shippingType: ShippingType,
    orderNumber: string,
    customerName: string,
    address: string,
    phone: string,
  ): Promise<{ trackingNumber: string; estimatedDelivery: Date }> {
    const trackingNumber = this.generateTrackingNumber(shippingType);
    const estimatedDays = this.getEstimatedDays(shippingType);
    const estimatedDelivery = new Date();
    estimatedDelivery.setDate(estimatedDelivery.getDate() + estimatedDays);

    console.log(`[SIMULACIÓN] Creando envío ${shippingType} para orden ${orderNumber}`);

    return { trackingNumber, estimatedDelivery };
  }

  /**
   * Genera un número de seguimiento según el tipo
   */
  private generateTrackingNumber(type: ShippingType): string {
    const prefix: Record<ShippingType, string> = {
      [ShippingType.CHILEXPRESS]: 'CLX',
      [ShippingType.CORREOS_CHILE]: 'CCL',
      [ShippingType.STARKEN]: 'STK',
      [ShippingType.RETIRO_TIENDA]: 'RET',
    };

    const random = Math.random().toString(36).substring(2, 10).toUpperCase();
    return `${prefix[type]}-${Date.now().toString(36).toUpperCase()}-${random}`;
  }

  /**
   * Obtiene días estimados de entrega
   */
  private getEstimatedDays(type: ShippingType): number {
    const days: Record<ShippingType, number> = {
      [ShippingType.CHILEXPRESS]: 2,
      [ShippingType.CORREOS_CHILE]: 5,
      [ShippingType.STARKEN]: 3,
      [ShippingType.RETIRO_TIENDA]: 0,
    };

    return days[type] || 3;
  }
}
