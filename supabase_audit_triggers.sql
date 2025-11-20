-- =====================================================
-- SISTEMA DE AUDITORÍA - TRIGGERS CORRECTOS
-- =====================================================
-- Este script implementa el sistema de auditoría de forma correcta.
-- 
-- ⚠️ PROBLEMA ANTERIOR:
-- El trigger usaba COALESCE(NEW.id, OLD.id) como usuario_id, pero ese
-- era el ID del registro modificado (producto, inventario, etc.), no
-- el ID del usuario que hizo el cambio.
--
-- ✅ SOLUCIÓN:
-- Usar auth.uid() para obtener el usuario autenticado de Supabase Auth,
-- luego buscar el correspondiente usuarios.id usando auth_user_id.
--
-- 📋 ORDEN DE EJECUCIÓN:
-- 1. Ejecutar supabase_schema_complete.sql (crear tablas)
-- 2. Ejecutar supabase_rls_policies.sql (crear políticas RLS)
-- 3. Ejecutar este archivo (habilitar auditoría)
-- =====================================================

-- ============================================
-- 1. LIMPIAR TRIGGERS Y FUNCIÓN EXISTENTES
-- ============================================
DROP TRIGGER IF EXISTS audit_productos ON public.productos CASCADE;
DROP TRIGGER IF EXISTS audit_inventarios ON public.inventarios CASCADE;
DROP TRIGGER IF EXISTS audit_movimientos ON public.movimientos CASCADE;
DROP TRIGGER IF EXISTS audit_usuarios ON public.usuarios CASCADE;
DROP TRIGGER IF EXISTS audit_proveedores ON public.proveedores CASCADE;
DROP TRIGGER IF EXISTS audit_almacenes ON public.almacenes CASCADE;
DROP TRIGGER IF EXISTS audit_tiendas ON public.tiendas CASCADE;
DROP TRIGGER IF EXISTS audit_lotes ON public.lotes CASCADE;
DROP FUNCTION IF EXISTS public.registrar_auditoria() CASCADE;

-- ============================================
-- 2. CREAR FUNCIÓN DE AUDITORÍA CORRECTA
-- ============================================
CREATE OR REPLACE FUNCTION public.registrar_auditoria()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $$
DECLARE
    v_usuario_id UUID;
    v_auth_uid UUID;
BEGIN
    -- Obtener el auth.uid() del usuario autenticado
    v_auth_uid := auth.uid();
    
    -- Si no hay usuario autenticado, no auditar
    -- (por ejemplo, durante migraciones o seeds)
    IF v_auth_uid IS NULL THEN
        RAISE LOG '[AUDIT] No hay usuario autenticado, saltando auditoría';
        RETURN COALESCE(NEW, OLD);
    END IF;
    
    -- Buscar el usuarios.id correspondiente usando auth_user_id
    SELECT id INTO v_usuario_id
    FROM public.usuarios
    WHERE auth_user_id = v_auth_uid
    AND activo = true
    LIMIT 1;
    
    -- Si no se encuentra el usuario en la tabla usuarios, registrar warning
    IF v_usuario_id IS NULL THEN
        RAISE WARNING '[AUDIT] Usuario autenticado (%) no encontrado en tabla usuarios', v_auth_uid;
        RETURN COALESCE(NEW, OLD);
    END IF;
    
    -- Insertar registro de auditoría con el usuario correcto
    BEGIN
        INSERT INTO public.auditorias (
            usuario_id,
            tabla_afectada,
            accion,
            datos_anteriores,
            datos_nuevos,
            ip_address
        ) VALUES (
            v_usuario_id,  -- ✅ CORRECTO: usuario real que hizo el cambio
            TG_TABLE_NAME,
            TG_OP,
            CASE WHEN TG_OP IN ('DELETE', 'UPDATE') THEN row_to_json(OLD) ELSE NULL END,
            CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END,
            inet_client_addr()
        );
        
        RAISE LOG '[AUDIT] Registrado: tabla=%, accion=%, usuario=%', TG_TABLE_NAME, TG_OP, v_usuario_id;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Si falla la auditoría, registrar error pero NO bloquear la operación
            RAISE WARNING '[AUDIT] Error al insertar auditoría: % - SQLSTATE: %', SQLERRM, SQLSTATE;
    END;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;

COMMENT ON FUNCTION public.registrar_auditoria IS 'Registra cambios en tablas críticas usando el usuario autenticado real';

-- ============================================
-- 3. APLICAR TRIGGERS A TABLAS CRÍTICAS
-- ============================================

-- Productos
CREATE TRIGGER audit_productos 
AFTER INSERT OR UPDATE OR DELETE ON public.productos
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Inventarios
CREATE TRIGGER audit_inventarios 
AFTER INSERT OR UPDATE OR DELETE ON public.inventarios
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Movimientos
CREATE TRIGGER audit_movimientos 
AFTER INSERT OR UPDATE OR DELETE ON public.movimientos
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Usuarios
CREATE TRIGGER audit_usuarios 
AFTER INSERT OR UPDATE OR DELETE ON public.usuarios
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Proveedores
CREATE TRIGGER audit_proveedores 
AFTER INSERT OR UPDATE OR DELETE ON public.proveedores
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Almacenes
CREATE TRIGGER audit_almacenes 
AFTER INSERT OR UPDATE OR DELETE ON public.almacenes
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Tiendas
CREATE TRIGGER audit_tiendas 
AFTER INSERT OR UPDATE OR DELETE ON public.tiendas
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- Lotes
CREATE TRIGGER audit_lotes 
AFTER INSERT OR UPDATE OR DELETE ON public.lotes
FOR EACH ROW EXECUTE FUNCTION public.registrar_auditoria();

-- ============================================
-- 4. VERIFICACIÓN
-- ============================================

-- Mostrar triggers creados
-- SELECT 
--     schemaname,
--     tablename,
--     tgname as trigger_name,
--     '✅ TRIGGER CREADO' as status
-- FROM pg_trigger t
-- JOIN pg_class c ON t.tgrelid = c.oid
-- JOIN pg_namespace n ON c.relnamespace = n.oid
-- WHERE n.nspname = 'public'
--   AND tgname LIKE 'audit_%'
--   AND NOT tgisinternal
-- ORDER BY tablename;

-- ============================================
-- 5. PRUEBA DEL SISTEMA DE AUDITORÍA
-- ============================================

-- Para probar que funciona correctamente:
-- 1. Autenticarse con un usuario en Supabase (ej: testfinal@gmail.com)
-- 2. Crear/actualizar un producto desde Flutter
-- 3. Verificar que se creó el registro en auditorias:

/*
SELECT 
    a.id,
    a.tabla_afectada,
    a.accion,
    u.email as usuario_email,
    u.nombre_completo as usuario_nombre,
    a.created_at,
    a.datos_nuevos->>'nombre' as producto_nombre
FROM public.auditorias a
JOIN public.usuarios u ON a.usuario_id = u.id
WHERE a.tabla_afectada = 'productos'
ORDER BY a.created_at DESC
LIMIT 10;
*/

-- ============================================
-- MENSAJE FINAL
-- ============================================
DO $$
BEGIN
    RAISE NOTICE '✅ Sistema de auditoría creado correctamente';
    RAISE NOTICE '📊 Tablas auditadas: productos, inventarios, movimientos, usuarios, proveedores, almacenes, tiendas, lotes';
    RAISE NOTICE '🔍 Para ver registros: SELECT * FROM auditorias ORDER BY created_at DESC;';
    RAISE NOTICE '⚠️  IMPORTANTE: La auditoría solo funciona cuando hay un usuario autenticado (auth.uid())';
    RAISE NOTICE '📝 Durante migraciones/seeds, la auditoría se salta automáticamente';
END $$;
