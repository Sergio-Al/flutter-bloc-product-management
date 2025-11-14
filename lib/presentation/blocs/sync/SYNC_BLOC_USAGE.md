# SyncBloc - Guía de Uso

## 📦 Descripción

El `SyncBloc` gestiona el estado de sincronización entre la base de datos local (SQLite/Drift) y el servidor remoto (Supabase). Escucha automáticamente los cambios del `SyncManager` y actualiza la UI en consecuencia.

## 🏗️ Arquitectura

```
SyncManager (core/sync/)
    ↓ emite SyncStatus
SyncBloc (presentation/blocs/sync/)
    ↓ convierte a SyncBlocState
UI (Widgets)
    ↓ escucha con BlocBuilder/BlocListener
```

## 📋 Estados Disponibles

### `SyncIdle`
Estado inicial, sin sincronización activa.

```dart
if (state is SyncIdle) {
  // Mostrar botón "Sincronizar"
}
```

### `SyncInProgress`
Sincronización en progreso.

```dart
if (state is SyncInProgress) {
  final pending = state.pendingItems;
  final progress = state.progress;
  // Mostrar barra de progreso
}
```

### `SyncCompleted`
Sincronización completada exitosamente.

```dart
if (state is SyncCompleted) {
  final lastSync = state.lastSync;
  // Mostrar mensaje de éxito
}
```

### `SyncFailed`
Sincronización falló con error.

```dart
if (state is SyncFailed) {
  final errorMessage = state.message;
  // Mostrar mensaje de error
}
```

### `SyncConflictDetected`
Se detectaron conflictos durante la sincronización.

```dart
if (state is SyncConflictDetected) {
  final conflicts = state.conflictCount;
  // Mostrar diálogo de resolución de conflictos
}
```

## 🚀 Uso Básico

### 1. Proveer el BLoC

```dart
// En main.dart o app.dart
BlocProvider(
  create: (context) => SyncBloc(
    syncManager: getIt<SyncManager>(),
  ),
  child: MyApp(),
)
```

### 2. Sincronizar Manualmente

```dart
// En un widget
ElevatedButton(
  onPressed: () {
    context.read<SyncBloc>().add(const SyncStarted());
  },
  child: const Text('Sincronizar'),
)
```

### 3. Mostrar Estado de Sincronización

```dart
BlocBuilder<SyncBloc, SyncBlocState>(
  builder: (context, state) {
    if (state is SyncIdle) {
      return const Text('Sin sincronización');
    } else if (state is SyncInProgress) {
      return Column(
        children: [
          const CircularProgressIndicator(),
          Text('Sincronizando ${state.pendingItems} elementos...'),
          LinearProgressIndicator(value: state.progress),
        ],
      );
    } else if (state is SyncCompleted) {
      return Text('Última sincronización: ${state.lastSync}');
    } else if (state is SyncFailed) {
      return Text('Error: ${state.message}', style: TextStyle(color: Colors.red));
    } else if (state is SyncConflictDetected) {
      return Text('${state.conflictCount} conflictos detectados');
    }
    return const SizedBox.shrink();
  },
)
```

### 4. Reaccionar a Cambios

```dart
BlocListener<SyncBloc, SyncBlocState>(
  listener: (context, state) {
    if (state is SyncCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sincronización completada'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (state is SyncFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (state is SyncConflictDetected) {
      // Mostrar diálogo para resolver conflictos
      _showConflictDialog(context, state.conflictCount);
    }
  },
  child: YourWidget(),
)
```

## 🎨 Widgets de Ejemplo

### Indicador de Sincronización en AppBar

```dart
class SyncIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncBlocState>(
      builder: (context, state) {
        if (state is SyncInProgress) {
          return IconButton(
            icon: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            onPressed: null,
          );
        } else if (state is SyncFailed) {
          return IconButton(
            icon: const Icon(Icons.sync_problem, color: Colors.red),
            onPressed: () => context.read<SyncBloc>().add(const SyncStarted()),
          );
        } else if (state is SyncConflictDetected) {
          return IconButton(
            icon: Badge(
              label: Text('${state.conflictCount}'),
              child: const Icon(Icons.warning, color: Colors.orange),
            ),
            onPressed: () {
              // Navegar a página de resolución de conflictos
              Navigator.pushNamed(context, '/sync-conflicts');
            },
          );
        }
        return IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () => context.read<SyncBloc>().add(const SyncStarted()),
        );
      },
    );
  }
}
```

### Botón de Sincronización con Estado

```dart
class SyncButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncBloc, SyncBlocState>(
      listener: (context, state) {
        if (state is SyncCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sincronización completada')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is SyncInProgress;
        
        return ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () => context.read<SyncBloc>().add(const SyncStarted()),
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync),
          label: Text(isLoading ? 'Sincronizando...' : 'Sincronizar'),
        );
      },
    );
  }
}
```

### Widget de Estado Detallado

```dart
class DetailedSyncStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncBloc, SyncBlocState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estado de Sincronización',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildStatusRow(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(SyncBlocState state) {
    if (state is SyncIdle) {
      return const ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text('Todo sincronizado'),
      );
    } else if (state is SyncInProgress) {
      return Column(
        children: [
          ListTile(
            leading: const CircularProgressIndicator(),
            title: Text('Sincronizando ${state.pendingItems} elementos'),
          ),
          LinearProgressIndicator(value: state.progress),
        ],
      );
    } else if (state is SyncCompleted) {
      return ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: const Text('Sincronización completada'),
        subtitle: Text(
          'Última sincronización: ${_formatDate(state.lastSync)}',
        ),
      );
    } else if (state is SyncFailed) {
      return ListTile(
        leading: const Icon(Icons.error, color: Colors.red),
        title: const Text('Error de sincronización'),
        subtitle: Text(state.message),
      );
    } else if (state is SyncConflictDetected) {
      return ListTile(
        leading: const Icon(Icons.warning, color: Colors.orange),
        title: Text('${state.conflictCount} conflictos detectados'),
        subtitle: const Text('Requiere intervención manual'),
        trailing: ElevatedButton(
          onPressed: () {
            // Navegar a resolución de conflictos
          },
          child: const Text('Resolver'),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Hace un momento';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} minutos';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} horas';
    return 'Hace ${diff.inDays} días';
  }
}
```

## 🔧 Integración con Inyección de Dependencias

### Registrar en GetIt

```dart
// En injection_container.dart

// ============================================================================
// Core - Sync
// ============================================================================

getIt.registerLazySingleton<SyncQueue>(
  () => SyncQueue(getIt<SharedPreferences>()),
);

getIt.registerLazySingleton<ConflictResolver>(
  () => ConflictResolver(),
);

getIt.registerLazySingleton<SyncManager>(
  () => SyncManager(
    localDb: getIt<AppDatabase>(),
    syncQueue: getIt<SyncQueue>(),
    networkInfo: getIt<NetworkInfo>(),
    conflictResolver: getIt<ConflictResolver>(),
  ),
);

// ============================================================================
// BLoCs - Sync
// ============================================================================

getIt.registerFactory<SyncBloc>(
  () => SyncBloc(syncManager: getIt<SyncManager>()),
);
```

## 📱 Uso en Páginas

### Página con Sincronización Automática

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SyncBloc>()..add(const SyncStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
          actions: [
            SyncIndicator(), // Widget personalizado
          ],
        ),
        body: BlocListener<SyncBloc, SyncBlocState>(
          listener: (context, state) {
            // Reaccionar a cambios de estado
          },
          child: YourContent(),
        ),
      ),
    );
  }
}
```

## ⚠️ Consideraciones Importantes

1. **Sincronización Automática**: El `SyncManager` ya sincroniza automáticamente cada 15 minutos y cuando detecta conectividad. El `SyncStarted` event es para sincronización manual.

2. **Manejo de Conflictos**: Los conflictos requieren intervención manual. Implementa una página dedicada para resolverlos.

3. **Performance**: No invoques `SyncStarted` muy frecuentemente. Confía en la sincronización automática para operaciones regulares.

4. **Estado Global**: Usa `MultiBlocProvider` si necesitas acceder al `SyncBloc` en múltiples partes de la app.

5. **Testing**: Mock el `SyncManager` para testear el `SyncBloc` sin dependencias reales.

## 🧪 Testing

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late MockSyncManager mockSyncManager;
  late SyncBloc syncBloc;

  setUp(() {
    mockSyncManager = MockSyncManager();
    syncBloc = SyncBloc(syncManager: mockSyncManager);
  });

  tearDown(() {
    syncBloc.close();
  });

  blocTest<SyncBloc, SyncBlocState>(
    'emits SyncInProgress when SyncStarted is added',
    build: () {
      when(mockSyncManager.syncAll()).thenAnswer(
        (_) async => const Right(null),
      );
      when(mockSyncManager.syncStatusStream).thenAnswer(
        (_) => Stream.value(SyncStatus.syncing(pendingItems: 5)),
      );
      return syncBloc;
    },
    act: (bloc) => bloc.add(const SyncStarted()),
    expect: () => [isA<SyncInProgress>()],
  );
}
```

## 📚 Recursos Adicionales

- **SyncManager README**: `lib/core/sync/README.md`
- **Clean Architecture Guide**: Documentación del proyecto
- **BLoC Pattern**: https://bloclibrary.dev/

---

✅ **Estado**: Implementación completa y lista para usar
🔄 **Versión**: 1.0
📅 **Última actualización**: Noviembre 2025
