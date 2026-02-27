# Script de Seed - Base de Datos Xicam

Este script SQL pobla la base de datos con datos de ejemplo para desarrollo y pruebas.

## Contenido del Seed

### 1. Categorías (4 categorías)
- Faldas
- Pantalones
- Poleras
- Polerones

### 2. Productos (40 productos)
- **Faldas**: 5 tallas (XS, S, M, L, XL)
- **Pantalones de Franela**: 5 tallas
- **Pantalones de Gabardina**: 5 tallas
- **Poleras Polo Manga Corta**: 5 tallas
- **Poleras Polo Manga Larga**: 5 tallas
- **Poleras Pique Manga Corta**: 5 tallas
- **Poleras Pique Manga Larga**: 5 tallas
- **Polerones de Franela**: 5 tallas

Todos los productos:
- Tienen stock disponible
- Pueden ser bordados con nombre (precio adicional: $3.000)
- Tienen precios realistas para el mercado chileno
- Están activos y algunos destacados

### 3. Usuario Administrador
- **Username**: `admin`
- **Password**: `Ecq2357.`
- **Email**: `admin@xicam.com`
- **Rol**: `admin`

### 4. Clientes de Ejemplo (5 clientes)
Todos con password: `Cliente123`

1. **María González**
   - Email: `maria.gonzalez@example.com`
   - Teléfono: `+56912345678`
   - Dirección: Av. Providencia 1234, Santiago

2. **Juan Pérez**
   - Email: `juan.perez@example.com`
   - Teléfono: `+56987654321`
   - Dirección: Calle Los Rosales 567, Valparaíso

3. **Ana Martínez**
   - Email: `ana.martinez@example.com`
   - Teléfono: `+56911223344`
   - Dirección: Pasaje Las Flores 890, Concepción

4. **Carlos Rodríguez**
   - Email: `carlos.rodriguez@example.com`
   - Teléfono: `+56955667788`
   - Dirección: Av. Libertador 234, La Serena

5. **Laura Fernández**
   - Email: `laura.fernandez@example.com`
   - Teléfono: `+56999887766`
   - Dirección: Calle Principal 456, Temuco

### 5. Órdenes de Ejemplo (5 órdenes)
- **Orden 1**: María González - Entregada (con bordado)
- **Orden 2**: Juan Pérez - Enviada (con bordado)
- **Orden 3**: Ana Martínez - Procesando (con bordado)
- **Orden 4**: Carlos Rodríguez - Pendiente de pago
- **Orden 5**: Laura Fernández - Pagada (con bordado)

## Cómo Ejecutar los Scripts

⚠️ **IMPORTANTE**: Primero debes ejecutar `create_tables.sql` para crear las tablas, y luego `seed_data.sql` para poblar los datos.

### Opción 1: Desde Supabase Dashboard (Recomendado)

**Paso 1: Crear las tablas**
1. Ve a tu proyecto en Supabase
2. Abre el **SQL Editor**
3. Copia y pega el contenido de `create_tables.sql`
4. Ejecuta el script
5. Verifica que no haya errores

**Paso 2: Poblar los datos**
1. En el mismo SQL Editor
2. Copia y pega el contenido de `seed_data.sql`
3. Ejecuta el script
4. Verifica que se hayan insertado los datos

### Opción 2: Desde psql (línea de comandos)

```bash
# Primero crear las tablas
psql -h aws-0-us-west-2.pooler.supabase.com -p 6543 -U postgres.hzuyinbwebpfjckqkoxe -d postgres -f create_tables.sql

# Luego poblar los datos
psql -h aws-0-us-west-2.pooler.supabase.com -p 6543 -U postgres.hzuyinbwebpfjckqkoxe -d postgres -f seed_data.sql
```

Cuando te pida la contraseña, ingresa: `Ecq235713.-`

### Opción 3: Desde pgAdmin o DBeaver
1. Conéctate a tu base de datos Supabase
2. Abre y ejecuta primero `create_tables.sql`
3. Luego abre y ejecuta `seed_data.sql`

## Archivos del Script

1. **`create_tables.sql`**: Crea todas las tablas, enums, índices y triggers necesarios
   - ⚠️ **EJECUTAR PRIMERO** antes de seed_data.sql
   - Es idempotente: puedes ejecutarlo múltiples veces sin errores

2. **`seed_data.sql`**: Pobla la base de datos con datos de ejemplo
   - ⚠️ **EJECUTAR DESPUÉS** de create_tables.sql
   - Usa `ON CONFLICT DO NOTHING` para evitar duplicados
   - Es idempotente: puedes ejecutarlo múltiples veces sin crear duplicados

## Notas Importantes

⚠️ **ORDEN DE EJECUCIÓN**:
1. Primero ejecuta `create_tables.sql` para crear las tablas
2. Luego ejecuta `seed_data.sql` para poblar los datos

⚠️ **ADVERTENCIA**: Si quieres limpiar los datos existentes antes de ejecutar el seed, puedes ejecutar:
```sql
TRUNCATE TABLE order_items CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE products CASCADE;
TRUNCATE TABLE categories CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE users CASCADE;
```

⚠️ **IMPORTANTE**: 
- Las contraseñas están hasheadas con bcrypt (10 rounds)
- Los scripts son idempotentes: puedes ejecutarlos múltiples veces sin crear duplicados
- Los IDs se generan automáticamente con `gen_random_uuid()`
- Las tablas incluyen índices para optimizar las consultas
- Los triggers actualizan automáticamente el campo `updatedAt`

## Verificación

Después de ejecutar el script, puedes verificar los datos:

```sql
-- Verificar categorías
SELECT COUNT(*) FROM categories; -- Debe ser 4

-- Verificar productos
SELECT COUNT(*) FROM products; -- Debe ser 40

-- Verificar usuario admin
SELECT username, email, role FROM users WHERE username = 'admin';

-- Verificar clientes
SELECT COUNT(*) FROM customers; -- Debe ser 5

-- Verificar órdenes
SELECT COUNT(*) FROM orders; -- Debe ser 5

-- Verificar items de órdenes
SELECT COUNT(*) FROM order_items; -- Debe ser varios items
```

## Credenciales de Acceso

### Backoffice (Panel de Administración)
- URL: `http://localhost:3001/login` (o tu URL de producción)
- Username: `admin`
- Password: `Ecq2357.`

### Frontend Web (Tienda)
Puedes iniciar sesión con cualquiera de los clientes de ejemplo:
- Email: `maria.gonzalez@example.com` (o cualquier otro cliente)
- Password: `Cliente123`
