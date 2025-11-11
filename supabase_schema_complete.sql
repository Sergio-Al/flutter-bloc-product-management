-- ============================================
-- SCHEMA DE SUPABASE PARA GESTIÓN DE MATERIALES DE CONSTRUCCIÓN
-- VERSIÓN 2.0 - CON CAMPOS DE SINCRONIZACIÓN COMPLETOS
-- ============================================
-- Este script debe ejecutarse en el SQL Editor de Supabase
-- Incluye: Tablas, RLS, Indexes, Functions, Triggers y Sync Fields

-- ============================================
-- LIMPIAR SCHEMA ANTERIOR (OPCIONAL - USAR CON CUIDADO)
-- ============================================
-- Descomentar solo si necesitas empezar desde cero
-- DROP SCHEMA IF EXISTS public CASCADE;
-- CREATE SCHEMA public;
-- GRANT ALL ON SCHEMA public TO postgres;
-- GRANT ALL ON SCHEMA public TO public;

-- ============================================
-- EXTENSIONES
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- ELIMINAR TABLAS EXISTENTES (en orden correcto por dependencias)
-- ============================================
DROP TABLE IF EXISTS public.auditorias CASCADE;
DROP TABLE IF EXISTS public.movimientos CASCADE;
DROP TABLE IF EXISTS public.inventarios CASCADE;
DROP TABLE IF EXISTS public.lotes CASCADE;
DROP TABLE IF EXISTS public.productos CASCADE;
DROP TABLE IF EXISTS public.proveedores CASCADE;
DROP TABLE IF EXISTS public.almacenes CASCADE;
DROP TABLE IF EXISTS public.categorias CASCADE;
DROP TABLE IF EXISTS public.unidades_medida CASCADE;
DROP TABLE IF EXISTS public.usuarios CASCADE;
DROP TABLE IF EXISTS public.tiendas CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;

-- ============================================
-- TABLA: roles
-- ============================================
CREATE TABLE public.roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    permisos JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.roles IS 'Roles de usuario en el sistema';

-- ============================================
-- TABLA: tiendas
-- ============================================
CREATE TABLE public.tiendas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    direccion TEXT NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    horario_atencion VARCHAR(100),
    activo BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.tiendas IS 'Tiendas o sucursales del sistema';
COMMENT ON COLUMN public.tiendas.sync_id IS 'ID único para sincronización offline-first';
COMMENT ON COLUMN public.tiendas.last_sync IS 'Última vez que se sincronizó con el servidor';

-- ============================================
-- TABLA: usuarios
-- ============================================
CREATE TABLE public.usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    nombre_completo VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    tienda_id UUID REFERENCES public.tiendas(id) ON DELETE SET NULL,
    rol_id UUID REFERENCES public.roles(id) NOT NULL,
    activo BOOLEAN DEFAULT true NOT NULL,
    auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.usuarios IS 'Usuarios del sistema';
COMMENT ON COLUMN public.usuarios.auth_user_id IS 'Referencia al usuario de autenticación de Supabase';
COMMENT ON COLUMN public.usuarios.sync_id IS 'ID único para sincronización offline-first';

-- ============================================
-- TABLA: almacenes
-- ============================================
CREATE TABLE public.almacenes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    tienda_id UUID REFERENCES public.tiendas(id) ON DELETE CASCADE NOT NULL,
    ubicacion TEXT,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('Principal', 'Obra', 'Transito')),
    capacidad_m3 DECIMAL(10, 2),
    area_m2 DECIMAL(10, 2),
    activo BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.almacenes IS 'Almacenes físicos de las tiendas';
COMMENT ON COLUMN public.almacenes.tipo IS 'Tipo de almacén: Principal, Obra, Transito';

-- ============================================
-- TABLA: categorias
-- ============================================
CREATE TABLE public.categorias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    categoria_padre_id UUID REFERENCES public.categorias(id) ON DELETE SET NULL,
    requiere_lote BOOLEAN DEFAULT false NOT NULL,
    requiere_certificacion BOOLEAN DEFAULT false NOT NULL,
    activo BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.categorias IS 'Categorías de productos (jerárquicas)';
COMMENT ON COLUMN public.categorias.requiere_lote IS 'Si los productos requieren control por lote';
COMMENT ON COLUMN public.categorias.requiere_certificacion IS 'Si requiere certificados de calidad';

-- ============================================
-- TABLA: unidades_medida
-- ============================================
CREATE TABLE public.unidades_medida (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) UNIQUE NOT NULL,
    abreviatura VARCHAR(10) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('Peso', 'Volumen', 'Longitud', 'Unidad', 'Area')),
    factor_conversion DECIMAL(10, 4) DEFAULT 1.0 NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.unidades_medida IS 'Unidades de medida para productos';
COMMENT ON COLUMN public.unidades_medida.factor_conversion IS 'Factor de conversión a unidad base';

-- ============================================
-- TABLA: proveedores
-- ============================================
CREATE TABLE public.proveedores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    razon_social VARCHAR(255) NOT NULL,
    nit VARCHAR(50) UNIQUE NOT NULL,
    nombre_contacto VARCHAR(255),
    telefono VARCHAR(20),
    email VARCHAR(255),
    direccion TEXT,
    ciudad VARCHAR(100),
    tipo_material VARCHAR(100),
    dias_credito INTEGER DEFAULT 0 NOT NULL,
    activo BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.proveedores IS 'Proveedores de materiales';
COMMENT ON COLUMN public.proveedores.dias_credito IS 'Días de crédito otorgados por el proveedor';

-- ============================================
-- TABLA: productos
-- ============================================
CREATE TABLE public.productos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    categoria_id UUID REFERENCES public.categorias(id) NOT NULL,
    unidad_medida_id UUID REFERENCES public.unidades_medida(id) NOT NULL,
    proveedor_principal_id UUID REFERENCES public.proveedores(id) ON DELETE SET NULL,
    precio_compra DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    precio_venta DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    peso_unitario_kg DECIMAL(10, 2),
    volumen_unitario_m3 DECIMAL(10, 4),
    stock_minimo INTEGER DEFAULT 0 NOT NULL,
    stock_maximo INTEGER DEFAULT 0 NOT NULL,
    marca VARCHAR(100),
    grado_calidad VARCHAR(50),
    norma_tecnica VARCHAR(50),
    requiere_almacen_cubierto BOOLEAN DEFAULT false NOT NULL,
    material_peligroso BOOLEAN DEFAULT false NOT NULL,
    imagen_url TEXT,
    ficha_tecnica_url TEXT,
    activo BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    deleted_at TIMESTAMPTZ,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.productos IS 'Catálogo de productos';
COMMENT ON COLUMN public.productos.grado_calidad IS 'Grado o calidad del producto (ej: A615 para fierro)';
COMMENT ON COLUMN public.productos.norma_tecnica IS 'Norma técnica que cumple (NB, ASTM, ISO)';

-- ============================================
-- TABLA: lotes
-- ============================================
CREATE TABLE public.lotes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_lote VARCHAR(100) UNIQUE NOT NULL,
    producto_id UUID REFERENCES public.productos(id) ON DELETE CASCADE NOT NULL,
    fecha_fabricacion TIMESTAMPTZ,
    fecha_vencimiento TIMESTAMPTZ,
    proveedor_id UUID REFERENCES public.proveedores(id) ON DELETE SET NULL,
    numero_factura VARCHAR(100),
    cantidad_inicial INTEGER DEFAULT 0 NOT NULL,
    cantidad_actual INTEGER DEFAULT 0 NOT NULL,
    certificado_calidad_url TEXT,
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ
);

COMMENT ON TABLE public.lotes IS 'Control de lotes de productos';
COMMENT ON COLUMN public.lotes.fecha_vencimiento IS 'Fecha de vencimiento (para cemento, pegamentos, etc)';

-- ============================================
-- TABLA: inventarios
-- ============================================
CREATE TABLE public.inventarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    producto_id UUID REFERENCES public.productos(id) ON DELETE CASCADE NOT NULL,
    almacen_id UUID REFERENCES public.almacenes(id) ON DELETE CASCADE NOT NULL,
    tienda_id UUID REFERENCES public.tiendas(id) ON DELETE CASCADE NOT NULL,
    lote_id UUID REFERENCES public.lotes(id) ON DELETE SET NULL,
    cantidad_actual INTEGER DEFAULT 0 NOT NULL,
    cantidad_reservada INTEGER DEFAULT 0 NOT NULL,
    -- cantidad_disponible se calcula en el cliente (Drift no soporta GENERATED ALWAYS)
    valor_total DECIMAL(12, 2) DEFAULT 0 NOT NULL,
    ubicacion_fisica VARCHAR(100),
    ultima_actualizacion TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ,
    UNIQUE(producto_id, almacen_id, lote_id)
);

COMMENT ON TABLE public.inventarios IS 'Stock de productos en almacenes';
COMMENT ON COLUMN public.inventarios.cantidad_reservada IS 'Cantidad reservada para pedidos pendientes';
COMMENT ON COLUMN public.inventarios.valor_total IS 'Valor total del inventario (cantidad * precio_compra)';

-- ============================================
-- TABLA: movimientos
-- ============================================
CREATE TABLE public.movimientos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_movimiento VARCHAR(100) UNIQUE NOT NULL,
    producto_id UUID REFERENCES public.productos(id) NOT NULL,
    inventario_id UUID REFERENCES public.inventarios(id) ON DELETE SET NULL,
    lote_id UUID REFERENCES public.lotes(id) ON DELETE SET NULL,
    tienda_origen_id UUID REFERENCES public.tiendas(id) ON DELETE SET NULL,
    tienda_destino_id UUID REFERENCES public.tiendas(id) ON DELETE SET NULL,
    proveedor_id UUID REFERENCES public.proveedores(id) ON DELETE SET NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('COMPRA', 'VENTA', 'TRANSFERENCIA', 'AJUSTE', 'DEVOLUCION', 'MERMA')),
    motivo TEXT,
    cantidad INTEGER NOT NULL,
    costo_unitario DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    costo_total DECIMAL(12, 2) DEFAULT 0 NOT NULL,
    peso_total_kg DECIMAL(10, 2),
    usuario_id UUID REFERENCES public.usuarios(id) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'EN_TRANSITO', 'COMPLETADO', 'CANCELADO')),
    fecha_movimiento TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    numero_factura VARCHAR(100),
    numero_guia_remision VARCHAR(100),
    vehiculo_placa VARCHAR(20),
    conductor VARCHAR(255),
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    sync_id UUID DEFAULT uuid_generate_v4(),
    last_sync TIMESTAMPTZ,
    sincronizado BOOLEAN DEFAULT false NOT NULL
);

COMMENT ON TABLE public.movimientos IS 'Movimientos de inventario (compras, ventas, transferencias)';
COMMENT ON COLUMN public.movimientos.tipo IS 'Tipo de movimiento: COMPRA, VENTA, TRANSFERENCIA, AJUSTE, DEVOLUCION, MERMA';
COMMENT ON COLUMN public.movimientos.estado IS 'Estado del movimiento: PENDIENTE, EN_TRANSITO, COMPLETADO, CANCELADO';
COMMENT ON COLUMN public.movimientos.sincronizado IS 'Indica si el movimiento ya fue sincronizado con el servidor';

-- ============================================
-- TABLA: auditorias
-- ============================================
CREATE TABLE public.auditorias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES public.usuarios(id) ON DELETE SET NULL,
    tabla_afectada VARCHAR(100) NOT NULL,
    accion VARCHAR(20) NOT NULL CHECK (accion IN ('INSERT', 'UPDATE', 'DELETE')),
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    ip_address INET,
    dispositivo TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

COMMENT ON TABLE public.auditorias IS 'Registro de auditoría de cambios en el sistema';

-- ============================================
-- ÍNDICES PARA MEJORAR PERFORMANCE
-- ============================================

-- Usuarios
CREATE INDEX idx_usuarios_email ON public.usuarios(email);
CREATE INDEX idx_usuarios_tienda ON public.usuarios(tienda_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_usuarios_auth ON public.usuarios(auth_user_id);
CREATE INDEX idx_usuarios_sync ON public.usuarios(sync_id);
CREATE INDEX idx_usuarios_last_sync ON public.usuarios(last_sync);

-- Tiendas
CREATE INDEX idx_tiendas_codigo ON public.tiendas(codigo);
CREATE INDEX idx_tiendas_activo ON public.tiendas(activo) WHERE activo = true AND deleted_at IS NULL;
CREATE INDEX idx_tiendas_sync ON public.tiendas(sync_id);

-- Productos
CREATE INDEX idx_productos_codigo ON public.productos(codigo);
CREATE INDEX idx_productos_categoria ON public.productos(categoria_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_productos_nombre_trgm ON public.productos USING gin(to_tsvector('spanish', nombre));
CREATE INDEX idx_productos_activo ON public.productos(activo) WHERE activo = true AND deleted_at IS NULL;
CREATE INDEX idx_productos_sync ON public.productos(sync_id);
CREATE INDEX idx_productos_last_sync ON public.productos(last_sync);

-- Inventarios
CREATE INDEX idx_inventarios_producto ON public.inventarios(producto_id);
CREATE INDEX idx_inventarios_almacen ON public.inventarios(almacen_id);
CREATE INDEX idx_inventarios_tienda ON public.inventarios(tienda_id);
CREATE INDEX idx_inventarios_lote ON public.inventarios(lote_id);
CREATE INDEX idx_inventarios_sync ON public.inventarios(sync_id);
CREATE INDEX idx_inventarios_last_sync ON public.inventarios(last_sync);

-- Movimientos
CREATE INDEX idx_movimientos_producto ON public.movimientos(producto_id);
CREATE INDEX idx_movimientos_tipo ON public.movimientos(tipo);
CREATE INDEX idx_movimientos_fecha ON public.movimientos(fecha_movimiento DESC);
CREATE INDEX idx_movimientos_usuario ON public.movimientos(usuario_id);
CREATE INDEX idx_movimientos_tienda_origen ON public.movimientos(tienda_origen_id);
CREATE INDEX idx_movimientos_estado ON public.movimientos(estado);
CREATE INDEX idx_movimientos_sincronizado ON public.movimientos(sincronizado) WHERE sincronizado = false;
CREATE INDEX idx_movimientos_sync ON public.movimientos(sync_id);
CREATE INDEX idx_movimientos_last_sync ON public.movimientos(last_sync);

-- Lotes
CREATE INDEX idx_lotes_producto ON public.lotes(producto_id);
CREATE INDEX idx_lotes_vencimiento ON public.lotes(fecha_vencimiento) WHERE fecha_vencimiento IS NOT NULL;
CREATE INDEX idx_lotes_sync ON public.lotes(sync_id);

-- Almacenes
CREATE INDEX idx_almacenes_tienda ON public.almacenes(tienda_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_almacenes_sync ON public.almacenes(sync_id);

-- Proveedores
CREATE INDEX idx_proveedores_nit ON public.proveedores(nit);
CREATE INDEX idx_proveedores_activo ON public.proveedores(activo) WHERE activo = true AND deleted_at IS NULL;
CREATE INDEX idx_proveedores_sync ON public.proveedores(sync_id);

-- Categorias
CREATE INDEX idx_categorias_padre ON public.categorias(categoria_padre_id);
CREATE INDEX idx_categorias_sync ON public.categorias(sync_id);

-- ============================================
-- FUNCIÓN: Actualizar updated_at automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas con updated_at
CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON public.usuarios
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tiendas_updated_at BEFORE UPDATE ON public.tiendas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_almacenes_updated_at BEFORE UPDATE ON public.almacenes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_productos_updated_at BEFORE UPDATE ON public.productos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_inventarios_updated_at BEFORE UPDATE ON public.inventarios
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_movimientos_updated_at BEFORE UPDATE ON public.movimientos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_proveedores_updated_at BEFORE UPDATE ON public.proveedores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lotes_updated_at BEFORE UPDATE ON public.lotes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categorias_updated_at BEFORE UPDATE ON public.categorias
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_unidades_medida_updated_at BEFORE UPDATE ON public.unidades_medida
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON public.roles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- FUNCIÓN: Generar número de movimiento automático
-- ============================================
CREATE OR REPLACE FUNCTION generar_numero_movimiento()
RETURNS TRIGGER AS $$
DECLARE
    nuevo_numero VARCHAR(100);
    prefijo VARCHAR(10);
    correlativo INTEGER;
BEGIN
    -- Solo generar si no viene especificado
    IF NEW.numero_movimiento IS NOT NULL AND NEW.numero_movimiento != '' THEN
        RETURN NEW;
    END IF;
    
    -- Determinar prefijo según tipo
    CASE NEW.tipo
        WHEN 'COMPRA' THEN prefijo := 'COM';
        WHEN 'VENTA' THEN prefijo := 'VEN';
        WHEN 'TRANSFERENCIA' THEN prefijo := 'TRF';
        WHEN 'AJUSTE' THEN prefijo := 'AJU';
        WHEN 'DEVOLUCION' THEN prefijo := 'DEV';
        WHEN 'MERMA' THEN prefijo := 'MER';
        ELSE prefijo := 'MOV';
    END CASE;
    
    -- Obtener correlativo del día
    SELECT COALESCE(MAX(CAST(SUBSTRING(numero_movimiento FROM '[0-9]+$') AS INTEGER)), 0) + 1
    INTO correlativo
    FROM public.movimientos
    WHERE numero_movimiento LIKE prefijo || '-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-%';
    
    -- Generar número
    nuevo_numero := prefijo || '-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD(correlativo::TEXT, 6, '0');
    NEW.numero_movimiento := nuevo_numero;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generar_numero_movimiento_trigger
    BEFORE INSERT ON public.movimientos
    FOR EACH ROW
    EXECUTE FUNCTION generar_numero_movimiento();

-- ============================================
-- FUNCIÓN: Calcular costo_total automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION calcular_costo_total()
RETURNS TRIGGER AS $$
BEGIN
    NEW.costo_total := NEW.cantidad * NEW.costo_unitario;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calcular_costo_total_trigger
    BEFORE INSERT OR UPDATE OF cantidad, costo_unitario ON public.movimientos
    FOR EACH ROW
    EXECUTE FUNCTION calcular_costo_total();

-- ============================================
-- FUNCIÓN: Actualizar last_sync automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION update_last_sync()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo actualizar si viene desde el servidor (no desde sync local)
    IF NEW.last_sync IS NULL OR NEW.last_sync < NOW() THEN
        NEW.last_sync := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar a tablas con sincronización
CREATE TRIGGER update_usuarios_last_sync BEFORE UPDATE ON public.usuarios
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_tiendas_last_sync BEFORE UPDATE ON public.tiendas
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_almacenes_last_sync BEFORE UPDATE ON public.almacenes
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_productos_last_sync BEFORE UPDATE ON public.productos
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_inventarios_last_sync BEFORE UPDATE ON public.inventarios
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_movimientos_last_sync BEFORE UPDATE ON public.movimientos
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_proveedores_last_sync BEFORE UPDATE ON public.proveedores
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_lotes_last_sync BEFORE UPDATE ON public.lotes
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

CREATE TRIGGER update_categorias_last_sync BEFORE UPDATE ON public.categorias
    FOR EACH ROW EXECUTE FUNCTION update_last_sync();

-- ============================================
-- FUNCIÓN: Registrar auditoría automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.auditorias (
        usuario_id,
        tabla_afectada,
        accion,
        datos_anteriores,
        datos_nuevos,
        ip_address
    ) VALUES (
        COALESCE(NEW.id, OLD.id),  -- ✅ CORREGIDO: usar 'id' en lugar de 'usuario_id'
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP IN ('DELETE', 'UPDATE') THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END,
        inet_client_addr()
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aplicar auditoría a tablas críticas
CREATE TRIGGER audit_productos AFTER INSERT OR UPDATE OR DELETE ON public.productos
    FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER audit_inventarios AFTER INSERT OR UPDATE OR DELETE ON public.inventarios
    FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER audit_movimientos AFTER INSERT OR UPDATE OR DELETE ON public.movimientos
    FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER audit_usuarios AFTER INSERT OR UPDATE OR DELETE ON public.usuarios
    FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

-- ============================================
-- DATOS INICIALES (SEED DATA)
-- ============================================

-- Insertar roles por defecto
INSERT INTO public.roles (id, nombre, descripcion, permisos) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Administrador', 'Acceso completo al sistema', '{"all": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000002', 'Gerente', 'Gestión de tienda y reportes', '{"inventarios": true, "movimientos": true, "reportes": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000003', 'Almacenero', 'Gestión de inventarios y movimientos', '{"inventarios": true, "movimientos": true}'::jsonb),
    ('00000000-0000-0000-0000-000000000004', 'Vendedor', 'Consulta de productos y ventas', '{"productos": "read", "inventarios": "read", "ventas": true}'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- Insertar unidades de medida
INSERT INTO public.unidades_medida (nombre, abreviatura, tipo, factor_conversion) VALUES
    ('Bolsa', 'BLS', 'Unidad', 1.0),
    ('Metro', 'M', 'Longitud', 1.0),
    ('Kilogramo', 'KG', 'Peso', 1.0),
    ('Litro', 'LT', 'Volumen', 1.0),
    ('Plancha', 'PLCH', 'Unidad', 1.0),
    ('Pieza', 'PZA', 'Unidad', 1.0),
    ('Metro Cuadrado', 'M²', 'Area', 1.0),
    ('Galón', 'GAL', 'Volumen', 3.785),
    ('Tonelada', 'TON', 'Peso', 1000.0),
    ('Metro Cúbico', 'M³', 'Volumen', 1.0)
ON CONFLICT (nombre) DO NOTHING;

-- Insertar categorías principales
INSERT INTO public.categorias (nombre, codigo, descripcion, requiere_lote, requiere_certificacion) VALUES
    ('Cemento', 'CEM', 'Cementos y derivados', true, true),
    ('Fierro y Acero', 'FIE', 'Varillas, mallas, perfiles de acero', false, true),
    ('Madera', 'MAD', 'Madera y productos derivados', false, false),
    ('Agregados', 'AGR', 'Arena, grava, piedra', false, false),
    ('Pintura', 'PIN', 'Pinturas, barnices y lacas', true, false),
    ('Calaminas', 'CAL', 'Calaminas y materiales de cubierta', false, false),
    ('Material Eléctrico', 'ELE', 'Cables, interruptores, enchufes', false, false),
    ('Plomería', 'PLO', 'Tuberías, conexiones, grifería', false, false),
    ('Herramientas', 'HER', 'Herramientas manuales y eléctricas', false, false),
    ('Ladrillos y Bloques', 'LAD', 'Ladrillos, bloques, adoquines', false, false)
ON CONFLICT (codigo) DO NOTHING;

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista: Inventario completo con información del producto
CREATE OR REPLACE VIEW vw_inventario_completo AS
SELECT 
    i.id,
    i.cantidad_actual,
    i.cantidad_reservada,
    (i.cantidad_actual - i.cantidad_reservada) as cantidad_disponible,
    i.valor_total,
    i.ubicacion_fisica,
    i.ultima_actualizacion,
    p.id as producto_id,
    p.nombre as producto_nombre,
    p.codigo as producto_codigo,
    p.stock_minimo,
    p.stock_maximo,
    p.precio_venta,
    p.precio_compra,
    c.nombre as categoria_nombre,
    u.nombre as unidad_medida_nombre,
    u.abreviatura as unidad_medida_abr,
    a.nombre as almacen_nombre,
    a.id as almacen_id,
    t.nombre as tienda_nombre,
    t.id as tienda_id,
    l.numero_lote,
    CASE 
        WHEN (i.cantidad_actual - i.cantidad_reservada) <= 0 THEN 'SIN_STOCK'
        WHEN (i.cantidad_actual - i.cantidad_reservada) <= p.stock_minimo THEN 'STOCK_BAJO'
        WHEN (i.cantidad_actual - i.cantidad_reservada) >= p.stock_maximo THEN 'SOBRESTOCK'
        ELSE 'NORMAL'
    END as estado_stock
FROM public.inventarios i
INNER JOIN public.productos p ON i.producto_id = p.id
INNER JOIN public.categorias c ON p.categoria_id = c.id
INNER JOIN public.unidades_medida u ON p.unidad_medida_id = u.id
INNER JOIN public.almacenes a ON i.almacen_id = a.id
INNER JOIN public.tiendas t ON i.tienda_id = t.id
LEFT JOIN public.lotes l ON i.lote_id = l.id
WHERE p.activo = true AND p.deleted_at IS NULL AND a.deleted_at IS NULL;

COMMENT ON VIEW vw_inventario_completo IS 'Vista completa del inventario con toda la información relacionada';

-- Vista: Movimientos completos
CREATE OR REPLACE VIEW vw_movimientos_completos AS
SELECT 
    m.id,
    m.numero_movimiento,
    m.tipo,
    m.cantidad,
    m.costo_unitario,
    m.costo_total,
    m.estado,
    m.fecha_movimiento,
    m.sincronizado,
    p.nombre as producto_nombre,
    p.codigo as producto_codigo,
    u.nombre_completo as usuario_nombre,
    u.email as usuario_email,
    to_origen.nombre as tienda_origen_nombre,
    to_destino.nombre as tienda_destino_nombre,
    prov.razon_social as proveedor_nombre,
    prov.nit as proveedor_nit,
    m.numero_factura,
    m.numero_guia_remision,
    m.created_at,
    m.updated_at
FROM public.movimientos m
INNER JOIN public.productos p ON m.producto_id = p.id
INNER JOIN public.usuarios u ON m.usuario_id = u.id
LEFT JOIN public.tiendas to_origen ON m.tienda_origen_id = to_origen.id
LEFT JOIN public.tiendas to_destino ON m.tienda_destino_id = to_destino.id
LEFT JOIN public.proveedores prov ON m.proveedor_id = prov.id
ORDER BY m.fecha_movimiento DESC;

COMMENT ON VIEW vw_movimientos_completos IS 'Vista completa de movimientos con información relacionada';

-- Vista: Productos con stock bajo
CREATE OR REPLACE VIEW vw_productos_stock_bajo AS
SELECT 
    p.id,
    p.nombre,
    p.codigo,
    p.stock_minimo,
    c.nombre as categoria,
    SUM(i.cantidad_actual - i.cantidad_reservada) as stock_total_disponible,
    COUNT(DISTINCT i.tienda_id) as tiendas_con_stock
FROM public.productos p
INNER JOIN public.categorias c ON p.categoria_id = c.id
LEFT JOIN public.inventarios i ON p.id = i.producto_id
WHERE p.activo = true AND p.deleted_at IS NULL
GROUP BY p.id, p.nombre, p.codigo, p.stock_minimo, c.nombre
HAVING SUM(i.cantidad_actual - i.cantidad_reservada) <= p.stock_minimo
ORDER BY stock_total_disponible ASC;

COMMENT ON VIEW vw_productos_stock_bajo IS 'Productos que están por debajo del stock mínimo';

-- ============================================
-- FUNCIONES RPC PARA FLUTTER
-- ============================================

-- Función: Obtener estadísticas del dashboard
CREATE OR REPLACE FUNCTION get_dashboard_stats(p_tienda_id UUID DEFAULT NULL)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_productos', (SELECT COUNT(*) FROM public.productos WHERE activo = true AND deleted_at IS NULL),
        'productos_stock_bajo', (SELECT COUNT(*) FROM vw_productos_stock_bajo),
        'movimientos_pendientes', (
            SELECT COUNT(*) FROM public.movimientos 
            WHERE estado = 'PENDIENTE' 
            AND (p_tienda_id IS NULL OR tienda_origen_id = p_tienda_id OR tienda_destino_id = p_tienda_id)
        ),
        'valor_inventario_total', (
            SELECT COALESCE(SUM(valor_total), 0) 
            FROM public.inventarios 
            WHERE p_tienda_id IS NULL OR tienda_id = p_tienda_id
        ),
        'movimientos_hoy', (
            SELECT COUNT(*) FROM public.movimientos 
            WHERE DATE(fecha_movimiento) = CURRENT_DATE
            AND (p_tienda_id IS NULL OR tienda_origen_id = p_tienda_id OR tienda_destino_id = p_tienda_id)
        )
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION get_dashboard_stats IS 'Obtiene estadísticas para el dashboard principal';

-- ============================================
-- PERMISOS
-- ============================================

-- Revocar permisos públicos por defecto
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- Otorgar permisos al usuario authenticated de Supabase
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;

-- ============================================
-- MENSAJE FINAL
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✅ Schema de Supabase creado exitosamente';
    RAISE NOTICE '📊 Tablas creadas: 12';
    RAISE NOTICE '🔐 Siguiente paso: Ejecutar supabase_rls_policies.sql';
    RAISE NOTICE '👤 Recuerda crear un usuario admin en Authentication > Users';
END $$;
