# flutter_management_system

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Supabase Configuration

# ============================================
# .env.example
# ============================================
# Copia este archivo como .env y completa con tus credenciales
# NUNCA subas el archivo .env a Git

# Supabase Configuration
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-muy-larga-aqui

# Debug Mode
DEBUG_MODE=true

# ============================================
# .gitignore - Agregar estas líneas
# ============================================
# Environment files
.env
.env.local
.env.*.local

# ============================================
# GUÍA DE CONFIGURACIÓN PASO A PASO
# ============================================

# 1. CREAR PROYECTO EN SUPABASE
#    - Ve a https://supabase.com
#    - Crea una cuenta o inicia sesión
#    - Crea un nuevo proyecto
#    - Anota tu URL y ANON KEY (en Settings > API)

# 2. EJECUTAR EL SCHEMA SQL
#    - Ve a SQL Editor en Supabase Dashboard
#    - Copia y pega el contenido de supabase_config.sql
#    - Ejecuta el script
#    - Luego ejecuta supabase_rls_policies.sql

# 3. CONFIGURAR AUTENTICACIÓN
#    - Ve a Authentication > Settings en Supabase
#    - Habilita Email authentication
#    - Configura Site URL: http://localhost:3000 (desarrollo)
#    - Configura Redirect URLs para producción

# 4. CONFIGURAR STORAGE (OPCIONAL - para imágenes de productos)
#    - Ve a Storage en Supabase
#    - Crea un bucket llamado 'productos-images'
#    - Configura las políticas de acceso:

# SQL para políticas de Storage:
-- Permitir lectura pública de imágenes
CREATE POLICY "Las imágenes de productos son públicas"
ON storage.objects FOR SELECT
USING (bucket_id = 'productos-images');

-- Permitir subida de imágenes autenticadas
CREATE POLICY "Usuarios autenticados pueden subir imágenes"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'productos-images' 
  AND auth.role() = 'authenticated'
);

-- Permitir actualización de imágenes
CREATE POLICY "Usuarios autenticados pueden actualizar imágenes"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'productos-images' 
  AND auth.role() = 'authenticated'
);

# 5. CREAR USUARIO ADMIN INICIAL
#    - Ve a Authentication > Users en Supabase
#    - Crea un usuario manualmente (por ejemplo: admin@tuempresa.com)
#    - Ejecuta este SQL para asignar rol de admin:

INSERT INTO public.usuarios (
  email, 
  nombre_completo, 
  rol_id, 
  auth_user_id, 
  activo
) VALUES (
  'admin@tuempresa.com',
  'Administrador del Sistema',
  '00000000-0000-0000-0000-000000000001', -- ID del rol Administrador
  'UUID-DEL-USUARIO-AUTH', -- Copiar del panel de Authentication
  true
);

# 6. CONFIGURAR VARIABLES DE ENTORNO EN FLUTTER
#    - Copia .env.example como .env
#    - Completa con tus credenciales de Supabase
#    - Para compilar con las variables:

# Desarrollo (usando valores del .env)
flutter run --dart-define-from-file=.env

# Producción
flutter build apk --dart-define=SUPABASE_URL=tu-url --dart-define=SUPABASE_ANON_KEY=tu-key

# 7. PROBAR LA CONEXIÓN
#    - Ejecuta tu app Flutter
#    - Intenta hacer login con el usuario admin
#    - Verifica que puedes crear/leer datos

# ============================================
# COMANDOS ÚTILES PARA DESARROLLO
# ============================================

# Instalar dependencias
flutter pub get

# Generar código de Drift
flutter pub run build_runner build --delete-conflicting-outputs

# Generar código en modo watch (desarrollo)
flutter pub run build_runner watch --delete-conflicting-outputs

# Limpiar y regenerar
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar app con variables de entorno
flutter run --dart-define-from-file=.env

# ============================================
# ESTRUCTURA DE CARPETAS PARA ASSETS
# ============================================
# Crear estas carpetas en tu proyecto:
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p assets/logos
mkdir -p assets/fonts

# ============================================
# CONFIGURACIÓN DE REALTIME (OPCIONAL)
# ============================================
# Para habilitar actualizaciones en tiempo real:

# 1. En Supabase Dashboard > Database > Replication
#    - Habilita replicación para las tablas que necesites en tiempo real
#    - Ejemplo: productos, inventarios, movimientos

# 2. En tu código Flutter:
final channel = supabase
  .channel('public:productos')
  .onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'productos',
    callback: (payload) {
      print('Cambio detectado: ${payload.newRecord}');
    },
  )
  .subscribe();

# ============================================
# TESTING DE LA BASE DE DATOS
# ============================================
# Queries de prueba para verificar que todo funciona:

-- Verificar roles
SELECT * FROM public.roles;

-- Verificar categorías
SELECT * FROM public.categorias;

-- Verificar unidades de medida
SELECT * FROM public.unidades_medida;

-- Verificar que RLS está habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND rowsecurity = true;

-- Verificar políticas RLS
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';

# ============================================
# BACKUP Y RESTORE
# ============================================
# Hacer backup de la base de datos:
# En Supabase Dashboard > Database > Backups
# O usar pg_dump si tienes acceso directo

# Restore desde SQL:
# Supabase Dashboard > SQL Editor > pegar tu backup y ejecutar

# ============================================
# MONITORING Y LOGS
# ============================================
# Ver logs en tiempo real:
# Supabase Dashboard > Logs > Postgres Logs
# Supabase Dashboard > Logs > API Logs

# ============================================
# SEGURIDAD - CHECKLIST
# ============================================
# ✅ RLS habilitado en todas las tablas
# ✅ Políticas RLS configuradas correctamente
# ✅ Variables de entorno no commiteadas (.env en .gitignore)
# ✅ ANON_KEY es pública, SERVICE_KEY es privada (no usar en frontend)
# ✅ Auth configurada con PKCE flow
# ✅ Validaciones en el backend (triggers y funciones)
# ✅ Auditoría habilitada en tablas críticas

# ============================================
# TROUBLESHOOTING
# ============================================

# Error: "relation does not exist"
# Solución: Verificar que ejecutaste todo el schema SQL

# Error: "permission denied for table"
# Solución: Revisar políticas RLS, puede que falte una policy

# Error: "JWT expired"
# Solución: El token expiró, implementar refresh automático

# Error: "row level security policy violation"
# Solución: El usuario no tiene permisos según las políticas RLS

# No se sincronizan cambios en realtime
# Solución: Habilitar replicación en Database > Replication

# ============================================
# NEXT STEPS
# ============================================
# 1. Implementar Sync Manager para offline-first
# 2. Configurar los Repositories
# 3. Implementar los BLoCs con HydratedBloc
# 4. Crear las pantallas de UI
# 5. Implementar estrategia de manejo de conflictos
