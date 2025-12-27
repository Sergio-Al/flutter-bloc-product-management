# NestJS Backend Integration

Este documento describe la integración del sistema Flutter con el backend NestJS para gestión de inventarios y productos de materiales de construcción.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Arquitectura](#arquitectura)
- [Configuración de Conexión](#configuración-de-conexión)
- [Autenticación](#autenticación)
- [Endpoints API](#endpoints-api)
- [Formato de Datos](#formato-de-datos)
- [Roles y Permisos](#roles-y-permisos)
- [Sincronización](#sincronización)
- [Troubleshooting](#troubleshooting)

## 📝 Descripción

El backend NestJS proporciona una API REST completa para:
- Autenticación con JWT y MFA (Multi-Factor Authentication)
- Gestión de usuarios, roles y permisos
- CRUD de productos, inventarios, almacenes, tiendas, proveedores y lotes
- Movimientos de inventario (entradas, salidas, transferencias)
- Sincronización offline-first con la app Flutter

## 🏗️ Arquitectura

```
┌─────────────────────┐     ┌─────────────────────┐
│   Flutter App       │     │   NestJS Backend    │
│                     │     │                     │
│  ┌───────────────┐  │     │  ┌───────────────┐  │
│  │ Presentation  │  │     │  │  Controllers  │  │
│  │    (BLoC)     │  │     │  └───────┬───────┘  │
│  └───────┬───────┘  │     │          │          │
│          │          │     │  ┌───────▼───────┐  │
│  ┌───────▼───────┐  │     │  │   Services    │  │
│  │  Repository   │  │     │  └───────┬───────┘  │
│  └───────┬───────┘  │     │          │          │
│          │          │     │  ┌───────▼───────┐  │
│  ┌───────▼───────┐  │ HTTP│  │  TypeORM /    │  │
│  │ Remote Data   │◄─┼─────┼──┤  PostgreSQL   │  │
│  │   Source      │  │     │  └───────────────┘  │
│  └───────┬───────┘  │     │                     │
│          │          │     │  ┌───────────────┐  │
│  ┌───────▼───────┐  │     │  │   JWT Auth    │  │
│  │ Local SQLite  │  │     │  │   + MFA       │  │
│  │   (Drift)     │  │     │  └───────────────┘  │
│  └───────────────┘  │     │                     │
└─────────────────────┘     └─────────────────────┘
```

## ⚙️ Configuración de Conexión

### Variables de Entorno (.env)

```bash
# NestJS Backend
API_BASE_URL=http://localhost:3000

# Para iOS Simulator
API_BASE_URL=http://localhost:3000

# Para Android Emulator
API_BASE_URL=http://10.0.2.2:3000

# Para dispositivo físico (usar IP de tu máquina)
API_BASE_URL=http://192.168.1.100:3000

# Debug
DEBUG_MODE=true
ENVIRONMENT=development
```

### Configuración en Flutter

La configuración se maneja en `lib/core/config/env_config.dart`:

```dart
class EnvConfig {
  static String get apiBaseUrl => 
    const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
}
```

### iOS Simulator - Configuración Especial

Para iOS Simulator, asegúrate de que `Info.plist` permita conexiones HTTP locales:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

## 🔐 Autenticación

### Flujo de Login

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│  Login   │───▶│  Check   │───▶│  Return  │
│  Request │    │   MFA    │    │  Tokens  │
└──────────┘    └────┬─────┘    └──────────┘
                     │
                     ▼ (if MFA enabled)
               ┌──────────┐    ┌──────────┐
               │  Verify  │───▶│  Return  │
               │   TOTP   │    │  Tokens  │
               └──────────┘    └──────────┘
```

### Endpoints de Autenticación

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/login` | Login con email/password |
| POST | `/auth/register` | Registro de nuevo usuario |
| POST | `/auth/refresh` | Refrescar access token |
| POST | `/auth/logout` | Cerrar sesión |
| GET | `/auth/profile` | Obtener perfil del usuario |
| POST | `/auth/mfa/verify` | Verificar código MFA |
| POST | `/auth/mfa/enable` | Habilitar MFA |
| POST | `/auth/mfa/disable` | Deshabilitar MFA |

### Respuesta de Login (sin MFA)

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "nombreCompleto": "Juan Pérez",
    "rol": {
      "id": "uuid",
      "nombre": "Gerente"
    },
    "tienda": {
      "id": "uuid",
      "nombre": "Tienda Central"
    }
  }
}
```

### Respuesta de Login (requiere MFA)

```json
{
  "requires_mfa": true,
  "temp_token": "temporary-token-for-mfa-verification"
}
```

### Headers de Autenticación

```dart
headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $accessToken',
}
```

## 📡 Endpoints API

### Productos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/productos` | Listar todos los productos |
| GET | `/productos/:id` | Obtener producto por ID |
| POST | `/productos` | Crear producto |
| PATCH | `/productos/:id` | Actualizar producto |
| DELETE | `/productos/:id` | Eliminar producto (soft delete) |

### Inventarios

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/inventarios` | Listar inventarios |
| GET | `/inventarios/:id` | Obtener inventario por ID |
| POST | `/inventarios` | Crear inventario |
| PATCH | `/inventarios/:id` | Actualizar inventario |
| DELETE | `/inventarios/:id` | Eliminar inventario |

### Almacenes

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/almacenes` | Listar almacenes |
| GET | `/almacenes/:id` | Obtener almacén por ID |
| POST | `/almacenes` | Crear almacén |
| PATCH | `/almacenes/:id` | Actualizar almacén |
| DELETE | `/almacenes/:id` | Eliminar almacén |

### Tiendas

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/tiendas` | Listar tiendas |
| GET | `/tiendas/:id` | Obtener tienda por ID |
| POST | `/tiendas` | Crear tienda |
| PATCH | `/tiendas/:id` | Actualizar tienda |
| DELETE | `/tiendas/:id` | Eliminar tienda |

### Proveedores

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/proveedores` | Listar proveedores |
| GET | `/proveedores/:id` | Obtener proveedor por ID |
| POST | `/proveedores` | Crear proveedor |
| PATCH | `/proveedores/:id` | Actualizar proveedor |
| DELETE | `/proveedores/:id` | Eliminar proveedor |

### Lotes

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/lotes` | Listar lotes |
| GET | `/lotes/:id` | Obtener lote por ID |
| POST | `/lotes` | Crear lote |
| PATCH | `/lotes/:id` | Actualizar lote |
| DELETE | `/lotes/:id` | Eliminar lote |

### Movimientos

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/movimientos` | Listar movimientos |
| GET | `/movimientos/:id` | Obtener movimiento por ID |
| POST | `/movimientos` | Crear movimiento |
| PATCH | `/movimientos/:id` | Actualizar movimiento |

### Categorías

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/categorias` | Listar categorías |
| GET | `/categorias/:id` | Obtener categoría por ID |

### Unidades de Medida

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/unidades-medida` | Listar unidades de medida |
| GET | `/unidades-medida/:id` | Obtener unidad por ID |

## 📦 Formato de Datos

### Convención de Nomenclatura

El API utiliza una **convención mixta** para compatibilidad:

- **IDs de relaciones**: `camelCase` (ej: `productoId`, `almacenId`, `tiendaId`)
- **Otros campos**: `snake_case` (ej: `nombre_completo`, `fecha_movimiento`)

### Ejemplo: Crear Producto

```json
POST /productos
{
  "nombre": "Cemento Fancesa IP-30",
  "codigo": "CEM-001",
  "descripcion": "Cemento Portland tipo IP-30",
  "categoriaId": "uuid-categoria",
  "unidadMedidaId": "uuid-unidad",
  "proveedorPrincipalId": "uuid-proveedor",
  "precio_compra": 55.00,
  "precio_venta": 65.00,
  "stock_minimo": 100,
  "stock_maximo": 1000,
  "marca": "Fancesa",
  "activo": true
}
```

### Ejemplo: Crear Inventario

```json
POST /inventarios
{
  "id": "uuid-local",  // UUID generado localmente para sync
  "productoId": "uuid-producto",
  "almacenId": "uuid-almacen",
  "tiendaId": "uuid-tienda",
  "loteId": "uuid-lote",
  "cantidad_actual": 500,
  "cantidad_reservada": 0,
  "ubicacion_fisica": "Pasillo A, Estante 3"
}
```

### Ejemplo: Crear Movimiento

```json
POST /movimientos
{
  "numero_movimiento": "MOV-2024-001",
  "productoId": "uuid-producto",
  "inventarioId": "uuid-inventario",
  "tiendaOrigenId": "uuid-tienda-origen",
  "tiendaDestinoId": "uuid-tienda-destino",
  "tipo": "TRANSFERENCIA",
  "cantidad": 50,
  "costo_unitario": 55.00,
  "usuarioId": "uuid-usuario",
  "estado": "PENDIENTE",
  "observaciones": "Transferencia entre sucursales"
}
```

## 👥 Roles y Permisos

### Roles del Sistema

| Rol | Descripción |
|-----|-------------|
| **Administrador** | Acceso completo al sistema |
| **Gerente** | Gestión de productos, tiendas e inventarios |
| **Almacenero** | Gestión de inventarios y movimientos |
| **Vendedor** | Solo lectura en la mayoría de módulos |

### Matriz de Permisos

| Módulo | Administrador | Gerente | Almacenero | Vendedor |
|--------|---------------|---------|------------|----------|
| **Productos** | 📖 Read | ✏️ CRU | 📖 Read | 📖 Read |
| **Categorías** | ✅ Full | 📖 Read | 📖 Read | 📖 Read |
| **Proveedores** | ✅ Full | ✅ Full | 📖 Read | 📖 Read |
| **Tiendas** | ✅ Full | ✏️ RU | 📖 Read | 📖 Read |
| **Almacenes** | ✅ Full | ✅ Full | 📖 Read | 📖 Read |
| **Lotes** | ✅ Full | ✅ Full | ✏️ CRU | 📖 Read |
| **Inventarios** | ✅ Full | ✅ Full | ✏️ CRU | 📖 Read |
| **Movimientos** | ✅ Full | ✅ Full | ✏️ CRU | 📝 CR |
| **Usuarios** | ✅ Full | ❌ None | ❌ None | ❌ None |
| **Roles** | ✅ Full | ❌ None | ❌ None | ❌ None |

**Leyenda:**
- ✅ Full = Create, Read, Update, Delete
- ✏️ CRU = Create, Read, Update (sin Delete)
- 📝 CR = Create, Read
- 📖 Read = Solo lectura
- ❌ None = Sin acceso

### Implementación en Flutter

Los permisos se verifican usando `PermissionHelper`:

```dart
import 'package:flutter_management_system/core/permissions/permission_helper.dart';

// Verificar si puede crear producto
if (PermissionHelper.canCreateProducto(userRole)) {
  // Mostrar botón de crear
}

// Verificar si puede editar
if (PermissionHelper.canEditProducto(userRole)) {
  // Mostrar botón de editar
}

// Verificar si puede eliminar
if (PermissionHelper.canDeleteProducto(userRole)) {
  // Mostrar botón de eliminar
}
```

## 🔄 Sincronización

### Estrategia Offline-First

1. **Operaciones locales primero**: Todas las operaciones se guardan en SQLite local
2. **Cola de sincronización**: Cambios pendientes se encolan para sync
3. **Sincronización en background**: Cuando hay conexión, se sincronizan los cambios
4. **Resolución de conflictos**: Última escritura gana (con timestamp)

### Formato de Sync

Para sincronización, incluir el campo `id` con el UUID local:

```json
{
  "id": "uuid-generado-localmente",
  "productoId": "uuid-producto",
  "almacenId": "uuid-almacen",
  // ... otros campos
}
```

### Estados de Sincronización

| Estado | Descripción |
|--------|-------------|
| `synced` | Datos sincronizados con servidor |
| `pending` | Cambios pendientes de sincronizar |
| `conflict` | Conflicto detectado, requiere resolución |
| `error` | Error en sincronización |

## 🐛 Troubleshooting

### Error: Connection refused (iOS Simulator)

**Problema**: La app no puede conectar a `localhost:3000`

**Solución**:
1. Verificar que el backend NestJS está corriendo
2. Usar `localhost` (no `127.0.0.1`) para iOS Simulator
3. Verificar `Info.plist` permite conexiones HTTP locales

### Error: Connection timeout (Android Emulator)

**Problema**: Timeout conectando al backend

**Solución**:
1. Usar `10.0.2.2:3000` en lugar de `localhost`
2. Verificar firewall permite conexiones
3. Verificar que el backend acepta conexiones externas

### Error: 401 Unauthorized

**Problema**: Token inválido o expirado

**Solución**:
1. Verificar que el token se está enviando en headers
2. Implementar refresh automático de token
3. Verificar que el token no ha expirado

### Error: Foreign Key Constraint (Local DB)

**Problema**: Error al guardar usuario en SQLite local

**Solución**:
El sistema crea automáticamente registros placeholder para roles y tiendas cuando el usuario se autentica. Si persiste el error:
1. Verificar que `rolId` y `tiendaId` del usuario son válidos
2. Limpiar base de datos local y re-autenticar

### Error: Role/Permissions null after restart

**Problema**: Permisos no funcionan después de reiniciar la app

**Solución**:
Los campos `rolNombre` y `tiendaNombre` ahora se cachean en SharedPreferences. Si el problema persiste:
1. Cerrar sesión y volver a iniciar
2. Verificar que el backend devuelve el objeto `rol` anidado en la respuesta

## 📚 Archivos Clave

### Remote Datasources

| Archivo | Descripción |
|---------|-------------|
| `auth_remote_datasource.dart` | Autenticación con NestJS |
| `producto_remote_datasource.dart` | CRUD de productos |
| `inventario_remote_datasource.dart` | CRUD de inventarios |
| `almacen_remote_datasource.dart` | CRUD de almacenes |
| `tienda_remote_datasource.dart` | CRUD de tiendas |
| `proveedor_remote_datasource.dart` | CRUD de proveedores |
| `lote_remote_datasource.dart` | CRUD de lotes |
| `movimiento_remote_datasource.dart` | CRUD de movimientos |
| `categoria_remote_datasource.dart` | Lectura de categorías |
| `unidad_medida_remote_datasource.dart` | Lectura de unidades |

### Configuración

| Archivo | Descripción |
|---------|-------------|
| `lib/core/config/env_config.dart` | Variables de entorno |
| `lib/core/config/app_config.dart` | Configuración de la app |
| `lib/core/di/injection_container.dart` | Inyección de dependencias |

### Permisos

| Archivo | Descripción |
|---------|-------------|
| `lib/core/permissions/permission_helper.dart` | Helper de permisos por rol |
| `lib/presentation/pages/home/utils/menu_config.dart` | Configuración de menú por rol |

## 🔗 Referencias

- [NestJS Documentation](https://docs.nestjs.com/)
- [JWT Authentication](https://jwt.io/)
- [Flutter HTTP Package](https://pub.dev/packages/http)
- [Drift (SQLite)](https://drift.simonbinder.eu/)

---

**Última actualización**: Diciembre 2025
**Versión del Backend**: NestJS + PostgreSQL
**Branch**: `feature/nest-remote`
