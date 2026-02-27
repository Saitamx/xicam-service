import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Order } from './order.entity';
import { Product } from './product.entity';

@Entity('order_items')
export class OrderItem {
  @ApiProperty({ example: '1', description: 'ID del item' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ example: 'uuid-order', description: 'ID de la orden' })
  @Column({ type: 'uuid' })
  orderId: string;

  @ManyToOne(() => Order, (order) => order.items, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'orderId' })
  order: Order;

  @ApiProperty({ example: 'uuid-product', description: 'ID del producto' })
  @Column({ type: 'uuid' })
  productId: string;

  @ManyToOne(() => Product, { eager: false, nullable: true })
  @JoinColumn({ name: 'productId' })
  product: Product;

  @ApiProperty({ example: 'Falda Escolar', description: 'Nombre del producto al momento de la compra' })
  @Column({ type: 'varchar', length: 200 })
  productName: string;

  @ApiProperty({ example: 15000, description: 'Precio unitario al momento de la compra' })
  @Column({ type: 'decimal', precision: 10, scale: 2 })
  unitPrice: number;

  @ApiProperty({ example: 2, description: 'Cantidad' })
  @Column({ type: 'int' })
  quantity: number;

  @ApiProperty({ example: 30000, description: 'Subtotal del item' })
  @Column({ type: 'decimal', precision: 10, scale: 2 })
  subtotal: number;

  @ApiProperty({ 
    example: true, 
    description: 'Si el producto fue bordado con nombre' 
  })
  @Column({ type: 'boolean', default: false })
  isEmbroidered: boolean;

  @ApiProperty({ 
    example: 'Juan Pérez', 
    description: 'Nombre para bordar (si aplica)',
    required: false 
  })
  @Column({ type: 'varchar', length: 100, nullable: true })
  embroideryName: string;

  @ApiProperty({ 
    example: 3000, 
    description: 'Precio adicional por bordado' 
  })
  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  embroideryPrice: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
