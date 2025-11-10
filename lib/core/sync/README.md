# Sistema de Sincronización Offline-First

## Arquitectura

El sistema de sincronización está diseñado con los siguientes componentes:

### 1. SyncManager
Componente principal que coordina toda la sincronización.

**Responsabilidades:**
- Gestionar la cola de sincronización
- Ejecutar sincronizaciones periódicas
- Manejar cambios de conectividad
- Resolver conflictos
- Notificar cambios de estado

**Uso básico:**
```dart
final syncManager = SyncManager(
  localDb: database,
  syncQueue: queue,
  networkInfo: networkInfo,
);

// Sincronizar manualmente
await syncManager.syncAll();

// Escuchar cambios de estado
syncManager.syncStatusStream.listen((status) {
  print('Estado: ${status.state}');
});
```

### 2. SyncQueue
Cola persistente que almacena cambios pendientes de sincronización.

**Características:**
- Almacenamiento persistente en SharedPreferences
- Orden FIFO (First In, First Out)
- Manejo de reintentos
- Filtrado por tipo de entidad

**Uso:**
```dart
final queue = SyncQueue(sharedPreferences);

// Agregar item
await queue.enqueue(syncItem);

// Obtener siguiente
final next = queue.peek();

// Remover después de sincronizar
queue.dequeue();
```

### 3. ConflictResolver
Resuelve conflictos cuando datos locales y remotos divergen.

**Estrategias:**
- **useLocal**: Mantener cambios locales
- **useRemote**: Usar cambios del servidor
- **merge**: Fusionar ambos (cuando sea posible)
- **manual**: Requiere intervención del usuario

**Ejemplo:**
```dart
final conflict = SyncConflict(
  entityId: 'producto-123',
  entityType: SyncEntityType.producto,
  localData: {...},
  remoteData: {...},
  localTimestamp: DateTime.now(),
  remoteTimestamp: DateTime.now().subtract(Duration(hours: 1)),
);

final result = await conflictResolver.resolveConflict(
  conflict,
  ConflictResolution.merge,
);
```

### 4. SyncService
Servicio de alto nivel (Singleton) para acceso global.

**Uso:**
```dart
// Inicializar una vez
await SyncService.initialize(
  database: database,
  prefs: prefs,
  networkInfo: networkInfo,
);

// Usar en cualquier parte
final service = SyncService.instance;
await service.syncAll();
```

## Flujo de Sincronización

### Escritura (Local → Servidor)

1. **Usuario realiza cambio**
   - Ejemplo: Crear un producto

2. **Guardar localmente primero**
   ```dart
   await localDb.productoDao.insertProducto(producto);
   ```

3. **Agregar a cola de sincronización**
   ```dart
   await syncService.queueProductoChange(
     productoId: producto.id,
     operation: SyncOperation.create,
     data: producto.toJson(),
   );
   ```

4. **Sincronizar automáticamente (si hay conexión)**
   - El SyncManager detecta la conexión
   - Procesa la cola automáticamente
   - Envía cambios al servidor

5. **Manejo de errores**
   - Si falla: mantiene en cola con contador de reintentos
   - Si tiene muchos reintentos: marca como error
   - El usuario puede reintentar manualmente

### Lectura (Servidor → Local)

1. **Leer siempre de local primero**
   ```dart
   final productos = await localDb.productoDao.getAllProductos();
   ```

2. **Sincronizar en segundo plano (si hay conexión)**
   ```dart
   if (await networkInfo.isConnected) {
     _syncInBackground();
   }
   ```

3. **Actualizar local con cambios remotos**
   - Comparar timestamps
   - Detectar conflictos
   - Resolver automáticamente cuando sea posible

## Estrategias de Sincronización

### Aggressive
- Sincroniza cada 5 minutos
- Sincroniza al abrir la app
- Sincroniza al cambiar datos
- Máximo 5 reintentos
- **Uso:** Apps críticas que requieren datos en tiempo real

### Balanced (Recomendada)
- Sincroniza cada 15 minutos
- Sincroniza al abrir la app
- Sincroniza al detectar conexión
- Máximo 3 reintentos
- **Uso:** La mayoría de casos

### Conservative
- Sincroniza cada hora
- Solo al detectar conexión
- Mínimo uso de batería
- Máximo 2 reintentos
- **Uso:** Apps con datos poco cambiantes

### Manual
- Solo cuando el usuario lo solicita
- Sin sincronización automática
- **Uso:** Desarrollo o debugging

## Manejo de Conflictos

### Detección
Un conflicto ocurre cuando:
- Mismo registro modificado localmente y remotamente
- Timestamps diferentes
- Valores diferentes en campos importantes

### Resolución Automática
```dart
// Last Write Wins (más reciente gana)
final strategy = conflictResolver.getAutoStrategy(conflict);

// Aplicar estrategia
final resolved = await conflictResolver.resolveConflict(
  conflict,
  strategy,
);
```

### Resolución Manual
Para conflictos complejos, mostrar diálogo al usuario:
```dart
showDialog(
  context: context,
  builder: (context) => ConflictResolutionDialog(
    conflict: conflict,
    onResolve: (resolution) async {
      await conflictResolver.resolveConflict(conflict, resolution);
    },
  ),
);
```

## Monitoreo y Logs

### Estados de Sincronización
```dart
syncManager.syncStatusStream.listen((status) {
  switch (status.state) {
    case SyncState.idle:
      // Esperando
      break;
    case SyncState.syncing:
      // Sincronizando ${status.pendingItems} items
      break;
    case SyncState.success:
      // Completado
      break;
    case SyncState.error:
      // Error: ${status.message}
      break;
    case SyncState.conflict:
      // ${status.conflictItems} conflictos
      break;
  }
});
```

### Logs Detallados
```dart
final logger = SyncLogger();
logger.logSyncStart(items.length);
logger.logSyncSuccess(itemId, entityType);
logger.logConflict(itemId, entityType);
```

## Testing

### Unit Tests
```dart
test('debe agregar item a la cola', () async {
  final queue = SyncQueue(mockPrefs);
  await queue.enqueue(testItem);
  
  expect(queue.length, 1);
  expect(queue.peek(), testItem);
});
```

### Integration Tests
```dart
testWidgets('debe sincronizar cambios locales', (tester) async {
  // Simular cambio local
  await repository.createProducto(testProducto);
  
  // Verificar que está en cola
  expect(syncQueue.length, 1);
  
  // Sincronizar
  await syncManager.syncAll();
  
  // Verificar que se envió al servidor
  verify(mockRemoteDataSource.createProducto(any)).called(1);
});
```

## Best Practices

1. **Siempre leer de local primero**
   - Garantiza que la app funcione offline
   - Mejora la velocidad de respuesta

2. **Sincronizar en segundo plano**
   - No bloquear la UI
   - Mostrar indicador de progreso

3. **Manejar errores gracefully**
   - Informar al usuario
   - Permitir reintento manual
   - No perder datos

4. **Optimizar cantidad de sincronizaciones**
   - No sincronizar demasiado frecuente
   - Agrupar cambios cuando sea posible
   - Usar estrategia balanceada

5. **Testear escenarios offline**
   - App sin conexión inicial
   - Pérdida de conexión durante operación
   - Conflictos de sincronización

## Troubleshooting

### Items no se sincronizan
- Verificar conectividad: `networkInfo.isConnected`
- Revisar cola: `syncQueue.getAll()`
- Verificar errores: `syncQueue.getErrors()`

### Conflictos frecuentes
- Revisar timestamps
- Ajustar estrategia de resolución
- Considerar campos que pueden ser mergeados

### Sincronización lenta
- Reducir frecuencia (cambiar estrategia)
- Implementar sincronización incremental
- Optimizar queries del servidor
