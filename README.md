# Flutter Management System

Sistema de gestión de productos para materiales de construcción con sincronización offline-first y backend en Supabase.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración de Supabase](#configuración-de-supabase)
- [Variables de Entorno](#variables-de-entorno)
- [Comandos Útiles](#comandos-útiles)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Testing](#testing)
- [Seguridad](#seguridad)
- [Troubleshooting](#troubleshooting)

## 📝 Descripción

Sistema de gestión empresarial para control de inventarios, productos, proveedores y movimientos de almacén. Utiliza arquitectura Clean Architecture con patrón BLoC y capacidades offline-first mediante SQLite local sincronizado con Supabase.

## ✨ Características

- 🔄 Sincronización offline-first con Supabase
- 📦 Gestión de productos, inventarios y almacenes
- 👥 Control de usuarios con roles y permisos
- 🏪 Múltiples tiendas y proveedores
- 📊 Seguimiento de movimientos de inventario
- 🔐 Autenticación segura con RLS (Row Level Security)
- 🎨 Tema personalizado y UI moderna
- 📱 Multiplataforma (iOS, Android)

## 📦 Requisitos Previos

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Cuenta en [Supabase](https://supabase.com)
- IDE: VS Code o Android Studio

## 🚀 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/flutter_management_system.git
cd flutter_management_system

# Instalar dependencias
flutter pub get

# Generar código de Drift
flutter pub run build_runner build --delete-conflicting-outputs
```

## ⚙️ Configuración de Supabase

### Paso 1: Crear Proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com)
2. Crea una cuenta o inicia sesión
3. Crea un nuevo proyecto
4. Anota tu **URL** y **ANON KEY** (en Settings > API)

### Paso 2: Ejecutar el Schema SQL

1. Ve a **SQL Editor** en Supabase Dashboard
2. Copia y pega el contenido de `supabase_config.sql`
3. Ejecuta el script
4. Luego ejecuta `supabase_rls_policies.sql`

### Paso 3: Configurar Autenticación

1. Ve a **Authentication > Settings** en Supabase
2. Habilita **Email authentication**
3. Configura **Site URL**: `http://localhost:3000` (desarrollo)
4. Configura **Redirect URLs** para producción

### Paso 4: Configurar Storage (Opcional)

Para habilitar imágenes de productos:

1. Ve a **Storage** en Supabase
2. Crea un bucket llamado `productos-images`
3. Ejecuta estas políticas SQL:

```sql
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
```

### Paso 5: Crear Usuario Admin Inicial

1. Ve a **Authentication > Users** en Supabase
2. Crea un usuario manualmente (ejemplo: `admin@tuempresa.com`)
3. Ejecuta este SQL para asignar rol de admin:

```sql
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
```

### Paso 6: Probar la Conexión

1. Ejecuta tu app Flutter
2. Intenta hacer login con el usuario admin
3. Verifica que puedes crear/leer datos

## 🔐 Variables de Entorno

### Archivo `.env.example`

```bash
# Supabase Configuration
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-muy-larga-aqui

# Debug Mode
DEBUG_MODE=true
```

### Configuración

1. Copia `.env.example` como `.env`
2. Completa con tus credenciales de Supabase
3. **NUNCA** subas el archivo `.env` a Git

### Agregar a `.gitignore`

```
# Environment files
.env
.env.local
.env.*.local
```

### Ejecutar con Variables de Entorno

```bash
# Desarrollo (usando valores del .env)
flutter run --dart-define-from-file=.env

# Producción
flutter build apk --dart-define=SUPABASE_URL=tu-url --dart-define=SUPABASE_ANON_KEY=tu-key
```

## 🛠️ Comandos Útiles

### Desarrollo

```bash
# Instalar dependencias
flutter pub get

# Generar código de Drift
flutter pub run build_runner build --delete-conflicting-outputs

# Generar código en modo watch (desarrollo continuo)
flutter pub run build_runner watch --delete-conflicting-outputs

# Limpiar y regenerar todo
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar app con variables de entorno
flutter run --dart-define-from-file=.env
```

### Build

```bash
# Android APK
flutter build apk --dart-define-from-file=.env

# Android App Bundle
flutter build appbundle --dart-define-from-file=.env

# iOS
flutter build ios --dart-define-from-file=.env
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart
├── core/                          # Núcleo de la aplicación
│   ├── config/                    # Configuraciones
│   │   ├── app_config.dart
│   │   ├── env_config.dart
│   │   └── supabase_config.dart
│   ├── constants/                 # Constantes
│   │   ├── app_constants.dart
│   │   ├── database_constants.dart
│   │   └── sync_constants.dart
│   ├── errors/                    # Manejo de errores
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                   # Red y conectividad
│   │   ├── connectivity_observer.dart
│   │   └── network_info.dart
│   ├── sync/                      # Sistema de sincronización
│   │   ├── conflict_resolver.dart
│   │   ├── sync_manager.dart
│   │   ├── sync_queue.dart
│   │   └── sync_status.dart
│   ├── theme/                     # Temas y estilos
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── utils/                     # Utilidades
│       ├── date_utils.dart
│       ├── logger.dart
│       ├── uuid_generator.dart
│       └── validators.dart
├── data/                          # Capa de datos
│   ├── datasources/
│   │   ├── local/                 # SQLite con Drift
│   │   └── remote/                # Supabase API
│   ├── models/                    # Modelos de datos
│   └── repositories/              # Implementación de repositorios
├── domain/                        # Capa de dominio
│   ├── entities/                  # Entidades de negocio
│   ├── repositories/              # Interfaces de repositorios
│   └── usecases/                  # Casos de uso
└── presentation/                  # Capa de presentación
    ├── bloc/                      # Lógica de estado (BLoC)
    ├── pages/                     # Pantallas
    ├── widgets/                   # Widgets reutilizables
    └── routes/                    # Navegación
```

## 🔄 Configuración de Realtime (Opcional)

Para habilitar actualizaciones en tiempo real:

### 1. Habilitar Replicación en Supabase

1. Ve a **Database > Replication**
2. Habilita replicación para las tablas: `productos`, `inventarios`, `movimientos`

### 2. Implementación en Flutter

```dart
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
```

## 🧪 Testing

### Verificar Base de Datos

```sql
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
```

## 💾 Backup y Restore

### Hacer Backup

1. En Supabase Dashboard: **Database > Backups**
2. O usar `pg_dump` si tienes acceso directo a la base de datos

### Restore

1. Supabase Dashboard: **SQL Editor**
2. Pegar tu backup SQL y ejecutar

## 📊 Monitoring y Logs

Ver logs en tiempo real:

- **Postgres Logs**: Supabase Dashboard > Logs > Postgres Logs
- **API Logs**: Supabase Dashboard > Logs > API Logs

## 🔒 Seguridad

### Checklist

- ✅ RLS habilitado en todas las tablas
- ✅ Políticas RLS configuradas correctamente
- ✅ Variables de entorno no commiteadas (`.env` en `.gitignore`)
- ✅ `ANON_KEY` es pública, `SERVICE_KEY` es privada (no usar en frontend)
- ✅ Auth configurada con PKCE flow
- ✅ Validaciones en el backend (triggers y funciones)
- ✅ Auditoría habilitada en tablas críticas

## 🐛 Troubleshooting

### Error: "relation does not exist"

**Solución**: Verificar que ejecutaste todo el schema SQL en Supabase.

### Error: "permission denied for table"

**Solución**: Revisar políticas RLS, puede que falte una policy.

### Error: "JWT expired"

**Solución**: El token expiró, implementar refresh automático en la app.

### Error: "row level security policy violation"

**Solución**: El usuario no tiene permisos según las políticas RLS definidas.

### No se sincronizan cambios en realtime

**Solución**: Habilitar replicación en Database > Replication para las tablas necesarias.

### Errores de compilación en DAOs

**Solución**: Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs` para regenerar archivos `.g.dart`.

## 📚 Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Drift](https://drift.simonbinder.eu/)
- [Documentación de Supabase](https://supabase.com/docs)
- [Patrón BLoC](https://bloclibrary.dev/)

## 📄 Licencia

Este proyecto es privado y confidencial.

## 👥 Contribución

Para contribuir al proyecto, contactar al equipo de desarrollo.

