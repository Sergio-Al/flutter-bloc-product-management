-- =============================================================================
-- Trigger para crear automáticamente un perfil de usuario en la tabla usuarios
-- cuando se registra un nuevo usuario en Supabase Auth
-- =============================================================================

-- 1. Primero, necesitas obtener el UUID del rol por defecto
-- Ejecuta esto para ver los roles disponibles:
-- SELECT id, nombre FROM public.roles;

-- 2. Reemplaza 'ROLE_UUID_AQUI' con el UUID real del rol por defecto
-- Por ejemplo: '550e8400-e29b-41d4-a716-446655440000'

-- Función que se ejecuta cuando se crea un nuevo usuario en auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  default_role_id UUID;
BEGIN
  -- Obtener el rol por defecto (por ejemplo, "Vendedor" o "Empleado")
  -- Ajusta el nombre del rol según tu base de datos
  SELECT id INTO default_role_id 
  FROM public.roles 
  WHERE nombre = 'Vendedor' 
  LIMIT 1;

  -- Si no existe el rol "Vendedor", usar el primer rol disponible
  IF default_role_id IS NULL THEN
    SELECT id INTO default_role_id 
    FROM public.roles 
    ORDER BY created_at ASC 
    LIMIT 1;
  END IF;

  -- Crear el perfil de vendedor en la tabla usuarios
  INSERT INTO public.usuarios (
    id,
    auth_user_id,
    email,
    nombre_completo,
    telefono,
    rol_id,
    activo,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nombre_completo', NEW.email),
    NEW.raw_user_meta_data->>'telefono',
    COALESCE(default_role_id, '00000000-0000-0000-0000-000000000004'),
    true,
    NOW(),
    NOW()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger que se ejecuta DESPUÉS de insertar un vendedor en auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =============================================================================
-- Notas de uso:
-- 1. Ejecuta este script en el SQL Editor de Supabase
-- 2. Asegúrate de tener al menos un rol creado en la tabla public.roles
-- 3. El trigger creará automáticamente un perfil de usuario cuando alguien se registre
-- 4. Los datos del usuario (nombre_completo, telefono) se toman del campo 
--    raw_user_meta_data que se envía durante el registro
-- =============================================================================

-- Para verificar que el trigger funciona:
-- 1. Registra un nuevo usuario desde la app
-- 2. Ejecuta: SELECT * FROM public.usuarios WHERE email = 'email@del.usuario';
-- 3. Deberías ver el perfil creado automáticamente

-- Para eliminar el trigger si es necesario:
-- DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
-- DROP FUNCTION IF EXISTS public.handle_new_user();
