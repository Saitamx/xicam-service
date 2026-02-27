-- ============================================
-- XICAM - Script de Creación de Tablas
-- Base de datos: PostgreSQL (Supabase)
-- ============================================
-- Este script crea todas las tablas necesarias
-- Ejecutar ANTES de seed_data.sql
-- ============================================

-- ============================================
-- 1. CREAR ENUMS
-- ============================================

-- Enum para roles de usuario
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('admin', 'manager');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum para estados de orden
DO $$ BEGIN
    CREATE TYPE order_status AS ENUM ('pending', 'processing', 'paid', 'shipped', 'delivered', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum para métodos de pago
DO $$ BEGIN
    CREATE TYPE payment_method AS ENUM ('webpay', 'transfer', 'cash');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum para estados de pago
DO $$ BEGIN
    CREATE TYPE payment_status AS ENUM ('pending', 'approved', 'rejected', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Enum para tipos de envío
DO $$ BEGIN
    CREATE TYPE shipping_type AS ENUM ('chilexpress', 'correos_chile', 'starken', 'retiro_tienda');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================
-- 2. CREAR TABLAS (sin foreign keys primero)
-- ============================================

-- Tabla: categories
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(500),
    "order" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabla: users
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'manager',
    "fullName" VARCHAR(100),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabla: customers
CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "fullName" VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    region VARCHAR(100),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastLogin" TIMESTAMP,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabla: products (depende de categories)
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image VARCHAR(500),
    slug VARCHAR(200) NOT NULL UNIQUE,
    stock INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isFeatured" BOOLEAN NOT NULL DEFAULT false,
    "categoryId" UUID NOT NULL,
    size VARCHAR(50),
    color VARCHAR(50),
    "canBeEmbroidered" BOOLEAN NOT NULL DEFAULT false,
    "embroideryPrice" DECIMAL(10, 2) NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_product_category FOREIGN KEY ("categoryId") REFERENCES categories(id) ON DELETE RESTRICT
);

-- Tabla: orders (depende de customers)
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderNumber" VARCHAR(50) NOT NULL UNIQUE,
    "customerId" UUID,
    "customerName" VARCHAR(200) NOT NULL,
    "customerEmail" VARCHAR(255) NOT NULL,
    "customerPhone" VARCHAR(50) NOT NULL,
    "shippingAddress" TEXT,
    "shippingType" shipping_type,
    "trackingNumber" VARCHAR(255),
    subtotal DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,
    status order_status NOT NULL DEFAULT 'pending',
    "paymentMethod" payment_method NOT NULL DEFAULT 'webpay',
    "paymentStatus" payment_status NOT NULL DEFAULT 'pending',
    "webpayToken" VARCHAR(255),
    "webpayTransactionId" VARCHAR(255),
    notes TEXT,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_order_customer FOREIGN KEY ("customerId") REFERENCES customers(id) ON DELETE SET NULL
);

-- Tabla: order_items (depende de orders y products)
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "orderId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "productName" VARCHAR(200) NOT NULL,
    "unitPrice" DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    "isEmbroidered" BOOLEAN NOT NULL DEFAULT false,
    "embroideryName" VARCHAR(100),
    "embroideryPrice" DECIMAL(10, 2) NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_order_item_order FOREIGN KEY ("orderId") REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY ("productId") REFERENCES products(id) ON DELETE RESTRICT
);

-- ============================================
-- 3. CREAR ÍNDICES PARA MEJOR RENDIMIENTO
-- ============================================

CREATE INDEX IF NOT EXISTS idx_products_category ON products("categoryId");
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_active ON products("isActive");
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders("customerId");
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON orders("paymentStatus");
CREATE INDEX IF NOT EXISTS idx_orders_number ON orders("orderNumber");
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items("orderId");
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items("productId");
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================
-- 4. CREAR TRIGGERS PARA ACTUALIZAR updatedAt
-- ============================================

-- Función para actualizar updatedAt
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para cada tabla
DROP TRIGGER IF EXISTS update_categories_updated_at ON categories;
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON products;
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_customers_updated_at ON customers;
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_order_items_updated_at ON order_items;
CREATE TRIGGER update_order_items_updated_at BEFORE UPDATE ON order_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- RESUMEN
-- ============================================
-- Tablas creadas:
--   - categories
--   - users
--   - customers
--   - products
--   - orders
--   - order_items
--
-- Enums creados:
--   - user_role
--   - order_status
--   - payment_method
--   - payment_status
--   - shipping_type
--
-- Índices creados para optimización
-- Triggers creados para updatedAt automático
-- ============================================
