# Matriz de Permisos por Rol

## 📋 Descripción

Este documento define los permisos y accesos para cada rol de usuario en el sistema de gestión de inventarios. La matriz de permisos controla qué operaciones puede realizar cada rol en los diferentes módulos del sistema.

## 🔐 Roles del Sistema

| Rol | Descripción | Nivel de Acceso |
|-----|-------------|-----------------|
| **Administrador** | Gestión de usuarios, configuración y auditoría del sistema | ⭐⭐⭐⭐ |
| **Gerente** | Gestión de operaciones, reportes y supervisión | ⭐⭐⭐⭐ |
| **Almacenero** | Control de inventarios, movimientos y almacenes | ⭐⭐⭐ |
| **Vendedor** | Consulta de productos, inventarios y registro de ventas | ⭐⭐ |

## 📊 Matriz de Permisos

### Leyenda
- ✅ = Acceso completo (Crear, Leer, Actualizar, Eliminar)
- 📖 = Solo lectura
- 📝 = Crear y leer
- ✏️ = Crear, leer y actualizar (sin eliminar)
- ❌ = Sin acceso

---

### 1️⃣ Módulo de Autenticación

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Iniciar sesión | ✅ | ✅ | ✅ | ✅ |
| Cerrar sesión | ✅ | ✅ | ✅ | ✅ |
| Cambiar contraseña propia | ✅ | ✅ | ✅ | ✅ |
| Recuperar contraseña | ✅ | ✅ | ✅ | ✅ |
| Ver perfil propio | ✅ | ✅ | ✅ | ✅ |
| Editar perfil propio | ✅ | ✅ | ✅ | ✅ |

---

### 2️⃣ Módulo de Usuarios

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar usuarios | ✅ | 📖 | ❌ | ❌ |
| Ver detalle de usuario | ✅ | 📖 | ❌ | ❌ |
| Crear usuario | ✅ | ❌ | ❌ | ❌ |
| Editar usuario | ✏️ | ❌ | ❌ | ❌ |
| Eliminar usuario | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar usuario | ✅ | ❌ | ❌ | ❌ |
| Asignar rol | ✅ | ❌ | ❌ | ❌ |
| Cambiar tienda de usuario | ✅ | ❌ | ❌ | ❌ |
| Restablecer contraseña | ✅ | ❌ | ❌ | ❌ |

---

### 3️⃣ Módulo de Productos

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar productos | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de producto | ✅ | ✅ | ✅ | 📖 |
| Buscar productos | ✅ | ✅ | ✅ | ✅ |
| Crear producto | ❌ | ✅ | ❌ | ❌ |
| Editar producto | ❌ | ✅ | ❌ | ❌ |
| Eliminar producto | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar producto | 📖 | ✅ | ❌ | ❌ |
| Subir imagen de producto | ❌ | ✅ | ❌ | ❌ |
| Actualizar precios | ❌ | ✅ | ❌ | ❌ |
| Ver historial de cambios | ✅ | ✅ | 📖 | ❌ |

---

### 4️⃣ Módulo de Inventarios

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar inventarios | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de inventario | ✅ | ✅ | ✅ | 📖 |
| Consultar stock disponible | ✅ | ✅ | ✅ | ✅ |
| Ajustar inventario | ❌ | ✅ | ✅ | ❌ |
| Ver alertas de stock mínimo | ✅ | ✅ | ✅ | 📖 |
| Reservar stock | ❌ | ✅ | ✅ | ✏️ |
| Liberar stock reservado | ❌ | ✅ | ✅ | ❌ |
| Ver ubicación física | ✅ | ✅ | ✅ | 📖 |
| Actualizar ubicación | ❌ | ✅ | ✅ | ❌ |
| Ver valorización | 📖 | ✅ | 📖 | ❌ |

---

### 5️⃣ Módulo de Movimientos

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar movimientos | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de movimiento | ✅ | ✅ | ✅ | 📖 |
| Registrar compra | ❌ | ✅ | ✅ | ❌ |
| Registrar venta | ❌ | ✅ | ✅ | ✏️ |
| Registrar transferencia | ❌ | ✅ | ✅ | ❌ |
| Registrar ajuste | ❌ | ✅ | ✅ | ❌ |
| Registrar devolución | ❌ | ✅ | ✅ | ❌ |
| Registrar merma | ❌ | ✅ | ✅ | ❌ |
| Cancelar movimiento | ❌ | ✅ | ✏️ | ❌ |
| Completar movimiento | ❌ | ✅ | ✅ | ❌ |
| Editar movimiento pendiente | ❌ | ✅ | ✏️ | ❌ |
| Ver costos | 📖 | ✅ | 📖 | ❌ |

---

### 6️⃣ Módulo de Tiendas

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar tiendas | ✅ | 📖 | 📖 | 📖 |
| Ver detalle de tienda | ✅ | ✅ | 📖 | 📖 |
| Crear tienda | ✅ | ❌ | ❌ | ❌ |
| Editar tienda | ✏️ | ✏️ | ❌ | ❌ |
| Eliminar tienda | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar tienda | ✅ | ❌ | ❌ | ❌ |
| Ver inventario de tienda | ✅ | ✅ | ✅ | 📖 |
| Ver usuarios de tienda | ✅ | ✅ | ❌ | ❌ |

---

### 7️⃣ Módulo de Almacenes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar almacenes | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de almacén | ✅ | ✅ | ✅ | 📖 |
| Crear almacén | ❌ | ✅ | ❌ | ❌ |
| Editar almacén | ❌ | ✅ | ✏️ | ❌ |
| Eliminar almacén | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar almacén | 📖 | ✅ | ❌ | ❌ |
| Ver capacidad y ocupación | ✅ | ✅ | ✅ | 📖 |
| Gestionar ubicaciones físicas | ❌ | ✅ | ✅ | ❌ |

---

### 8️⃣ Módulo de Proveedores

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar proveedores | 📖 | ✅ | 📖 | ❌ |
| Ver detalle de proveedor | 📖 | ✅ | 📖 | ❌ |
| Crear proveedor | ❌ | ✅ | ❌ | ❌ |
| Editar proveedor | ❌ | ✅ | ❌ | ❌ |
| Eliminar proveedor | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar proveedor | ❌ | ✅ | ❌ | ❌ |
| Ver productos de proveedor | 📖 | ✅ | 📖 | ❌ |
| Ver historial de compras | 📖 | ✅ | 📖 | ❌ |

---

### 9️⃣ Módulo de Lotes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar lotes | 📖 | ✅ | ✅ | 📖 |
| Ver detalle de lote | 📖 | ✅ | ✅ | 📖 |
| Crear lote | ❌ | ✅ | ✅ | ❌ |
| Editar lote | ❌ | ✅ | ✏️ | ❌ |
| Ver fecha de vencimiento | ✅ | ✅ | ✅ | 📖 |
| Subir certificado de calidad | ❌ | ✅ | ✅ | ❌ |
| Ver alertas de vencimiento | ✅ | ✅ | ✅ | 📖 |
| Trazabilidad del lote | 📖 | ✅ | ✅ | ❌ |

---

### 🔟 Módulo de Categorías

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar categorías | ✅ | ✅ | 📖 | 📖 |
| Ver detalle de categoría | ✅ | ✅ | 📖 | 📖 |
| Crear categoría | ❌ | ✅ | ❌ | ❌ |
| Editar categoría | ❌ | ✅ | ❌ | ❌ |
| Eliminar categoría | ❌ | ❌ | ❌ | ❌ |
| Activar/Desactivar categoría | 📖 | ✅ | ❌ | ❌ |
| Crear subcategorías | ❌ | ✅ | ❌ | ❌ |
| Ver productos de categoría | ✅ | ✅ | ✅ | 📖 |

---

### 1️⃣1️⃣ Módulo de Reportes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Dashboard general | 📖 | ✅ | 📖 | 📖 |
| Reporte de inventario | 📖 | ✅ | ✅ | 📖 |
| Reporte de movimientos | 📖 | ✅ | ✅ | 📖 |
| Reporte de ventas | 📖 | ✅ | ❌ | 📖 |
| Reporte de compras | 📖 | ✅ | 📖 | ❌ |
| Reporte de valorización | 📖 | ✅ | ❌ | ❌ |
| Reporte de stock mínimo | 📖 | ✅ | ✅ | 📖 |
| Reporte de vencimientos | 📖 | ✅ | ✅ | ❌ |
| Reporte de auditoría | ✅ | 📖 | ❌ | ❌ |
| Exportar reportes (PDF/Excel) | 📖 | ✅ | 📖 | ❌ |

---

### 1️⃣2️⃣ Módulo de Sincronización

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Ver estado de sincronización | ✅ | ✅ | ✅ | ✅ |
| Forzar sincronización manual | ✅ | ✅ | ✅ | ✅ |
| Resolver conflictos | ✅ | ✏️ | ❌ | ❌ |
| Ver cola de sincronización | ✅ | ✅ | 📖 | ❌ |
| Configurar intervalo de sync | ✅ | ❌ | ❌ | ❌ |
| Ver logs de sincronización | ✅ | 📖 | ❌ | ❌ |

---

### 1️⃣3️⃣ Módulo de Configuración

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Ver configuración general | ✅ | 📖 | ❌ | ❌ |
| Editar configuración general | ✏️ | ❌ | ❌ | ❌ |
| Gestionar roles y permisos | ✅ | ❌ | ❌ | ❌ |
| Configurar unidades de medida | ❌ | ✅ | ❌ | ❌ |
| Ver auditoría del sistema | ✅ | 📖 | ❌ | ❌ |
| Gestionar backup/restore | ✅ | ❌ | ❌ | ❌ |
| Configurar notificaciones | ✏️ | ✏️ | ✏️ | ✏️ |

---

## 📋 Resumen de Permisos por Rol

### 👑 Administrador
- **Enfoque**: Gestión de usuarios, configuración del sistema y auditoría
- Gestión completa de usuarios y roles
- Configuración del sistema y backup
- Acceso a auditorías y logs del sistema
- **Lectura** en operaciones (productos, inventarios, reportes)
- **Sin permisos** de eliminación masiva ni de operaciones críticas
- Depende del Gerente para operaciones del negocio

### 👨‍💼 Gerente
- **Enfoque**: Gestión operativa y estratégica del negocio
- Control total de productos, proveedores y precios
- Gestión completa de inventarios y movimientos
- Creación y gestión de almacenes y lotes
- Reportes y análisis completos
- Solo lectura en usuarios
- **Sin capacidad de eliminar** productos, proveedores o almacenes

### 📦 Almacenero
- **Enfoque**: Control operativo de inventarios
- Gestión de stock y ubicaciones físicas
- Registro de movimientos operativos
- Gestión de lotes y trazabilidad
- Reportes de inventario
- Solo lectura en productos, proveedores y reportes financieros
- Sin acceso a usuarios ni configuración

### 🛒 Vendedor
- **Enfoque**: Ventas y consultas
- Consulta de productos e inventarios
- Registro de ventas
- Consulta de disponibilidad de stock
- Reportes básicos de ventas
- Sin acceso a costos, valorización ni gestión administrativa

---

## 🔒 Principios de Seguridad

### Separación de Responsabilidades
Ningún rol tiene control total sobre el sistema. Los permisos están distribuidos para garantizar:

1. **Administrador**: Controla usuarios y sistema, pero depende del Gerente para operaciones
2. **Gerente**: Gestiona el negocio, pero no puede crear usuarios ni cambiar configuración del sistema
3. **Almacenero**: Opera inventarios, pero no define productos ni precios
4. **Vendedor**: Ejecuta ventas, pero no modifica inventarios ni productos

### Restricciones Críticas
- **Eliminación prohibida**: Ningún rol puede eliminar usuarios, productos, proveedores o almacenes
- **Cambios auditados**: Todas las modificaciones quedan registradas
- **Permisos granulares**: Cada función requiere permiso específico
- **Validación dual**: Frontend y RLS validan los permisos

---

## 🔄 Implementación Técnica

### Row Level Security (RLS) en Supabase

Las políticas RLS validan permisos según el rol y la funcionalidad específica:

```sql
-- Ejemplo: Solo Gerentes pueden crear productos
CREATE POLICY "Gerentes pueden crear productos"
    ON public.productos FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.usuarios u
            JOIN public.roles r ON u.rol_id = r.id
            WHERE u.auth_user_id = auth.uid()
            AND r.nombre = 'Gerente'
            AND u.activo = true
        )
    );

-- Administradores solo pueden leer productos
CREATE POLICY "Administradores pueden leer productos"
    ON public.productos FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.usuarios u
            JOIN public.roles r ON u.rol_id = r.id
            WHERE u.auth_user_id = auth.uid()
            AND r.nombre = 'Administrador'
            AND u.activo = true
        )
    );
```

### Validación en Frontend (BLoC)

```dart
// Matriz de permisos específicos por rol
final Map<String, Set<String>> rolePermissions = {
  'Administrador': {
    'users.create', 'users.edit', 'users.activate',
    'config.edit', 'audit.view', 'backup.manage',
    'products.read', 'inventory.read', 'reports.read'
  },
  'Gerente': {
    'products.create', 'products.edit', 'products.activate',
    'inventory.adjust', 'movements.all', 'reports.all',
    'suppliers.manage', 'warehouses.create'
  },
  'Almacenero': {
    'inventory.adjust', 'movements.register', 
    'batches.manage', 'locations.update'
  },
  'Vendedor': {
    'products.read', 'inventory.read', 'sales.register'
  },
};

bool hasPermission(String permission) {
  final userRole = currentUser?.rol?.nombre;
  return rolePermissions[userRole]?.contains(permission) ?? false;
}
```

---

## ⚠️ Notas Importantes

1. **Sin acceso total**: Ningún rol tiene permisos completos sobre todo el sistema
2. **Eliminación restringida**: Las eliminaciones están prohibidas para preservar integridad de datos
3. **Separación de roles**: Administrador gestiona sistema, Gerente gestiona negocio
4. **RLS obligatorio**: El backend (Supabase) garantiza la seguridad real
5. **Auditoría completa**: Todas las acciones quedan registradas
6. **Revisión periódica**: Matriz debe revisarse cada 6 meses

---

## 🔄 Actualizaciones

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 2.0.0 | 2025-12-20 | Eliminación de permisos totales, distribución granular |
| 1.0.0 | 2025-12-01 | Versión inicial de la matriz de permisos |

---

## 📞 Contacto

Para solicitudes de cambios en permisos o nuevos roles, contactar al administrador del sistema.
