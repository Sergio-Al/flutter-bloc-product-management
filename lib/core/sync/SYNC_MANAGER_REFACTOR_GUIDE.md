# SyncManager Refactoring Guide

## 📋 Current Status

The `SyncManager` is functional but has incomplete implementations. This guide outlines what needs to be done to make it production-ready.

## ⚠️ Issues to Address

### 1. **Incomplete Sync Methods**

**Current State:**
```dart
Future<Either<Failure, void>> _syncProducto(SyncItem item) async {
  // TODO: Implementar con el datasource real
  return const Right(null);
}
```

**Problem:** 
- All `_syncXXX()` methods are stubs
- No actual communication with remote datasources
- No conflict detection
- No retry logic

**Solution:**
Create actual implementations that:
1. Call remote datasources
2. Handle responses
3. Detect conflicts (compare timestamps)
4. Update local DB on success

---

### 2. **Missing Remote Datasource Dependencies**

**Current State:**
```dart
class SyncManager {
  final AppDatabase _localDb;
  final SyncQueue _syncQueue;
  final NetworkInfo _networkInfo;
  final ConflictResolver _conflictResolver;
  // No remote datasources!
}
```

**Problem:**
- Can't sync without remote datasources
- Each entity type needs its own remote datasource

**Solution:**
Add remote datasources as dependencies:

```dart
class SyncManager {
  final AppDatabase _localDb;
  final SyncQueue _syncQueue;
  final NetworkInfo _networkInfo;
  final ConflictResolver _conflictResolver;
  
  // Add remote datasources
  final ProductoRemoteDatasource _productoRemote;
  final InventarioRemoteDatasource _inventarioRemote;
  final MovimientoRemoteDatasource _movimientoRemote;
  final TiendaRemoteDatasource _tiendaRemote;
  final AlmacenRemoteDatasource _almacenRemote;
  final ProveedorRemoteDatasource _proveedorRemote;
  // ... others

  SyncManager({
    required AppDatabase localDb,
    required SyncQueue syncQueue,
    required NetworkInfo networkInfo,
    required ProductoRemoteDatasource productoRemote,
    required InventarioRemoteDatasource inventarioRemote,
    // ... inject all datasources
    ConflictResolver? conflictResolver,
  }) : _localDb = localDb,
       _syncQueue = syncQueue,
       _networkInfo = networkInfo,
       _productoRemote = productoRemote,
       _inventarioRemote = inventarioRemote,
       // ...
       _conflictResolver = conflictResolver ?? ConflictResolver();
}
```

---

### 3. **No Pull From Server Implementation**

**Current State:**
```dart
Future<void> _pullFromServer() async {
  // TODO: Implementar lógica para traer cambios del servidor
}
```

**Problem:**
- Only pushes local changes, never pulls remote changes
- Can't detect if server has newer data
- Offline changes from other users won't sync down

**Solution:**
Implement incremental pull strategy:

```dart
Future<void> _pullFromServer() async {
  try {
    // Get last sync timestamp from SharedPreferences
    final lastSync = await _getLastSyncTimestamp();
    
    // Pull changes for each entity type since last sync
    await _pullProductos(lastSync);
    await _pullInventarios(lastSync);
    await _pullMovimientos(lastSync);
    // ... other entities
    
    // Update last sync timestamp
    await _updateLastSyncTimestamp(DateTime.now());
  } catch (e) {
    // Handle error
  }
}

Future<void> _pullProductos(DateTime? since) async {
  try {
    // Get productos changed since last sync
    final productos = await _productoRemote.getChangedSince(since);
    
    for (final producto in productos) {
      // Check if exists locally
      final local = await _localDb.productoDao.findById(producto.id);
      
      if (local == null) {
        // Insert new producto
        await _localDb.productoDao.insertProducto(producto);
      } else {
        // Check for conflicts
        if (local.updatedAt.isAfter(producto.updatedAt)) {
          // Local is newer - potential conflict
          final conflict = SyncConflict(
            id: producto.id,
            table: 'productos',
            localRecord: local.toJson(),
            serverRecord: producto.toJson(),
            localTimestamp: local.updatedAt,
            serverTimestamp: producto.updatedAt,
          );
          
          // Resolve conflict using strategy
          final resolved = await _conflictResolver.resolve(conflict);
          // Apply resolution...
        } else {
          // Server is newer - update local
          await _localDb.productoDao.updateProducto(producto);
        }
      }
    }
  } catch (e) {
    // Handle error
  }
}
```

---

### 4. **No Last Sync Timestamp Tracking**

**Problem:**
- Every sync pulls ALL data from server
- Wastes bandwidth and time
- Can't do incremental syncs

**Solution:**
Add timestamp tracking:

```dart
// Constants
static const String _lastSyncKey = 'last_sync_timestamp';

// Get last sync
Future<DateTime?> _getLastSyncTimestamp() async {
  final timestamp = _prefs.getInt(_lastSyncKey);
  return timestamp != null 
    ? DateTime.fromMillisecondsSinceEpoch(timestamp)
    : null;
}

// Update last sync
Future<void> _updateLastSyncTimestamp(DateTime timestamp) async {
  await _prefs.setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
}

// Use in pull
final lastSync = await _getLastSyncTimestamp();
final changes = await _productoRemote.getChangedSince(lastSync);
```

---

### 5. **No Batch Syncing**

**Current State:**
```dart
for (final item in pendingItems) {
  final result = await _syncItem(item);  // One by one
  // ...
}
```

**Problem:**
- Syncs items sequentially
- Slow for many items
- Multiple HTTP requests instead of one

**Solution:**
Implement batch syncing:

```dart
Future<Either<Failure, void>> syncAll() async {
  // ... existing checks ...
  
  final pendingItems = _syncQueue.getPending();
  
  // Group items by entity type
  final groupedItems = _groupByEntityType(pendingItems);
  
  // Sync each type in batch
  for (final entry in groupedItems.entries) {
    final entityType = entry.key;
    final items = entry.value;
    
    final result = await _syncBatch(entityType, items);
    
    result.fold(
      (failure) => errors.add(failure),
      (success) {
        // Remove all successful items from queue
        for (final item in items) {
          _syncQueue.remove(item.id);
        }
      },
    );
  }
  
  // ...
}

Map<SyncEntityType, List<SyncItem>> _groupByEntityType(List<SyncItem> items) {
  final grouped = <SyncEntityType, List<SyncItem>>{};
  for (final item in items) {
    grouped.putIfAbsent(item.entityType, () => []).add(item);
  }
  return grouped;
}

Future<Either<Failure, void>> _syncBatch(
  SyncEntityType type,
  List<SyncItem> items,
) async {
  switch (type) {
    case SyncEntityType.producto:
      return await _syncProductoBatch(items);
    case SyncEntityType.inventario:
      return await _syncInventarioBatch(items);
    // ... others
    default:
      return Left(SyncFailure(message: 'Unsupported type: $type'));
  }
}

Future<Either<Failure, void>> _syncProductoBatch(List<SyncItem> items) async {
  try {
    // Prepare batch payload
    final creates = items
        .where((i) => i.operation == SyncOperation.create)
        .map((i) => i.data)
        .toList();
    
    final updates = items
        .where((i) => i.operation == SyncOperation.update)
        .map((i) => i.data)
        .toList();
    
    final deletes = items
        .where((i) => i.operation == SyncOperation.delete)
        .map((i) => i.entityId)
        .toList();
    
    // Send batch to server
    await _productoRemote.syncBatch(
      creates: creates,
      updates: updates,
      deletes: deletes,
    );
    
    return const Right(null);
  } catch (e) {
    return Left(SyncFailure(message: e.toString()));
  }
}
```

---

### 6. **Missing Entity Types**

**Current State:**
```dart
switch (item.entityType) {
  case SyncEntityType.producto:
    return await _syncProducto(item);
  case SyncEntityType.inventario:
    return await _syncInventario(item);
  case SyncEntityType.movimiento:
    return await _syncMovimiento(item);
  // Only 3 out of 12 tables!
  default:
    return Left(SyncFailure(message: 'Tipo de entidad no soportado'));
}
```

**Problem:**
- Only handles 3 entity types
- Your DB has 12 tables
- 9 entity types can't sync

**Solution:**
Add all entity types:

```dart
enum SyncEntityType {
  producto,
  inventario,
  movimiento,
  tienda,
  almacen,
  proveedor,
  lote,
  categoria,
  unidadMedida,
  usuario,
  rol,
  auditoria,
}

// Add cases for all types
switch (item.entityType) {
  case SyncEntityType.producto:
    return await _syncProducto(item);
  case SyncEntityType.inventario:
    return await _syncInventario(item);
  case SyncEntityType.movimiento:
    return await _syncMovimiento(item);
  case SyncEntityType.tienda:
    return await _syncTienda(item);
  case SyncEntityType.almacen:
    return await _syncAlmacen(item);
  case SyncEntityType.proveedor:
    return await _syncProveedor(item);
  case SyncEntityType.lote:
    return await _syncLote(item);
  case SyncEntityType.categoria:
    return await _syncCategoria(item);
  case SyncEntityType.unidadMedida:
    return await _syncUnidadMedida(item);
  case SyncEntityType.usuario:
    return await _syncUsuario(item);
  case SyncEntityType.rol:
    return await _syncRol(item);
  case SyncEntityType.auditoria:
    return await _syncAuditoria(item);
  default:
    return Left(SyncFailure(message: 'Unsupported type: ${item.entityType}'));
}
```

---

### 7. **No Conflict Resolution Strategy**

**Problem:**
- Detects conflicts but doesn't resolve them
- Just adds to conflicts list
- User has to manually intervene every time

**Solution:**
Implement automatic resolution strategies:

```dart
Future<Either<Failure, void>> _syncItem(SyncItem item) async {
  try {
    final result = await _performSync(item);
    
    return result.fold(
      (failure) async {
        if (failure is ConflictFailure) {
          // Try to auto-resolve
          final strategy = _conflictResolver.getAutoStrategy(failure.conflict);
          
          if (strategy != null) {
            final resolved = await _conflictResolver.resolve(
              failure.conflict,
              strategy,
            );
            
            if (resolved) {
              // Retry sync with resolved data
              return await _performSync(item);
            }
          }
          
          // Can't auto-resolve - return conflict
          return Left(failure);
        }
        
        return Left(failure);
      },
      (success) => const Right(null),
    );
  } catch (e) {
    return Left(SyncFailure(message: e.toString()));
  }
}
```

---

## 📝 Implementation Priority

### Phase 1: Core Functionality (High Priority)
1. ✅ Create all remote datasources
2. ✅ Add SharedPreferences for timestamp tracking
3. ✅ Implement `_pullFromServer()` with incremental sync
4. ✅ Implement actual `_syncProducto()` with real datasource
5. ✅ Add timestamp tracking (`_getLastSyncTimestamp`, `_updateLastSyncTimestamp`)

### Phase 2: Complete Entity Support (High Priority)
6. ✅ Add all entity types to `SyncEntityType` enum
7. ✅ Implement `_syncXXX()` for all 12 entity types
8. ✅ Add remote datasources for all entities

### Phase 3: Optimization (Medium Priority)
9. ✅ Implement batch syncing
10. ✅ Add retry logic with exponential backoff
11. ✅ Implement conflict auto-resolution strategies
12. ✅ Add progress tracking (current item / total items)

### Phase 4: Advanced Features (Low Priority)
13. ⏳ Add sync prioritization (critical entities first)
14. ⏳ Implement selective sync (only certain entities)
15. ⏳ Add sync scheduling (custom intervals per entity type)
16. ⏳ Implement delta syncing (only changed fields)

---

## 🔧 Step-by-Step Implementation

### Step 1: Create Remote Datasources

First, ensure all remote datasources exist in `lib/data/datasources/remote/`:

```
remote/
├── supabase_datasource.dart          # Base class
├── auth_remote_datasource.dart       # ✅ Exists
├── producto_remote_datasource.dart   # ✅ Exists
├── inventario_remote_datasource.dart # ✅ Exists
├── movimiento_remote_datasource.dart # ✅ Exists
├── tienda_remote_datasource.dart     # ❌ Create
├── almacen_remote_datasource.dart    # ❌ Create
├── proveedor_remote_datasource.dart  # ❌ Create
└── ... (create all missing)
```

### Step 2: Update SyncManager Constructor

```dart
SyncManager({
  required AppDatabase localDb,
  required SyncQueue syncQueue,
  required NetworkInfo networkInfo,
  required SharedPreferences prefs,
  required ProductoRemoteDatasource productoRemote,
  required InventarioRemoteDatasource inventarioRemote,
  required MovimientoRemoteDatasource movimientoRemote,
  required TiendaRemoteDatasource tiendaRemote,
  required AlmacenRemoteDatasource almacenRemote,
  required ProveedorRemoteDatasource proveedorRemote,
  // ... all others
  ConflictResolver? conflictResolver,
}) : _localDb = localDb,
     _syncQueue = syncQueue,
     _networkInfo = networkInfo,
     _prefs = prefs,
     _productoRemote = productoRemote,
     _inventarioRemote = inventarioRemote,
     // ... assign all
     _conflictResolver = conflictResolver ?? ConflictResolver();
```

### Step 3: Update Dependency Injection

In `injection_container.dart`:

```dart
// Register all remote datasources
getIt.registerLazySingleton<ProductoRemoteDatasource>(
  () => ProductoRemoteDatasource(),
);
getIt.registerLazySingleton<InventarioRemoteDatasource>(
  () => InventarioRemoteDatasource(),
);
// ... all others

// Update SyncManager registration
getIt.registerLazySingleton<SyncManager>(
  () => SyncManager(
    localDb: getIt<AppDatabase>(),
    syncQueue: getIt<SyncQueue>(),
    networkInfo: getIt<NetworkInfo>(),
    prefs: getIt<SharedPreferences>(),
    productoRemote: getIt<ProductoRemoteDatasource>(),
    inventarioRemote: getIt<InventarioRemoteDatasource>(),
    movimientoRemote: getIt<MovimientoRemoteDatasource>(),
    // ... all others
  ),
);
```

### Step 4: Implement Example Sync Method

```dart
Future<Either<Failure, void>> _syncProducto(SyncItem item) async {
  try {
    switch (item.operation) {
      case SyncOperation.create:
        final producto = ProductoModel.fromJson(item.data);
        await _productoRemote.createProducto(producto);
        break;
        
      case SyncOperation.update:
        final producto = ProductoModel.fromJson(item.data);
        await _productoRemote.updateProducto(producto);
        break;
        
      case SyncOperation.delete:
        await _productoRemote.deleteProducto(item.entityId);
        break;
    }
    
    return const Right(null);
  } on ConflictException catch (e) {
    return Left(ConflictFailure(
      message: e.message,
      conflict: e.conflict,
    ));
  } catch (e) {
    return Left(SyncFailure(message: e.toString()));
  }
}
```

### Step 5: Implement Pull Strategy

```dart
Future<void> _pullFromServer() async {
  final lastSync = await _getLastSyncTimestamp();
  
  // Pull all entity types
  await Future.wait([
    _pullProductos(lastSync),
    _pullInventarios(lastSync),
    _pullMovimientos(lastSync),
    _pullTiendas(lastSync),
    _pullAlmacenes(lastSync),
    // ... all others
  ]);
  
  await _updateLastSyncTimestamp(DateTime.now());
}
```

---

## ✅ Testing Checklist

After implementation, verify:

- [ ] Can sync productos create/update/delete
- [ ] Can pull changes from server
- [ ] Conflicts are detected and resolved
- [ ] Timestamp tracking works
- [ ] All 12 entity types can sync
- [ ] Batch syncing improves performance
- [ ] Offline queue persists across app restarts
- [ ] Network errors are handled gracefully
- [ ] Sync status updates correctly in UI

---

## 📚 Related Files

- `lib/core/sync/sync_queue.dart` - Queue management
- `lib/core/sync/sync_item.dart` - Item structure
- `lib/core/sync/conflict_resolver.dart` - Conflict resolution
- `lib/core/sync/sync_status.dart` - Status types
- `lib/presentation/blocs/sync/sync_bloc.dart` - UI integration

---

## 🎯 Summary

**Current State:** SyncManager skeleton with TODO implementations

**Target State:** Full bidirectional sync with:
- All entity types supported
- Incremental syncing
- Conflict resolution
- Batch operations
- Progress tracking

**Estimated Effort:** 3-5 days of development

**Benefits:**
- Robust offline-first capability
- Automatic conflict resolution
- Efficient bandwidth usage
- Scalable to all entity types
