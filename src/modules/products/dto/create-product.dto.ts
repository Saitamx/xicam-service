import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsOptional, IsBoolean, IsUUID, Min } from 'class-validator';

export class CreateProductDto {
  @ApiProperty({ example: 'Falda Escolar', description: 'Nombre del producto' })
  @IsString()
  name: string;

  @ApiProperty({ example: 'Falda escolar para Pacific School', required: false })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ example: 15000, description: 'Precio del producto' })
  @IsNumber()
  @Min(0)
  price: number;

  @ApiProperty({ example: '/images/products/falda.jpg', required: false })
  @IsOptional()
  @IsString()
  image?: string;

  @ApiProperty({ example: 'falda-escolar', description: 'Slug del producto' })
  @IsString()
  slug: string;

  @ApiProperty({ example: 10, description: 'Stock disponible', default: 0 })
  @IsOptional()
  @IsNumber()
  stock?: number;

  @ApiProperty({ example: true, description: 'Si el producto está activo', default: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiProperty({ example: false, description: 'Si el producto está destacado', default: false })
  @IsOptional()
  @IsBoolean()
  isFeatured?: boolean;

  @ApiProperty({ example: 'uuid-category', description: 'ID de la categoría' })
  @IsUUID()
  categoryId: string;

  @ApiProperty({ example: 'Talla M', required: false })
  @IsOptional()
  @IsString()
  size?: string;

  @ApiProperty({ example: 'Azul marino', required: false })
  @IsOptional()
  @IsString()
  color?: string;

  @ApiProperty({ example: true, description: 'Si el producto puede ser bordado', default: false })
  @IsOptional()
  @IsBoolean()
  canBeEmbroidered?: boolean;

  @ApiProperty({ example: 3000, description: 'Precio adicional por bordado', default: 0 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  embroideryPrice?: number;
}
