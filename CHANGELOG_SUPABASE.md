# 📝 Historial de Cambios - Sistema de Auditoría y RLS

## 🔴 Problemas Encontrados y Soluciones

### 1. **Problema: Triggers de Auditoría con FK Constraints**

#### ❌ **Error Original:**
```
ERROR: insert or update on table "auditorias" violates foreign key constraint
Key (usuario_id)=(b3c52203-3ce5-4cb6-abef-f9d1a01420c5) is not present in table "usuarios"
```

#### 🔍 **Causa Raíz:**
El trigger `registrar_auditoria()` usaba:
```sql
COALESCE(NEW.id, OLD.id) -- ❌ INCORRECTO
```

Esto tomaba el **ID del registro modificado** (ej: producto.id) en lugar del **ID del usuario** que hizo el cambio.

#### ✅ **Solución Implementada:**
Cambiar a usar `auth.uid()` y mapear al usuario real:
```sql
-- Obtener auth.uid() del usuario autenticado
v_auth_uid := auth.uid();

-- Buscar usuarios.id correspondiente usando auth_user_id
SELECT id INTO v_usuario_id
FROM public.usuarios
WHERE auth_user_id = v_auth_uid
AND activo = true;
```

#### 📁 **Archivo:** `supabase_audit_triggers.sql`

---

### 2. **Problema: RLS Policies con user_has_role(unknown)**

#### ❌ **Error Original:**
```
ERROR: function user_has_role(unknown) does not exist
HINT: No function matches the given name and argument types. You might need to add explicit type casts.
```

#### 🔍 **Causa Raíz:**
PostgreSQL no podía inferir el tipo de dato del parámetro `role_name` en la función:
```sql
CREATE FUNCTION user_has_role(role_name TEXT) -- Causaba problemas
```

Cuando se llamaba desde RLS:
```sql
USING (user_has_role('Gerente')) -- ❌ Type casting issues
```

#### ✅ **Solución Implementada:**
Reemplazar funciones con **EXISTS() inline**:
```sql
-- Antes (con función)
USING (user_has_role('Gerente'))

-- Después (inline)
USING (
    EXISTS (
        SELECT 1 FROM public.usuarios u
        JOIN public.roles r ON u.rol_id = r.id
        WHERE u.auth_user_id = auth.uid()
        AND r.nombre = 'Gerente'  -- ✅ Tipo explícito
        AND u.activo = true
    )
)
```

#### 📁 **Archivo:** `supabase_rls_policies.sql`

---

## 📋 Estado Actual de los Archivos

### ✅ `supabase_schema_complete.sql`
**Qué contiene:**
- ✅ 12 tablas con campos de sincronización
- ✅ Índices para performance
- ✅ Triggers de updated_at y last_sync
- ✅ Datos seed (roles, categorías, unidades)
- ⚠️ **NO incluye** triggers de auditoría (comentados)

**Cambios realizados:**
- Comenté la función `registrar_auditoria()` problemática
- Agregué documentación sobre cómo habilitar auditoría correctamente
- Agregué referencia al archivo separado `supabase_audit_triggers.sql`

---

### ✅ `supabase_rls_policies.sql`
**Qué contiene:**
- ✅ Políticas RLS para todas las tablas
- ✅ Control de acceso por roles (inline con EXISTS)
- ✅ Control de acceso por tienda
- ⚠️ **NO usa** funciones helper (comentadas)

**Cambios realizados:**
- Comenté las funciones helper (`user_has_role`, `is_admin`, `is_manager`)
- Reescribí las políticas con `EXISTS()` inline
- Agregué DROP POLICY antes de cada CREATE para evitar conflictos
- Documenté por qué se usan políticas inline

**Ejemplo de política corregida:**
```sql
-- ❌ ANTES (con función)
CREATE POLICY "Gerentes pueden crear productos"
    ON public.productos FOR INSERT
    TO authenticated
    WITH CHECK (is_manager());

-- ✅ DESPUÉS (inline)
CREATE POLICY "Gerentes pueden crear productos"
    ON public.productos FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.usuarios u
            JOIN public.roles r ON u.rol_id = r.id
            WHERE u.auth_user_id = auth.uid()
            AND r.nombre IN ('Gerente', 'Administrador')
            AND u.activo = true
        )
    );
```

---

### ✅ `supabase_trigger_complete.sql`
**Qué contiene:**
- ✅ Trigger `on_auth_user_created`
- ✅ Función `handle_new_user()`
- ✅ Políticas RLS para service_role
- ✅ Creación automática de perfil al registrarse

**Cambios realizados:**
- Actualicé la función `registrar_auditoria()` en este archivo también
- Corregí para usar `NEW.id` correctamente (este archivo sí necesita usar NEW.id porque es para usuarios)

---

### 🆕 `supabase_audit_triggers.sql` (NUEVO)
**Qué contiene:**
- ✅ Función `registrar_auditoria()` corregida
- ✅ Triggers en 8 tablas críticas
- ✅ Usa auth.uid() → usuarios.auth_user_id → usuarios.id
- ✅ Manejo de errores sin bloquear operaciones
- ✅ Logs detallados para debugging

**Características:**
```sql
-- 1. Obtiene el usuario autenticado
v_auth_uid := auth.uid();

-- 2. Busca el usuarios.id correspondiente
SELECT id INTO v_usuario_id
FROM public.usuarios
WHERE auth_user_id = v_auth_uid
AND activo = true;

-- 3. Inserta el registro de auditoría
INSERT INTO public.auditorias (usuario_id, ...)
VALUES (v_usuario_id, ...);  -- ✅ Usuario correcto
```

**Tablas auditadas:**
- productos
- inventarios
- movimientos
- usuarios
- proveedores
- almacenes
- tiendas
- lotes

---

### 🆕 `SUPABASE_SETUP_GUIDE.md` (NUEVO)
**Qué contiene:**
- ✅ Orden correcto de ejecución (1, 2, 3, 4)
- ✅ Qué hace cada script
- ✅ Verificaciones para cada paso
- ✅ Troubleshooting de errores comunes
- ✅ Checklist final

---

## 🔄 Migración: Cómo Aplicar los Cambios

### Si ya tienes Supabase configurado:

#### Opción 1: Empezar desde cero (RECOMENDADO para desarrollo)
```sql
-- 1. Hacer backup (IMPORTANTE)
pg_dump -h db.xxx.supabase.co -U postgres > backup_antes_de_cambios.sql

-- 2. Eliminar todo
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- 3. Re-ejecutar en orden:
-- - supabase_schema_complete.sql
-- - supabase_rls_policies.sql
-- - supabase_trigger_complete.sql
-- - supabase_audit_triggers.sql (opcional)
```

#### Opción 2: Actualizar selectivamente (producción con datos)
```sql
-- 1. Eliminar triggers de auditoría viejos
DROP TRIGGER IF EXISTS audit_productos ON public.productos;
DROP TRIGGER IF EXISTS audit_inventarios ON public.inventarios;
DROP TRIGGER IF EXISTS audit_movimientos ON public.movimientos;
DROP FUNCTION IF EXISTS public.registrar_auditoria();

-- 2. Eliminar funciones RLS problemáticas
DROP FUNCTION IF EXISTS user_has_role(TEXT);
DROP FUNCTION IF EXISTS is_admin();
DROP FUNCTION IF EXISTS is_manager();

-- 3. Recrear políticas RLS
-- Ejecutar las secciones de DROP POLICY y CREATE POLICY
-- desde supabase_rls_policies.sql

-- 4. (Opcional) Habilitar auditoría
-- Ejecutar supabase_audit_triggers.sql
```

---

## 🎯 Resumen de Cambios

### Antes vs Después

| Aspecto | ❌ Antes | ✅ Después |
|---------|---------|-----------|
| **Auditoría** | Usaba `COALESCE(NEW.id, OLD.id)` | Usa `auth.uid() → usuarios.id` |
| **RLS Policies** | Funciones `user_has_role()` | EXISTS() inline |
| **Type Casting** | Errores con `unknown` | Tipos explícitos |
| **Documentación** | Código en un solo archivo | Archivos separados + guía |
| **Mantenibilidad** | Difícil de debuggear | Código claro y documentado |

---

## ✅ Estado Final

### ¿Qué funciona ahora?
- ✅ **Productos CRUD:** Crear, actualizar, eliminar productos
- ✅ **RLS:** Usuarios solo ven/modifican según su rol
- ✅ **Sincronización:** Offline-first con sync_id y last_sync
- ✅ **Naming conversion:** camelCase ↔ snake_case
- ✅ **Remote-first init:** Carga categorías/unidades desde Supabase
- ✅ **List refresh:** Auto-refresh después de operaciones
- ✅ **Sin auditoría:** Sistema funciona sin triggers de auditoría

### ¿Qué es opcional?
- ⚠️ **Auditoría:** Se puede habilitar ejecutando `supabase_audit_triggers.sql`

---

## 📚 Referencias

- **Main Guide:** `SUPABASE_SETUP_GUIDE.md` - Guía completa paso a paso
- **Schema:** `supabase_schema_complete.sql` - Tablas e índices
- **RLS:** `supabase_rls_policies.sql` - Políticas de seguridad
- **Auth Trigger:** `supabase_trigger_complete.sql` - Creación automática de perfiles
- **Audit (opcional):** `supabase_audit_triggers.sql` - Sistema de auditoría

---

## 🚀 Próximos Pasos

Si quieres habilitar la auditoría:

1. Ejecutar `supabase_audit_triggers.sql` en Supabase SQL Editor
2. Verificar que funciona:
   ```sql
   SELECT * FROM auditorias ORDER BY created_at DESC LIMIT 10;
   ```
3. Ver registros con usuario:
   ```sql
   SELECT 
       a.tabla_afectada,
       a.accion,
       u.email,
       a.created_at
   FROM auditorias a
   JOIN usuarios u ON a.usuario_id = u.id
   ORDER BY a.created_at DESC;
   ```

---

**Última actualización:** 2024-11-16  
**Autor:** GitHub Copilot  
**Estado:** ✅ Sistema funcionando correctamente sin auditoría, listo para habilitar auditoría cuando se desee
