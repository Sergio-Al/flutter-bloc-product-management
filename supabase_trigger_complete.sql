-- =====================================================
-- TRIGGER COMPLETO: Creación Automática de Perfil de Usuario
-- =====================================================
-- Este script configura el trigger que crea automáticamente un perfil
-- en la tabla 'usuarios' cuando se registra un nuevo usuario en Supabase Auth.
--
-- Ejecutar este script en Supabase SQL Editor
-- =====================================================

-- 1. LIMPIAR triggers y funciones existentes
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users CASCADE;
DROP FUNCTION IF EXISTS public.handle_new_user() CASCADE;

-- 2. LIMPIAR políticas RLS existentes
DROP POLICY IF EXISTS "Service role full access" ON public.usuarios;
DROP POLICY IF EXISTS "Users can view own profile" ON public.usuarios;
DROP POLICY IF EXISTS "Users can update own profile" ON public.usuarios;

-- 3. CREAR políticas RLS para acceso del trigger y usuarios
-- Política para service_role (permite al trigger insertar datos)
CREATE POLICY "Service role full access"
ON public.usuarios
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- Política para que usuarios puedan ver su propio perfil
CREATE POLICY "Users can view own profile"
ON public.usuarios
FOR SELECT
TO authenticated
USING (auth_user_id = auth.uid());

-- Política para que usuarios puedan actualizar su propio perfil
CREATE POLICY "Users can update own profile"
ON public.usuarios
FOR UPDATE
TO authenticated
USING (auth_user_id = auth.uid())
WITH CHECK (auth_user_id = auth.uid());

-- 4. CREAR función del trigger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
    v_role_id uuid;
    v_tienda_id uuid;
BEGIN
    -- Log de inicio
    RAISE LOG '[TRIGGER] Iniciando handle_new_user para NEW.id=% email=%', NEW.id, NEW.email;

    -- Obtener el rol por defecto (vendedor)
    SELECT id INTO v_role_id
    FROM public.roles
    WHERE LOWER(nombre) = 'vendedor'
    LIMIT 1;

    IF v_role_id IS NULL THEN
        RAISE LOG '[TRIGGER] ERROR: No se encontró el rol vendedor';
        RAISE EXCEPTION 'No se encontró el rol vendedor en la tabla roles';
    END IF;

    RAISE LOG '[TRIGGER] Rol encontrado: %', v_role_id;

    -- Obtener la primera tienda activa
    SELECT id INTO v_tienda_id
    FROM public.tiendas
    WHERE activo = true
    ORDER BY created_at ASC
    LIMIT 1;

    IF v_tienda_id IS NULL THEN
        RAISE LOG '[TRIGGER] ERROR: No se encontró tienda activa';
        RAISE EXCEPTION 'No se encontró una tienda activa en la tabla tiendas';
    END IF;

    RAISE LOG '[TRIGGER] Tienda encontrada: %', v_tienda_id;

    -- Insertar el usuario en public.usuarios con todos los campos requeridos
    INSERT INTO public.usuarios (
        id,
        email,
        nombre_completo,
        rol_id,
        tienda_id,
        activo,
        created_at,
        updated_at,
        auth_user_id,
        telefono
    ) VALUES (
        NEW.id,                                                      -- uuid del usuario en auth.users
        NEW.email,                                                   -- email
        COALESCE(NEW.raw_user_meta_data->>'nombre_completo', NEW.email), -- nombre o email por defecto
        v_role_id,                                                   -- rol vendedor
        v_tienda_id,                                                 -- primera tienda activa
        true,                                                        -- usuario activo
        NOW(),                                                       -- created_at
        NOW(),                                                       -- updated_at
        NEW.id,                                                      -- mismo id para auth_user_id
        NEW.raw_user_meta_data->>'telefono'                        -- telefono del metadata
    );

    RAISE LOG '[TRIGGER] Usuario creado exitosamente: id=%', NEW.id;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE LOG '[TRIGGER] ERROR CRÍTICO: % - SQLSTATE: %', SQLERRM, SQLSTATE;
        RAISE;
END;
$function$;

-- 5. CORREGIR función de auditoría (si existe)
-- Esta función se ejecuta después de INSERT/UPDATE/DELETE en usuarios
-- Debe usar 'id' en lugar de 'usuario_id'
CREATE OR REPLACE FUNCTION public.registrar_auditoria()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
    INSERT INTO public.auditorias (
        usuario_id,
        tabla_afectada,
        accion,
        datos_anteriores,
        datos_nuevos,
        ip_address
    ) VALUES (
        COALESCE(NEW.id, OLD.id),  -- Usar 'id' en lugar de 'usuario_id'
        TG_TABLE_NAME,
        TG_OP,
        CASE WHEN TG_OP IN ('DELETE', 'UPDATE') THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP IN ('INSERT', 'UPDATE') THEN row_to_json(NEW) ELSE NULL END,
        inet_client_addr()
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$function$;

-- 6. CREAR el trigger en auth.users
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- 7. HABILITAR RLS en la tabla usuarios
ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

-- 8. VERIFICACIÓN: Mostrar el trigger creado
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    '✅ TRIGGER CREADO CORRECTAMENTE' as status
FROM information_schema.triggers
WHERE event_object_schema = 'auth'
  AND event_object_table = 'users'
  AND trigger_name = 'on_auth_user_created';

-- 9. VERIFICACIÓN: Mostrar las políticas RLS
SELECT 
    schemaname,
    tablename,
    policyname,
    roles,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'usuarios';

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
-- Después de ejecutar este script:
-- 1. Los nuevos usuarios se crearán automáticamente en la tabla 'usuarios'
-- 2. Se les asignará el rol 'vendedor' por defecto
-- 3. Se les asignará la primera tienda activa
-- 4. Los usuarios podrán ver y actualizar su propio perfil
-- =====================================================
