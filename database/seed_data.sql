-- ============================================
-- XICAM - Script de Seed Completo
-- Base de datos: PostgreSQL (Supabase)
-- ============================================
-- Este script crea:
-- 1. Categorías de productos
-- 2. Productos (uniformes escolares)
-- 3. Usuario administrador
-- 4. Clientes de ejemplo
-- 5. Órdenes de ejemplo
-- ============================================

-- Limpiar datos existentes (opcional - comentar si no quieres borrar datos)
-- TRUNCATE TABLE order_items CASCADE;
-- TRUNCATE TABLE orders CASCADE;
-- TRUNCATE TABLE products CASCADE;
-- TRUNCATE TABLE categories CASCADE;
-- TRUNCATE TABLE customers CASCADE;
-- TRUNCATE TABLE users CASCADE;

-- ============================================
-- 1. CATEGORÍAS
-- ============================================
INSERT INTO categories (id, name, slug, description, image, "order", "isActive", "createdAt", "updatedAt")
VALUES
  (gen_random_uuid(), 'Faldas', 'faldas', 'Faldas escolares para Pacific School', '/images/categories/faldas.jpg', 1, true, NOW(), NOW()),
  (gen_random_uuid(), 'Pantalones', 'pantalones', 'Pantalones de franela y gabardina para Pacific School', '/images/categories/pantalones.jpg', 2, true, NOW(), NOW()),
  (gen_random_uuid(), 'Poleras', 'poleras', 'Poleras polo y pique manga corta y larga para Pacific School', '/images/categories/poleras.jpg', 3, true, NOW(), NOW()),
  (gen_random_uuid(), 'Polerones', 'polerones', 'Polerones de franela para Pacific School', '/images/categories/polerones.jpg', 4, true, NOW(), NOW())
ON CONFLICT (slug) DO NOTHING;

-- Guardar IDs de categorías en variables temporales
DO $$
DECLARE
  cat_faldas_id UUID;
  cat_pantalones_id UUID;
  cat_poleras_id UUID;
  cat_polerones_id UUID;
BEGIN
  SELECT id INTO cat_faldas_id FROM categories WHERE slug = 'faldas';
  SELECT id INTO cat_pantalones_id FROM categories WHERE slug = 'pantalones';
  SELECT id INTO cat_poleras_id FROM categories WHERE slug = 'poleras';
  SELECT id INTO cat_polerones_id FROM categories WHERE slug = 'polerones';

  -- ============================================
  -- 2. PRODUCTOS
  -- ============================================
  
  -- FALDAS
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Falda Escolar - Talla XS', 'Falda escolar para Pacific School, talla XS. Disponible con bordado de nombre.', 15000, '/images/products/falda-xs.jpg', 'falda-escolar-xs', 25, true, true, cat_faldas_id, 'XS', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Falda Escolar - Talla S', 'Falda escolar para Pacific School, talla S. Disponible con bordado de nombre.', 15000, '/images/products/falda-s.jpg', 'falda-escolar-s', 30, true, true, cat_faldas_id, 'S', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Falda Escolar - Talla M', 'Falda escolar para Pacific School, talla M. Disponible con bordado de nombre.', 15000, '/images/products/falda-m.jpg', 'falda-escolar-m', 35, true, true, cat_faldas_id, 'M', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Falda Escolar - Talla L', 'Falda escolar para Pacific School, talla L. Disponible con bordado de nombre.', 15000, '/images/products/falda-l.jpg', 'falda-escolar-l', 28, true, false, cat_faldas_id, 'L', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Falda Escolar - Talla XL', 'Falda escolar para Pacific School, talla XL. Disponible con bordado de nombre.', 15000, '/images/products/falda-xl.jpg', 'falda-escolar-xl', 20, true, false, cat_faldas_id, 'XL', 'Azul marino', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- PANTALONES DE FRANELA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Pantalón de Franela - Talla XS', 'Pantalón de franela para Pacific School, talla XS. Disponible con bordado de nombre.', 18000, '/images/products/pantalon-franela-xs.jpg', 'pantalon-franela-xs', 20, true, true, cat_pantalones_id, 'XS', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Franela - Talla S', 'Pantalón de franela para Pacific School, talla S. Disponible con bordado de nombre.', 18000, '/images/products/pantalon-franela-s.jpg', 'pantalon-franela-s', 25, true, true, cat_pantalones_id, 'S', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Franela - Talla M', 'Pantalón de franela para Pacific School, talla M. Disponible con bordado de nombre.', 18000, '/images/products/pantalon-franela-m.jpg', 'pantalon-franela-m', 30, true, true, cat_pantalones_id, 'M', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Franela - Talla L', 'Pantalón de franela para Pacific School, talla L. Disponible con bordado de nombre.', 18000, '/images/products/pantalon-franela-l.jpg', 'pantalon-franela-l', 22, true, false, cat_pantalones_id, 'L', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Franela - Talla XL', 'Pantalón de franela para Pacific School, talla XL. Disponible con bordado de nombre.', 18000, '/images/products/pantalon-franela-xl.jpg', 'pantalon-franela-xl', 18, true, false, cat_pantalones_id, 'XL', 'Gris', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- PANTALONES DE GABARDINA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Pantalón de Gabardina - Talla XS', 'Pantalón de gabardina para Pacific School, talla XS. Disponible con bordado de nombre.', 22000, '/images/products/pantalon-gabardina-xs.jpg', 'pantalon-gabardina-xs', 18, true, true, cat_pantalones_id, 'XS', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Gabardina - Talla S', 'Pantalón de gabardina para Pacific School, talla S. Disponible con bordado de nombre.', 22000, '/images/products/pantalon-gabardina-s.jpg', 'pantalon-gabardina-s', 22, true, true, cat_pantalones_id, 'S', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Gabardina - Talla M', 'Pantalón de gabardina para Pacific School, talla M. Disponible con bordado de nombre.', 22000, '/images/products/pantalon-gabardina-m.jpg', 'pantalon-gabardina-m', 28, true, true, cat_pantalones_id, 'M', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Gabardina - Talla L', 'Pantalón de gabardina para Pacific School, talla L. Disponible con bordado de nombre.', 22000, '/images/products/pantalon-gabardina-l.jpg', 'pantalon-gabardina-l', 20, true, false, cat_pantalones_id, 'L', 'Azul marino', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Pantalón de Gabardina - Talla XL', 'Pantalón de gabardina para Pacific School, talla XL. Disponible con bordado de nombre.', 22000, '/images/products/pantalon-gabardina-xl.jpg', 'pantalon-gabardina-xl', 15, true, false, cat_pantalones_id, 'XL', 'Azul marino', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- POLERAS POLO MANGA CORTA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Polera Polo Manga Corta - Talla XS', 'Polera polo manga corta para Pacific School, talla XS. Disponible con bordado de nombre.', 12000, '/images/products/polo-mc-xs.jpg', 'polera-polo-mc-xs', 30, true, true, cat_poleras_id, 'XS', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Corta - Talla S', 'Polera polo manga corta para Pacific School, talla S. Disponible con bordado de nombre.', 12000, '/images/products/polo-mc-s.jpg', 'polera-polo-mc-s', 35, true, true, cat_poleras_id, 'S', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Corta - Talla M', 'Polera polo manga corta para Pacific School, talla M. Disponible con bordado de nombre.', 12000, '/images/products/polo-mc-m.jpg', 'polera-polo-mc-m', 40, true, true, cat_poleras_id, 'M', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Corta - Talla L', 'Polera polo manga corta para Pacific School, talla L. Disponible con bordado de nombre.', 12000, '/images/products/polo-mc-l.jpg', 'polera-polo-mc-l', 32, true, false, cat_poleras_id, 'L', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Corta - Talla XL', 'Polera polo manga corta para Pacific School, talla XL. Disponible con bordado de nombre.', 12000, '/images/products/polo-mc-xl.jpg', 'polera-polo-mc-xl', 25, true, false, cat_poleras_id, 'XL', 'Blanco', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- POLERAS POLO MANGA LARGA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Polera Polo Manga Larga - Talla XS', 'Polera polo manga larga para Pacific School, talla XS. Disponible con bordado de nombre.', 14000, '/images/products/polo-ml-xs.jpg', 'polera-polo-ml-xs', 28, true, true, cat_poleras_id, 'XS', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Larga - Talla S', 'Polera polo manga larga para Pacific School, talla S. Disponible con bordado de nombre.', 14000, '/images/products/polo-ml-s.jpg', 'polera-polo-ml-s', 32, true, true, cat_poleras_id, 'S', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Larga - Talla M', 'Polera polo manga larga para Pacific School, talla M. Disponible con bordado de nombre.', 14000, '/images/products/polo-ml-m.jpg', 'polera-polo-ml-m', 38, true, true, cat_poleras_id, 'M', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Larga - Talla L', 'Polera polo manga larga para Pacific School, talla L. Disponible con bordado de nombre.', 14000, '/images/products/polo-ml-l.jpg', 'polera-polo-ml-l', 30, true, false, cat_poleras_id, 'L', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Polo Manga Larga - Talla XL', 'Polera polo manga larga para Pacific School, talla XL. Disponible con bordado de nombre.', 14000, '/images/products/polo-ml-xl.jpg', 'polera-polo-ml-xl', 22, true, false, cat_poleras_id, 'XL', 'Blanco', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- POLERAS PIQUE MANGA CORTA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Polera Pique Manga Corta - Talla XS', 'Polera pique manga corta para Pacific School, talla XS. Disponible con bordado de nombre.', 11000, '/images/products/pique-mc-xs.jpg', 'polera-pique-mc-xs', 28, true, true, cat_poleras_id, 'XS', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Corta - Talla S', 'Polera pique manga corta para Pacific School, talla S. Disponible con bordado de nombre.', 11000, '/images/products/pique-mc-s.jpg', 'polera-pique-mc-s', 33, true, true, cat_poleras_id, 'S', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Corta - Talla M', 'Polera pique manga corta para Pacific School, talla M. Disponible con bordado de nombre.', 11000, '/images/products/pique-mc-m.jpg', 'polera-pique-mc-m', 38, true, true, cat_poleras_id, 'M', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Corta - Talla L', 'Polera pique manga corta para Pacific School, talla L. Disponible con bordado de nombre.', 11000, '/images/products/pique-mc-l.jpg', 'polera-pique-mc-l', 30, true, false, cat_poleras_id, 'L', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Corta - Talla XL', 'Polera pique manga corta para Pacific School, talla XL. Disponible con bordado de nombre.', 11000, '/images/products/pique-mc-xl.jpg', 'polera-pique-mc-xl', 24, true, false, cat_poleras_id, 'XL', 'Blanco', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- POLERAS PIQUE MANGA LARGA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Polera Pique Manga Larga - Talla XS', 'Polera pique manga larga para Pacific School, talla XS. Disponible con bordado de nombre.', 13000, '/images/products/pique-ml-xs.jpg', 'polera-pique-ml-xs', 26, true, true, cat_poleras_id, 'XS', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Larga - Talla S', 'Polera pique manga larga para Pacific School, talla S. Disponible con bordado de nombre.', 13000, '/images/products/pique-ml-s.jpg', 'polera-pique-ml-s', 30, true, true, cat_poleras_id, 'S', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Larga - Talla M', 'Polera pique manga larga para Pacific School, talla M. Disponible con bordado de nombre.', 13000, '/images/products/pique-ml-m.jpg', 'polera-pique-ml-m', 36, true, true, cat_poleras_id, 'M', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Larga - Talla L', 'Polera pique manga larga para Pacific School, talla L. Disponible con bordado de nombre.', 13000, '/images/products/pique-ml-l.jpg', 'polera-pique-ml-l', 28, true, false, cat_poleras_id, 'L', 'Blanco', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polera Pique Manga Larga - Talla XL', 'Polera pique manga larga para Pacific School, talla XL. Disponible con bordado de nombre.', 13000, '/images/products/pique-ml-xl.jpg', 'polera-pique-ml-xl', 20, true, false, cat_poleras_id, 'XL', 'Blanco', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;

  -- POLERONES DE FRANELA
  INSERT INTO products (id, name, description, price, image, slug, stock, "isActive", "isFeatured", "categoryId", size, color, "canBeEmbroidered", "embroideryPrice", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Polerón de Franela - Talla XS', 'Polerón de franela para Pacific School, talla XS. Disponible con bordado de nombre.', 25000, '/images/products/poleron-franela-xs.jpg', 'poleron-franela-xs', 20, true, true, cat_polerones_id, 'XS', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polerón de Franela - Talla S', 'Polerón de franela para Pacific School, talla S. Disponible con bordado de nombre.', 25000, '/images/products/poleron-franela-s.jpg', 'poleron-franela-s', 24, true, true, cat_polerones_id, 'S', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polerón de Franela - Talla M', 'Polerón de franela para Pacific School, talla M. Disponible con bordado de nombre.', 25000, '/images/products/poleron-franela-m.jpg', 'poleron-franela-m', 28, true, true, cat_polerones_id, 'M', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polerón de Franela - Talla L', 'Polerón de franela para Pacific School, talla L. Disponible con bordado de nombre.', 25000, '/images/products/poleron-franela-l.jpg', 'poleron-franela-l', 22, true, false, cat_polerones_id, 'L', 'Gris', true, 3000, NOW(), NOW()),
    (gen_random_uuid(), 'Polerón de Franela - Talla XL', 'Polerón de franela para Pacific School, talla XL. Disponible con bordado de nombre.', 25000, '/images/products/poleron-franela-xl.jpg', 'poleron-franela-xl', 18, true, false, cat_polerones_id, 'XL', 'Gris', true, 3000, NOW(), NOW())
  ON CONFLICT (slug) DO NOTHING;
END $$;

-- ============================================
-- 3. USUARIO ADMINISTRADOR
-- ============================================
-- Password: Ecq2357.
-- Hash bcrypt generado con 10 rounds
INSERT INTO users (id, username, email, password, role, "fullName", "isActive", "createdAt", "updatedAt")
VALUES (
  gen_random_uuid(),
  'admin',
  'admin@xicam.com',
  '$2b$10$UaqS/3IvZQr825gEiTUYOupes8qp/HjvqC3WmDqoDhcqvpu4I2Xhu', -- Ecq2357.
  'admin',
  'Administrador Xicam',
  true,
  NOW(),
  NOW()
)
ON CONFLICT (username) DO UPDATE SET
  password = '$2b$10$UaqS/3IvZQr825gEiTUYOupes8qp/HjvqC3WmDqoDhcqvpu4I2Xhu',
  "isActive" = true,
  "updatedAt" = NOW();

-- ============================================
-- 4. CLIENTES DE EJEMPLO
-- ============================================
-- Password para todos los clientes de ejemplo: Cliente123
-- Hash bcrypt generado con 10 rounds
DO $$
DECLARE
  customer1_id UUID;
  customer2_id UUID;
  customer3_id UUID;
  customer4_id UUID;
  customer5_id UUID;
  order1_id UUID;
  order2_id UUID;
  order3_id UUID;
  order4_id UUID;
  order5_id UUID;
BEGIN
  INSERT INTO customers (id, "fullName", email, phone, password, address, city, region, "isActive", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'María González', 'maria.gonzalez@example.com', '+56912345678', '$2b$10$68MyJO7NNnirC7attUkOq.wVu9xc0LhRQBTQ5IU5PcAnNXVE92YSa', 'Av. Providencia 1234', 'Santiago', 'Región Metropolitana', true, NOW(), NOW())
  RETURNING id INTO customer1_id;

  INSERT INTO customers (id, "fullName", email, phone, password, address, city, region, "isActive", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Juan Pérez', 'juan.perez@example.com', '+56987654321', '$2b$10$68MyJO7NNnirC7attUkOq.wVu9xc0LhRQBTQ5IU5PcAnNXVE92YSa', 'Calle Los Rosales 567', 'Valparaíso', 'Región de Valparaíso', true, NOW(), NOW())
  RETURNING id INTO customer2_id;

  INSERT INTO customers (id, "fullName", email, phone, password, address, city, region, "isActive", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Ana Martínez', 'ana.martinez@example.com', '+56911223344', '$2b$10$68MyJO7NNnirC7attUkOq.wVu9xc0LhRQBTQ5IU5PcAnNXVE92YSa', 'Pasaje Las Flores 890', 'Concepción', 'Región del Biobío', true, NOW(), NOW())
  RETURNING id INTO customer3_id;

  INSERT INTO customers (id, "fullName", email, phone, password, address, city, region, "isActive", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Carlos Rodríguez', 'carlos.rodriguez@example.com', '+56955667788', '$2b$10$68MyJO7NNnirC7attUkOq.wVu9xc0LhRQBTQ5IU5PcAnNXVE92YSa', 'Av. Libertador 234', 'La Serena', 'Región de Coquimbo', true, NOW(), NOW())
  RETURNING id INTO customer4_id;

  INSERT INTO customers (id, "fullName", email, phone, password, address, city, region, "isActive", "createdAt", "updatedAt")
  VALUES
    (gen_random_uuid(), 'Laura Fernández', 'laura.fernandez@example.com', '+56999887766', '$2b$10$68MyJO7NNnirC7attUkOq.wVu9xc0LhRQBTQ5IU5PcAnNXVE92YSa', 'Calle Principal 456', 'Temuco', 'Región de La Araucanía', true, NOW(), NOW())
  RETURNING id INTO customer5_id;

  -- ============================================
  -- 5. ÓRDENES DE EJEMPLO
  -- ============================================
  -- Orden 1: María González - Pagada y Entregada
  INSERT INTO orders (id, "orderNumber", "customerId", "customerName", "customerEmail", "customerPhone", "shippingAddress", "shippingType", "subtotal", discount, total, status, "paymentMethod", "paymentStatus", "webpayTransactionId", "trackingNumber", notes, "createdAt", "updatedAt")
  VALUES (
    gen_random_uuid(),
    'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD('1'::text, 6, '0'),
    customer1_id,
    'María González',
    'maria.gonzalez@example.com',
    '+56912345678',
    'Av. Providencia 1234, Santiago',
    'chilexpress',
    48000.00,
    0.00,
    48000.00,
    'delivered',
    'webpay',
    'approved',
    'TXN123456789',
    'CHX1234567890',
    'Entregado en recepción',
    NOW() - INTERVAL '15 days',
    NOW() - INTERVAL '5 days'
  )
  RETURNING id INTO order1_id;

  -- Items de la orden 1
  INSERT INTO order_items (id, "orderId", "productId", "productName", "unitPrice", quantity, subtotal, "isEmbroidered", "embroideryName", "embroideryPrice", "createdAt", "updatedAt")
  SELECT
    gen_random_uuid(),
    order1_id,
    (SELECT id FROM products WHERE slug = 'falda-escolar-m' LIMIT 1),
    'Falda Escolar - Talla M',
    15000.00,
    2,
    36000.00, -- 2 * (15000 + 3000)
    true,
    'María González',
    3000.00,
    NOW() - INTERVAL '15 days',
    NOW() - INTERVAL '15 days'
  UNION ALL
  SELECT
    gen_random_uuid(),
    order1_id,
    (SELECT id FROM products WHERE slug = 'polera-polo-mc-m' LIMIT 1),
    'Polera Polo Manga Corta - Talla M',
    12000.00,
    1,
    12000.00,
    false,
    NULL,
    0.00,
    NOW() - INTERVAL '15 days',
    NOW() - INTERVAL '15 days';

  -- Orden 2: Juan Pérez - Pagada y Enviada
  INSERT INTO orders (id, "orderNumber", "customerId", "customerName", "customerEmail", "customerPhone", "shippingAddress", "shippingType", "subtotal", discount, total, status, "paymentMethod", "paymentStatus", "webpayTransactionId", "trackingNumber", notes, "createdAt", "updatedAt")
  VALUES (
    gen_random_uuid(),
    'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD('2'::text, 6, '0'),
    customer2_id,
    'Juan Pérez',
    'juan.perez@example.com',
    '+56987654321',
    'Calle Los Rosales 567, Valparaíso',
    'correos_chile',
    55000.00,
    0.00,
    55000.00,
    'shipped',
    'webpay',
    'approved',
    'TXN987654321',
    'CC9876543210',
    'En tránsito',
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '2 days'
  )
  RETURNING id INTO order2_id;

  -- Items de la orden 2
  INSERT INTO order_items (id, "orderId", "productId", "productName", "unitPrice", quantity, subtotal, "isEmbroidered", "embroideryName", "embroideryPrice", "createdAt", "updatedAt")
  SELECT
    gen_random_uuid(),
    order2_id,
    (SELECT id FROM products WHERE slug = 'pantalon-gabardina-m' LIMIT 1),
    'Pantalón de Gabardina - Talla M',
    22000.00,
    1,
    25000.00, -- 22000 + 3000
    true,
    'Juan Pérez',
    3000.00,
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '10 days'
  UNION ALL
  SELECT
    gen_random_uuid(),
    order2_id,
    (SELECT id FROM products WHERE slug = 'polera-polo-ml-m' LIMIT 1),
    'Polera Polo Manga Larga - Talla M',
    14000.00,
    1,
    17000.00, -- 14000 + 3000
    true,
    'Juan Pérez',
    3000.00,
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '10 days'
  UNION ALL
  SELECT
    gen_random_uuid(),
    order2_id,
    (SELECT id FROM products WHERE slug = 'poleron-franela-m' LIMIT 1),
    'Polerón de Franela - Talla M',
    25000.00,
    1,
    25000.00,
    false,
    NULL,
    0.00,
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '10 days';

  -- Orden 3: Ana Martínez - Pagada y Procesando
  INSERT INTO orders (id, "orderNumber", "customerId", "customerName", "customerEmail", "customerPhone", "shippingAddress", "shippingType", "subtotal", discount, total, status, "paymentMethod", "paymentStatus", "webpayTransactionId", "trackingNumber", notes, "createdAt", "updatedAt")
  VALUES (
    gen_random_uuid(),
    'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD('3'::text, 6, '0'),
    customer3_id,
    'Ana Martínez',
    'ana.martinez@example.com',
    '+56911223344',
    'Pasaje Las Flores 890, Concepción',
    'starken',
    36000.00,
    0.00,
    36000.00,
    'processing',
    'webpay',
    'approved',
    'TXN456789123',
    NULL,
    'Preparando pedido',
    NOW() - INTERVAL '5 days',
    NOW() - INTERVAL '1 day'
  )
  RETURNING id INTO order3_id;

  -- Items de la orden 3
  INSERT INTO order_items (id, "orderId", "productId", "productName", "unitPrice", quantity, subtotal, "isEmbroidered", "embroideryName", "embroideryPrice", "createdAt", "updatedAt")
  SELECT
    gen_random_uuid(),
    order3_id,
    (SELECT id FROM products WHERE slug = 'falda-escolar-s' LIMIT 1),
    'Falda Escolar - Talla S',
    15000.00,
    2,
    36000.00, -- 2 * (15000 + 3000)
    true,
    'Ana Martínez',
    3000.00,
    NOW() - INTERVAL '5 days',
    NOW() - INTERVAL '5 days';

  -- Orden 4: Carlos Rodríguez - Pendiente de Pago
  INSERT INTO orders (id, "orderNumber", "customerId", "customerName", "customerEmail", "customerPhone", "shippingAddress", "shippingType", "subtotal", discount, total, status, "paymentMethod", "paymentStatus", "webpayToken", "trackingNumber", notes, "createdAt", "updatedAt")
  VALUES (
    gen_random_uuid(),
    'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD('4'::text, 6, '0'),
    customer4_id,
    'Carlos Rodríguez',
    'carlos.rodriguez@example.com',
    '+56955667788',
    'Av. Libertador 234, La Serena',
    'retiro_tienda',
    25000.00,
    0.00,
    25000.00,
    'pending',
    'webpay',
    'pending',
    'WEBPAY_TOKEN_PENDING',
    NULL,
    'Pendiente de pago',
    NOW() - INTERVAL '2 days',
    NOW() - INTERVAL '2 days'
  )
  RETURNING id INTO order4_id;

  -- Items de la orden 4
  INSERT INTO order_items (id, "orderId", "productId", "productName", "unitPrice", quantity, subtotal, "isEmbroidered", "embroideryName", "embroideryPrice", "createdAt", "updatedAt")
  SELECT
    gen_random_uuid(),
    order4_id,
    (SELECT id FROM products WHERE slug = 'poleron-franela-l' LIMIT 1),
    'Polerón de Franela - Talla L',
    25000.00,
    1,
    25000.00,
    false,
    NULL,
    0.00,
    NOW() - INTERVAL '2 days',
    NOW() - INTERVAL '2 days';

  -- Orden 5: Laura Fernández - Pagada
  INSERT INTO orders (id, "orderNumber", "customerId", "customerName", "customerEmail", "customerPhone", "shippingAddress", "shippingType", "subtotal", discount, total, status, "paymentMethod", "paymentStatus", "webpayTransactionId", "trackingNumber", notes, "createdAt", "updatedAt")
  VALUES (
    gen_random_uuid(),
    'ORD-' || TO_CHAR(NOW(), 'YYYY') || '-' || LPAD('5'::text, 6, '0'),
    customer5_id,
    'Laura Fernández',
    'laura.fernandez@example.com',
    '+56999887766',
    'Calle Principal 456, Temuco',
    'chilexpress',
    72000.00,
    0.00,
    72000.00,
    'paid',
    'webpay',
    'approved',
    'TXN789123456',
    NULL,
    'Pago confirmado, preparando envío',
    NOW() - INTERVAL '1 day',
    NOW() - INTERVAL '1 day'
  )
  RETURNING id INTO order5_id;

  -- Items de la orden 5
  INSERT INTO order_items (id, "orderId", "productId", "productName", "unitPrice", quantity, subtotal, "isEmbroidered", "embroideryName", "embroideryPrice", "createdAt", "updatedAt")
  SELECT
    gen_random_uuid(),
    order5_id,
    (SELECT id FROM products WHERE slug = 'pantalon-franela-m' LIMIT 1),
    'Pantalón de Franela - Talla M',
    18000.00,
    2,
    42000.00, -- 2 * (18000 + 3000)
    true,
    'Laura Fernández',
    3000.00,
    NOW() - INTERVAL '1 day',
    NOW() - INTERVAL '1 day'
  UNION ALL
  SELECT
    gen_random_uuid(),
    order5_id,
    (SELECT id FROM products WHERE slug = 'polera-pique-mc-m' LIMIT 1),
    'Polera Pique Manga Corta - Talla M',
    11000.00,
    2,
    28000.00, -- 2 * (11000 + 3000)
    true,
    'Laura Fernández',
    3000.00,
    NOW() - INTERVAL '1 day',
    NOW() - INTERVAL '1 day'
  UNION ALL
  SELECT
    gen_random_uuid(),
    order5_id,
    (SELECT id FROM products WHERE slug = 'polera-pique-ml-m' LIMIT 1),
    'Polera Pique Manga Larga - Talla M',
    13000.00,
    1,
    13000.00,
    false,
    NULL,
    0.00,
    NOW() - INTERVAL '1 day',
    NOW() - INTERVAL '1 day';
END $$;

-- ============================================
-- RESUMEN
-- ============================================
-- Usuario Admin:
--   Username: admin
--   Password: Ecq2357.
--   Email: admin@xicam.com
--
-- Clientes de ejemplo (todos con password: Cliente123):
--   1. maria.gonzalez@example.com
--   2. juan.perez@example.com
--   3. ana.martinez@example.com
--   4. carlos.rodriguez@example.com
--   5. laura.fernandez@example.com
--
-- Productos creados: 40 productos (8 tipos x 5 tallas)
-- Categorías creadas: 4 categorías
-- Órdenes creadas: 5 órdenes con diferentes estados
-- ============================================
