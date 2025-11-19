# Guía de Sincronización (Pull from Server)

## Descripción General

El sistema ahora cuenta con funcionalidad completa de sincronización bidireccional:
- **Push**: Los cambios locales se envían automáticamente a Supabase cuando hay conexión
- **Pull**: Los datos del servidor se descargan a la base de datos local

## ¿Cómo usar la sincronización Pull?

### Opción 1: Desde la interfaz (Recomendado para usuarios)

1. Abre la aplicación
2. En la pantalla principal (HomePage), busca el botón de sincronización en el AppBar (ícono de sync ↻)
3. Presiona el botón
4. La aplicación mostrará:
   - Un indicador de progreso mientras sincroniza
   - Un mensaje de éxito ✅ cuando termine
   - Un mensaje de error ❌ si algo falla

### Opción 2: Programáticamente

```dart
import 'package:flutter_management_system/core/di/injection_container.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';

// Obtener la instancia del SyncManager
final syncManager = getIt<SyncManager>();

// Ejecutar sincronización
final result = await syncManager.syncAll();

// Manejar resultado
result.fold(
  (failure) {
    print('Error: ${failure.message}');
  },
  (_) {
    print('Sincronización exitosa');
  },
);
```

## ¿Qué datos se sincronizan?

El método `_pullFromServer()` descarga los siguientes datos en orden:

### 1. Datos de Referencia (primero por dependencias de FK)
- **Categorías**: Todas las categorías de productos
- **Unidades de Medida**: Todas las unidades (kg, m, lt, etc.)

### 2. Datos Maestros
- **Tiendas**: Todas las tiendas del sistema
- **Proveedores**: Todos los proveedores registrados
- **Almacenes**: Todos los almacenes por tienda

### 3. Datos Transaccionales
- **Productos**: Todos los productos con sus relaciones
- **Lotes**: Todos los lotes de productos

## Flujo de Sincronización

```
┌─────────────────────┐
│   Usuario presiona  │
│   botón de sync     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  SyncManager.       │
│  syncAll()          │
└──────────┬──────────┘
           │
           ├──────────────────┐
           │                  │
           ▼                  ▼
    ┌──────────┐      ┌─────────────┐
    │  PUSH    │      │    PULL     │
    │ (Local → │      │ (Server →   │
    │  Server) │      │   Local)    │
    └──────────┘      └─────────────┘
           │                  │
           │     ┌────────────┴──────────────┐
           │     │                           │
           ▼     ▼                           ▼
    ┌─────────────────┐          ┌──────────────────┐
    │ Sync Queue      │          │  Pull Categorías │
    │ Items           │          │  Pull Unidades   │
    └─────────────────┘          │  Pull Tiendas    │
                                 │  Pull Proveedores│
                                 │  Pull Almacenes  │
                                 │  Pull Productos  │
                                 │  Pull Lotes      │
                                 └──────────────────┘
                                          │
                                          ▼
                                  ┌───────────────┐
                                  │ SQLite Local  │
                                  │ insertOrUpdate│
                                  └───────────────┘
```

## Características Importantes

### 1. Sincronización Automática
- La sincronización se ejecuta automáticamente cada 15 minutos
- También se ejecuta cuando se detecta conexión a internet después de estar offline

### 2. Sincronización Manual
- Presiona el botón de sync en cualquier momento
- Útil cuando cambias de dispositivo y necesitas los datos inmediatamente

### 3. Manejo de Conflictos
- `insertOnConflictUpdate`: Si un registro ya existe localmente, se actualiza con los datos del servidor
- Los IDs se mantienen consistentes entre dispositivos

### 4. Validación de Integridad
- Las Foreign Keys se respetan durante la sincronización
- Los datos se sincronizan en orden para evitar errores de FK

## Casos de Uso

### Caso 1: Nuevo Dispositivo
1. Instala la aplicación en un nuevo dispositivo
2. Inicia sesión con tu cuenta de Supabase
3. Presiona el botón de sincronización
4. Todos los datos se descargarán a tu dispositivo local
5. Ya puedes crear lotes (los productos/proveedores están disponibles)

### Caso 2: Cambio de Dispositivo
- Mismo flujo que el Caso 1
- Tus datos locales anteriores se sincronizan con el servidor
- Los nuevos datos del servidor se descargan al nuevo dispositivo

### Caso 3: Trabajo Offline
1. Trabajas sin conexión creando productos/lotes
2. Los cambios se guardan en la cola de sincronización local
3. Cuando recuperas conexión:
   - Los cambios locales se envían al servidor (PUSH)
   - Los cambios del servidor se descargan localmente (PULL)

## Notas Técnicas

### Arquitectura
- **AppDatabase**: Base de datos SQLite local (Drift)
- **RemoteDataSources**: Conexión a Supabase (PostgreSQL)
- **SyncManager**: Coordina la sincronización bidireccional
- **SyncQueue**: Cola de operaciones pendientes

### Manejo de Datos Nullable
Los datos del servidor pueden tener valores null. El pull maneja esto de dos formas:
- **Campos requeridos**: Se proporciona un valor por defecto (ej: `?? ''` para strings)
- **Campos opcionales**: Se mantiene como null usando `Value(data['field'] as String?)`

### Performance
- La sincronización es incremental cuando sea posible
- Se utiliza `insertOnConflictUpdate` para operaciones upsert eficientes
- Las operaciones se ejecutan en lote para mejor rendimiento

## Troubleshooting

### "Sin conexión a internet"
- Verifica tu conexión WiFi/datos móviles
- La sincronización se ejecutará automáticamente cuando recuperes conexión

### "Error syncing X"
- Revisa los logs de la aplicación
- Verifica que tu cuenta de Supabase tenga los permisos correctos
- Asegúrate de que las tablas en Supabase existan

### "FK constraint failed al crear lote"
- Esto ya no debería ocurrir después de sincronizar
- Si persiste, presiona el botón de sincronización nuevamente
- Los productos y proveedores deben existir localmente antes de crear lotes

## Mejoras Futuras

1. **Sincronización Selectiva**: Permitir sincronizar solo ciertas entidades
2. **Sincronización Incremental**: Solo descargar cambios desde la última sincronización
3. **Resolución de Conflictos**: UI para resolver conflictos manualmente
4. **Progress Indicator**: Mostrar progreso detallado por entidad
5. **Background Sync**: Sincronización en segundo plano usando WorkManager

## Referencias

- Código: `lib/core/sync/sync_manager.dart`
- UI: `lib/presentation/pages/home/home_page.dart`
- DI: `lib/core/di/injection_container.dart`
