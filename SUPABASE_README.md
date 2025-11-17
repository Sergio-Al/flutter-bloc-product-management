# 📚 Documentación de Supabase SQL

Este directorio contiene todos los scripts SQL necesarios para configurar Supabase desde cero.

## 🎯 Inicio Rápido

**¿Primera vez configurando Supabase?** → Lee **[SUPABASE_SETUP_GUIDE.md](./SUPABASE_SETUP_GUIDE.md)**

## 📁 Archivos Disponibles

| Archivo | Descripción | Orden | Obligatorio |
|---------|-------------|-------|-------------|
| [supabase_schema_complete.sql](./supabase_schema_complete.sql) | **Schema completo:** Tablas, índices, triggers básicos, datos seed | 1️⃣ | ✅ SÍ |
| [supabase_rls_policies.sql](./supabase_rls_policies.sql) | **Políticas RLS:** Control de acceso por roles y tiendas | 2️⃣ | ✅ SÍ |
| [supabase_trigger_complete.sql](./supabase_trigger_complete.sql) | **Auth Trigger:** Creación automática de perfiles al registrarse | 3️⃣ | ✅ SÍ |
| [supabase_audit_triggers.sql](./supabase_audit_triggers.sql) | **Auditoría:** Sistema de logging de cambios | 4️⃣ | ⚠️ OPCIONAL |
| [SUPABASE_SETUP_GUIDE.md](./SUPABASE_SETUP_GUIDE.md) | **Guía completa:** Paso a paso con verificaciones | - | 📖 LEER PRIMERO |
| [CHANGELOG_SUPABASE.md](./CHANGELOG_SUPABASE.md) | **Historial:** Problemas encontrados y soluciones | - | 📝 Referencia |

## ⚡ Ejecución Rápida

Si ya sabes lo que estás haciendo:

```bash
# 1. Abrir Supabase Dashboard → SQL Editor

# 2. Ejecutar en orden (copiar y pegar cada archivo):
#    → supabase_schema_complete.sql
#    → supabase_rls_policies.sql  
#    → supabase_trigger_complete.sql
#    → supabase_audit_triggers.sql (opcional)

# 3. Crear usuario de prueba en Authentication → Users

# 4. Listo! 🚀
```

## 🔍 ¿Qué Hace Cada Archivo?

### 1️⃣ supabase_schema_complete.sql
Crea la estructura completa de la base de datos:
- 12 tablas (roles, usuarios, tiendas, productos, inventarios, etc.)
- Campos de sincronización offline-first (sync_id, last_sync)
- Índices para optimizar queries
- Triggers automáticos (updated_at, números de movimiento)
- Datos iniciales (roles, categorías, unidades de medida)
- Vistas útiles (inventario completo, stock bajo)

**Nota:** Los triggers de auditoría están comentados, usar archivo separado (paso 4).

### 2️⃣ supabase_rls_policies.sql
Configura la seguridad Row Level Security:
- Habilita RLS en todas las tablas
- Políticas basadas en roles (Administrador, Gerente, Almacenero, Vendedor)
- Control de acceso por tienda
- Usa EXISTS() inline en lugar de funciones (más eficiente)

**Roles y permisos:**
- **Administrador:** Full access
- **Gerente:** Crear/actualizar productos, gestionar su tienda
- **Almacenero:** Gestión de inventarios y movimientos
- **Vendedor:** Solo lectura

### 3️⃣ supabase_trigger_complete.sql
Automatiza la creación de perfiles:
- Trigger `on_auth_user_created` en auth.users
- Cuando un usuario se registra → se crea automáticamente en `usuarios`
- Asigna rol "Vendedor" por defecto
- Asigna primera tienda activa
- Políticas RLS para que el trigger funcione

### 4️⃣ supabase_audit_triggers.sql (OPCIONAL)
Sistema de auditoría profesional:
- Registra todos los cambios en tablas críticas
- Usa auth.uid() correctamente (sin errores FK)
- Mapea auth.uid() → usuarios.id automáticamente
- Manejo de errores sin bloquear operaciones
- Logs detallados para debugging

**Tablas auditadas:** productos, inventarios, movimientos, usuarios, proveedores, almacenes, tiendas, lotes

## 📖 Guías de Referencia

### Para principiantes:
👉 **[SUPABASE_SETUP_GUIDE.md](./SUPABASE_SETUP_GUIDE.md)** - Guía paso a paso completa con:
- Orden de ejecución detallado
- Verificaciones después de cada paso
- Troubleshooting de errores comunes
- Checklist final

### Para desarrolladores:
👉 **[CHANGELOG_SUPABASE.md](./CHANGELOG_SUPABASE.md)** - Historial técnico con:
- Problemas encontrados y causas raíz
- Soluciones implementadas
- Comparación antes vs después
- Referencias técnicas

## 🛠️ Troubleshooting Rápido

### Error: "violates row-level security policy"
→ Usuario no tiene permisos. Verificar rol asignado (debe ser Gerente o Admin para crear productos)

### Error: "Usuario autenticado no encontrado en tabla usuarios"
→ Falta el perfil. Ejecutar `supabase_trigger_complete.sql` o crear perfil manualmente

### Error: Foreign key constraint (categoria_id o unidad_medida_id)
→ Faltan datos seed. Re-ejecutar la sección SEED DATA de `supabase_schema_complete.sql`

### Error: "function user_has_role(unknown) does not exist"
→ Estás usando la versión vieja de RLS. Ejecutar `supabase_rls_policies.sql` actualizado

### Auditoría no registra cambios
→ No ejecutaste `supabase_audit_triggers.sql` o el usuario no está autenticado

## ✅ Checklist de Configuración

- [ ] Ejecuté `supabase_schema_complete.sql` ✅
- [ ] Ejecuté `supabase_rls_policies.sql` ✅
- [ ] Ejecuté `supabase_trigger_complete.sql` ✅
- [ ] (Opcional) Ejecuté `supabase_audit_triggers.sql` ⚠️
- [ ] Creé usuario de prueba en Authentication
- [ ] Creé al menos una tienda
- [ ] Creé al menos un almacén
- [ ] Asigné rol Gerente al usuario de prueba
- [ ] Verifiqué que RLS funciona
- [ ] La app Flutter se conecta correctamente

## 🚀 Próximos Pasos

Después de configurar Supabase:

1. Configurar `.env` en Flutter con las credenciales
2. Ejecutar `flutter pub get`
3. Ejecutar `flutter run`
4. Probar CRUD de productos
5. Verificar sincronización offline-first

## 📞 Ayuda

Si tienes problemas:
1. Leer **SUPABASE_SETUP_GUIDE.md** sección Troubleshooting
2. Verificar logs en Supabase Dashboard → Logs
3. Revisar **CHANGELOG_SUPABASE.md** para casos similares

---

**Última actualización:** 2025-11-16  
**Versión:** 2.0 (RLS inline + Auditoría separada)  
**Estado:** ✅ Producción Ready
