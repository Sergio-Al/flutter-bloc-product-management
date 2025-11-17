# 🚀 Guía de Configuración de Supabase

Esta guía explica cómo configurar tu base de datos Supabase desde cero, en el orden correcto, para tener el sistema funcionando completamente.

## 📋 Orden de Ejecución (IMPORTANTE)

Ejecuta los scripts SQL en este orden exacto:

### 1️⃣ **supabase_schema_complete.sql** (PRIMERO)
Crea todas las tablas, índices, triggers básicos y datos iniciales.

**Qué incluye:**
- ✅ 12 tablas principales (roles, usuarios, tiendas, productos, inventarios, etc.)
- ✅ Campos de sincronización (sync_id, last_sync)
- ✅ Índices para mejorar performance
- ✅ Triggers de updated_at, last_sync, números automáticos
- ✅ Datos seed (roles, categorías, unidades de medida)
- ✅ Vistas útiles (vw_inventario_completo, vw_movimientos_completos)
- ✅ Función RPC get_dashboard_stats()
- ⚠️ **NO incluye**: Triggers de auditoría (ver paso 3)

**Ejecutar en:** Supabase Dashboard → SQL Editor → New Query

```sql
-- Copia y pega el contenido completo de supabase_schema_complete.sql
```

**Resultado esperado:**
```
✅ Schema de Supabase creado exitosamente
📊 Tablas creadas: 12
🔐 Siguiente paso: Ejecutar supabase_rls_policies.sql
👤 Recuerda crear un usuario admin en Authentication > Users
```

---

### 2️⃣ **supabase_rls_policies.sql** (SEGUNDO)
Configura las políticas de seguridad Row Level Security (RLS).

**Qué incluye:**
- ✅ Habilita RLS en todas las tablas
- ✅ Políticas basadas en roles (Administrador, Gerente, Almacenero, Vendedor)
- ✅ Políticas inline con EXISTS() (sin funciones problemáticas)
- ✅ Control de acceso por tienda
- ✅ Permisos de lectura/escritura según rol

**Características principales:**
- **Administrador**: Acceso completo a todo
- **Gerente**: Crear/actualizar productos, ver su tienda
- **Almacenero**: Gestión de inventarios y movimientos
- **Vendedor**: Solo lectura de productos e inventarios

**Ejecutar en:** Supabase Dashboard → SQL Editor → New Query

```sql
-- Copia y pega el contenido completo de supabase_rls_policies.sql
```

**Resultado esperado:**
- Políticas RLS habilitadas en todas las tablas
- Usuarios pueden acceder solo a datos de su tienda
- Roles con permisos correctamente configurados

---

### 3️⃣ **supabase_trigger_complete.sql** (TERCERO)
Configura el trigger para crear automáticamente perfiles de usuario.

**Qué incluye:**
- ✅ Función handle_new_user()
- ✅ Trigger on_auth_user_created
- ✅ Políticas RLS para acceso del trigger
- ✅ Asignación automática de rol "Vendedor"
- ✅ Asignación automática de primera tienda activa

**Ejecutar en:** Supabase Dashboard → SQL Editor → New Query

```sql
-- Copia y pega el contenido completo de supabase_trigger_complete.sql
```

**Resultado esperado:**
- Cuando un usuario se registra en Auth, se crea automáticamente en `usuarios`
- Se le asigna el rol "Vendedor" por defecto
- Se le asigna la primera tienda activa

---

### 4️⃣ **supabase_audit_triggers.sql** (CUARTO - OPCIONAL)
Habilita el sistema de auditoría para registrar todos los cambios.

**⚠️ IMPORTANTE:**
Este archivo es **OPCIONAL** pero **RECOMENDADO** para producción.

**Qué incluye:**
- ✅ Función registrar_auditoria() corregida
- ✅ Triggers en 8 tablas críticas (productos, inventarios, movimientos, usuarios, etc.)
- ✅ Usa auth.uid() correctamente para obtener el usuario
- ✅ Mapeo correcto auth_user_id → usuarios.id
- ✅ Manejo de errores sin bloquear operaciones

**Por qué es opcional:**
- El sistema funciona perfectamente sin auditoría
- Puedes habilitarla más tarde sin problemas
- Útil para debugging y seguimiento de cambios

**Ejecutar en:** Supabase Dashboard → SQL Editor → New Query

```sql
-- Copia y pega el contenido completo de supabase_audit_triggers.sql
```

**Resultado esperado:**
```
✅ Sistema de auditoría creado correctamente
📊 Tablas auditadas: productos, inventarios, movimientos, usuarios, proveedores, almacenes, tiendas, lotes
🔍 Para ver registros: SELECT * FROM auditorias ORDER BY created_at DESC;
```

**Verificar que funciona:**
```sql
-- 1. Crear/actualizar un producto desde Flutter
-- 2. Verificar que se registró en auditorias:

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
```

---

## 👤 Crear Usuario de Prueba

Después de ejecutar los scripts, crea un usuario de prueba:

### Opción 1: Dashboard de Supabase
1. Ir a **Authentication** → **Users** → **Add user**
2. Email: `testfinal@gmail.com`
3. Password: `Test123456!`
4. ✅ Auto Confirm User: ON

### Opción 2: SQL (Crear con rol específico)
```sql
-- Crear usuario en auth.users
INSERT INTO auth.users (
    id, 
    email, 
    encrypted_password, 
    email_confirmed_at,
    created_at,
    updated_at
) VALUES (
    '63dab3de-c3d7-4ce8-9c3d-236d71fa11a9',
    'testfinal@gmail.com',
    crypt('Test123456!', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW()
);

-- El trigger creará automáticamente el perfil en usuarios
-- con rol "Vendedor"

-- Si quieres cambiarlo a "Gerente":
UPDATE public.usuarios
SET rol_id = (SELECT id FROM public.roles WHERE nombre = 'Gerente')
WHERE email = 'testfinal@gmail.com';
```

---

## 🧪 Verificar Configuración

### 1. Verificar tablas creadas
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

**Resultado esperado:** 12 tablas

### 2. Verificar roles
```sql
SELECT nombre, descripcion FROM public.roles;
```

**Resultado esperado:** 4 roles (Administrador, Gerente, Almacenero, Vendedor)

### 3. Verificar categorías
```sql
SELECT nombre, codigo FROM public.categorias WHERE activo = true;
```

**Resultado esperado:** 11 categorías

### 4. Verificar unidades de medida
```sql
SELECT nombre, abreviatura, tipo FROM public.unidades_medida;
```

**Resultado esperado:** 11 unidades

### 5. Verificar RLS habilitado
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

**Resultado esperado:** rowsecurity = true en todas las tablas

### 6. Verificar políticas RLS
```sql
SELECT tablename, policyname 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename;
```

**Resultado esperado:** Múltiples políticas por tabla

### 7. Verificar triggers de auditoría (si habilitaste paso 4)
```sql
SELECT 
    schemaname,
    tablename,
    tgname as trigger_name
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'public'
  AND tgname LIKE 'audit_%'
  AND NOT tgisinternal
ORDER BY tablename;
```

**Resultado esperado:** 8 triggers (uno por tabla auditada)

---

## 🔧 Datos Iniciales Requeridos

Antes de usar la app, asegúrate de tener:

### ✅ Crear al menos una tienda
```sql
INSERT INTO public.tiendas (nombre, codigo, direccion, ciudad, departamento, activo)
VALUES ('Tienda Principal', 'TP001', 'Av. Principal 123', 'La Paz', 'La Paz', true);
```

### ✅ Crear al menos un almacén
```sql
INSERT INTO public.almacenes (nombre, codigo, tienda_id, tipo, activo)
VALUES (
    'Almacén Central',
    'AC001',
    (SELECT id FROM public.tiendas LIMIT 1),
    'Principal',
    true
);
```

### ✅ Verificar que el usuario tiene tienda asignada
```sql
-- Ver usuarios sin tienda
SELECT email, nombre_completo 
FROM public.usuarios 
WHERE tienda_id IS NULL;

-- Asignar tienda si es necesario
UPDATE public.usuarios
SET tienda_id = (SELECT id FROM public.tiendas LIMIT 1)
WHERE tienda_id IS NULL;
```

---

## 🐛 Troubleshooting

### Error: "new row violates row-level security policy"
**Causa:** Usuario no tiene permisos según RLS
**Solución:** 
1. Verificar que el usuario tiene rol asignado
2. Verificar que el rol permite la operación (Gerente puede crear productos)
3. Verificar que auth_user_id está correctamente vinculado

```sql
-- Verificar rol del usuario
SELECT u.email, r.nombre as rol
FROM public.usuarios u
JOIN public.roles r ON u.rol_id = r.id
WHERE u.email = 'testfinal@gmail.com';
```

### Error: "Usuario autenticado no encontrado en tabla usuarios"
**Causa:** El trigger no creó el perfil o auth_user_id no coincide
**Solución:**
```sql
-- Verificar que existe el perfil
SELECT * FROM public.usuarios WHERE email = 'testfinal@gmail.com';

-- Si no existe, crearlo manualmente
INSERT INTO public.usuarios (email, nombre_completo, rol_id, tienda_id, auth_user_id, activo)
VALUES (
    'testfinal@gmail.com',
    'Usuario Test',
    (SELECT id FROM public.roles WHERE nombre = 'Gerente'),
    (SELECT id FROM public.tiendas LIMIT 1),
    (SELECT id FROM auth.users WHERE email = 'testfinal@gmail.com'),
    true
);
```

### Error: Foreign key constraint (categoria_id o unidad_medida_id)
**Causa:** No existen los datos seed
**Solución:**
```sql
-- Verificar que existen categorías
SELECT COUNT(*) FROM public.categorias;

-- Si no existen, re-ejecutar la sección de SEED DATA del schema
```

### Auditoría no registra cambios
**Causa:** No está habilitada o usuario no autenticado
**Solución:**
1. Verificar que ejecutaste `supabase_audit_triggers.sql`
2. Verificar que hay un usuario autenticado (auth.uid() no es NULL)
3. Verificar que el usuario existe en la tabla usuarios

```sql
-- Ver triggers de auditoría
SELECT * FROM pg_trigger WHERE tgname LIKE 'audit_%';

-- Si no existen, ejecutar supabase_audit_triggers.sql
```

---

## 📝 Resumen de Archivos

| Archivo | Propósito | Obligatorio | Orden |
|---------|-----------|-------------|-------|
| `supabase_schema_complete.sql` | Crea tablas, índices, triggers básicos, datos seed | ✅ SÍ | 1 |
| `supabase_rls_policies.sql` | Configura políticas de seguridad RLS | ✅ SÍ | 2 |
| `supabase_trigger_complete.sql` | Crea perfiles automáticamente al registrarse | ✅ SÍ | 3 |
| `supabase_audit_triggers.sql` | Habilita sistema de auditoría | ⚠️ OPCIONAL | 4 |

---

## 🎯 Siguiente Paso

Después de ejecutar todos los scripts:

1. ✅ Crear usuario de prueba en Authentication
2. ✅ Crear al menos una tienda
3. ✅ Crear al menos un almacén
4. ✅ Asignar rol "Gerente" al usuario de prueba
5. ✅ Configurar `.env` en Flutter con las credenciales de Supabase
6. 🚀 Ejecutar `flutter run` y probar la app

---

## 💡 Consejos

- **Desarrollo:** Puedes deshabilitar RLS temporalmente para testing:
  ```sql
  ALTER TABLE public.productos DISABLE ROW LEVEL SECURITY;
  ```
  
- **Producción:** SIEMPRE mantén RLS habilitado:
  ```sql
  ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
  ```

- **Logs:** Habilita logs en Supabase Dashboard → Settings → Logs para debuggear RLS

- **Backups:** Exporta tu schema después de configurarlo:
  ```sql
  pg_dump -h db.xxx.supabase.co -U postgres -d postgres --schema-only > backup_schema.sql
  ```

---

## ✅ Checklist Final

- [ ] Ejecuté supabase_schema_complete.sql
- [ ] Ejecuté supabase_rls_policies.sql
- [ ] Ejecuté supabase_trigger_complete.sql
- [ ] (Opcional) Ejecuté supabase_audit_triggers.sql
- [ ] Creé usuario de prueba en Authentication
- [ ] Creé al menos una tienda
- [ ] Creé al menos un almacén
- [ ] Asigné rol Gerente al usuario de prueba
- [ ] Verificué que RLS está habilitado
- [ ] Verificué que las políticas funcionan
- [ ] Configuré .env en Flutter
- [ ] La app funciona correctamente

---

**¿Tienes problemas?** Revisa la sección de Troubleshooting o verifica los logs en Supabase Dashboard.
