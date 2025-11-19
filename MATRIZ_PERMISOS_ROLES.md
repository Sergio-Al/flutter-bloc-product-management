# Matriz de Permisos por Rol

## 📋 Descripción

Este documento define los permisos y accesos para cada rol de usuario en el sistema de gestión de inventarios. La matriz de permisos controla qué operaciones puede realizar cada rol en los diferentes módulos del sistema.

## 🔐 Roles del Sistema

| Rol | Descripción | Nivel de Acceso |
|-----|-------------|-----------------|
| **Administrador** | Control total del sistema, gestión de usuarios y configuración | ⭐⭐⭐⭐⭐ |
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
| Editar usuario | ✅ | ❌ | ❌ | ❌ |
| Eliminar usuario | ✅ | ❌ | ❌ | ❌ |
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
| Crear producto | ✅ | ✅ | ❌ | ❌ |
| Editar producto | ✅ | ✅ | ❌ | ❌ |
| Eliminar producto | ✅ | ✅ | ❌ | ❌ |
| Activar/Desactivar producto | ✅ | ✅ | ❌ | ❌ |
| Subir imagen de producto | ✅ | ✅ | ❌ | ❌ |
| Actualizar precios | ✅ | ✅ | ❌ | ❌ |
| Ver historial de cambios | ✅ | ✅ | 📖 | ❌ |

---

### 4️⃣ Módulo de Inventarios

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar inventarios | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de inventario | ✅ | ✅ | ✅ | 📖 |
| Consultar stock disponible | ✅ | ✅ | ✅ | ✅ |
| Ajustar inventario | ✅ | ✅ | ✅ | ❌ |
| Ver alertas de stock mínimo | ✅ | ✅ | ✅ | 📖 |
| Reservar stock | ✅ | ✅ | ✅ | ✏️ |
| Liberar stock reservado | ✅ | ✅ | ✅ | ❌ |
| Ver ubicación física | ✅ | ✅ | ✅ | 📖 |
| Actualizar ubicación | ✅ | ✅ | ✅ | ❌ |
| Ver valorización | ✅ | ✅ | 📖 | ❌ |

---

### 5️⃣ Módulo de Movimientos

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar movimientos | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de movimiento | ✅ | ✅ | ✅ | 📖 |
| Registrar compra | ✅ | ✅ | ✅ | ❌ |
| Registrar venta | ✅ | ✅ | ✅ | ✏️ |
| Registrar transferencia | ✅ | ✅ | ✅ | ❌ |
| Registrar ajuste | ✅ | ✅ | ✅ | ❌ |
| Registrar devolución | ✅ | ✅ | ✅ | ❌ |
| Registrar merma | ✅ | ✅ | ✅ | ❌ |
| Cancelar movimiento | ✅ | ✅ | ✅ | ❌ |
| Completar movimiento | ✅ | ✅ | ✅ | ❌ |
| Editar movimiento pendiente | ✅ | ✅ | ✅ | ❌ |
| Ver costos | ✅ | ✅ | 📖 | ❌ |

---

### 6️⃣ Módulo de Tiendas

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar tiendas | ✅ | 📖 | 📖 | 📖 |
| Ver detalle de tienda | ✅ | ✅ | 📖 | 📖 |
| Crear tienda | ✅ | ❌ | ❌ | ❌ |
| Editar tienda | ✅ | ✏️ | ❌ | ❌ |
| Eliminar tienda | ✅ | ❌ | ❌ | ❌ |
| Activar/Desactivar tienda | ✅ | ❌ | ❌ | ❌ |
| Ver inventario de tienda | ✅ | ✅ | ✅ | 📖 |
| Ver usuarios de tienda | ✅ | ✅ | ❌ | ❌ |

---

### 7️⃣ Módulo de Almacenes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar almacenes | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de almacén | ✅ | ✅ | ✅ | 📖 |
| Crear almacén | ✅ | ✅ | ❌ | ❌ |
| Editar almacén | ✅ | ✅ | ✏️ | ❌ |
| Eliminar almacén | ✅ | ✅ | ❌ | ❌ |
| Activar/Desactivar almacén | ✅ | ✅ | ❌ | ❌ |
| Ver capacidad y ocupación | ✅ | ✅ | ✅ | 📖 |
| Gestionar ubicaciones físicas | ✅ | ✅ | ✅ | ❌ |

---

### 8️⃣ Módulo de Proveedores

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar proveedores | ✅ | ✅ | 📖 | ❌ |
| Ver detalle de proveedor | ✅ | ✅ | 📖 | ❌ |
| Crear proveedor | ✅ | ✅ | ❌ | ❌ |
| Editar proveedor | ✅ | ✅ | ❌ | ❌ |
| Eliminar proveedor | ✅ | ✅ | ❌ | ❌ |
| Activar/Desactivar proveedor | ✅ | ✅ | ❌ | ❌ |
| Ver productos de proveedor | ✅ | ✅ | 📖 | ❌ |
| Ver historial de compras | ✅ | ✅ | 📖 | ❌ |

---

### 9️⃣ Módulo de Lotes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar lotes | ✅ | ✅ | ✅ | 📖 |
| Ver detalle de lote | ✅ | ✅ | ✅ | 📖 |
| Crear lote | ✅ | ✅ | ✅ | ❌ |
| Editar lote | ✅ | ✅ | ✅ | ❌ |
| Ver fecha de vencimiento | ✅ | ✅ | ✅ | 📖 |
| Subir certificado de calidad | ✅ | ✅ | ✅ | ❌ |
| Ver alertas de vencimiento | ✅ | ✅ | ✅ | 📖 |
| Trazabilidad del lote | ✅ | ✅ | ✅ | ❌ |

---

### 🔟 Módulo de Categorías

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Listar categorías | ✅ | ✅ | 📖 | 📖 |
| Ver detalle de categoría | ✅ | ✅ | 📖 | 📖 |
| Crear categoría | ✅ | ✅ | ❌ | ❌ |
| Editar categoría | ✅ | ✅ | ❌ | ❌ |
| Eliminar categoría | ✅ | ✅ | ❌ | ❌ |
| Activar/Desactivar categoría | ✅ | ✅ | ❌ | ❌ |
| Crear subcategorías | ✅ | ✅ | ❌ | ❌ |
| Ver productos de categoría | ✅ | ✅ | ✅ | 📖 |

---

### 1️⃣1️⃣ Módulo de Reportes

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Dashboard general | ✅ | ✅ | 📖 | 📖 |
| Reporte de inventario | ✅ | ✅ | ✅ | 📖 |
| Reporte de movimientos | ✅ | ✅ | ✅ | 📖 |
| Reporte de ventas | ✅ | ✅ | ❌ | 📖 |
| Reporte de compras | ✅ | ✅ | 📖 | ❌ |
| Reporte de valorización | ✅ | ✅ | ❌ | ❌ |
| Reporte de stock mínimo | ✅ | ✅ | ✅ | 📖 |
| Reporte de vencimientos | ✅ | ✅ | ✅ | ❌ |
| Reporte de auditoría | ✅ | ✅ | ❌ | ❌ |
| Exportar reportes (PDF/Excel) | ✅ | ✅ | 📖 | ❌ |

---

### 1️⃣2️⃣ Módulo de Sincronización

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Ver estado de sincronización | ✅ | ✅ | ✅ | ✅ |
| Forzar sincronización manual | ✅ | ✅ | ✅ | ✅ |
| Resolver conflictos | ✅ | ✅ | ❌ | ❌ |
| Ver cola de sincronización | ✅ | ✅ | 📖 | ❌ |
| Configurar intervalo de sync | ✅ | ❌ | ❌ | ❌ |
| Ver logs de sincronización | ✅ | ✅ | ❌ | ❌ |

---

### 1️⃣3️⃣ Módulo de Configuración

| Funcionalidad | Administrador | Gerente | Almacenero | Vendedor |
|---------------|---------------|---------|------------|----------|
| Ver configuración general | ✅ | 📖 | ❌ | ❌ |
| Editar configuración general | ✅ | ❌ | ❌ | ❌ |
| Gestionar roles y permisos | ✅ | ❌ | ❌ | ❌ |
| Configurar unidades de medida | ✅ | ✅ | ❌ | ❌ |
| Ver auditoría del sistema | ✅ | 📖 | ❌ | ❌ |
| Gestionar backup/restore | ✅ | ❌ | ❌ | ❌ |
| Configurar notificaciones | ✅ | ✏️ | ✏️ | ✏️ |

---

## 📋 Resumen de Permisos por Rol

### 👑 Administrador
- **Acceso completo** a todos los módulos del sistema
- Gestión de usuarios, roles y permisos
- Configuración del sistema
- Acceso a auditorías y logs
- Backup y restore

### 👨‍💼 Gerente
- Gestión operativa del negocio
- Creación y edición de productos, proveedores, almacenes
- Acceso completo a movimientos e inventarios
- Reportes y análisis completos
- Solo lectura en usuarios
- Sin acceso a configuración del sistema

### 📦 Almacenero
- Control total de inventarios y stock
- Registro de movimientos (compras, transferencias, ajustes)
- Gestión de lotes y ubicaciones físicas
- Reportes de inventario
- Solo lectura en productos y proveedores
- Sin acceso a usuarios ni configuración

### 🛒 Vendedor
- Consulta de productos e inventarios
- Registro de ventas
- Consulta de disponibilidad de stock
- Reportes básicos de ventas
- Sin acceso a costos ni valorización
- Sin acceso a gestión administrativa

---

## 🔒 Implementación Técnica

### Row Level Security (RLS) en Supabase

Las políticas RLS están configuradas usando **EXISTS() inline** para validar permisos según el rol del usuario:

```sql
-- Ejemplo: Solo Gerentes y Administradores pueden crear productos
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

### Validación en Frontend (BLoC)

Los permisos también se validan en la capa de presentación:

```dart
// Ejemplo en AuthBloc
bool hasPermission(String permission) {
  final userRole = currentUser?.rol?.nombre;
  
  return switch (userRole) {
    'Administrador' => true,
    'Gerente' => _gerentePermissions.contains(permission),
    'Almacenero' => _almaceneroPermissions.contains(permission),
    'Vendedor' => _vendedorPermissions.contains(permission),
    _ => false,
  };
}
```

---

## 🔄 Actualizaciones

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2024-01-15 | Versión inicial de la matriz de permisos |

---

## 📞 Contacto

Para solicitudes de cambios en permisos o nuevos roles, contactar al administrador del sistema.

---

## ⚠️ Notas Importantes

1. **Los permisos son acumulativos**: Un Administrador tiene todos los permisos de roles inferiores
2. **RLS es la última línea de defensa**: Aunque el frontend valide permisos, el backend (Supabase RLS) es quien garantiza la seguridad
3. **Auditoría obligatoria**: Todas las acciones críticas quedan registradas en la tabla `auditorias`
4. **Permisos temporales**: Para accesos especiales temporales, contactar al Administrador
5. **Revisión periódica**: Esta matriz debe revisarse cada 6 meses o cuando cambien los procesos del negocio
