# Almacen BLoC Usage Guide

## Understanding BLoC Pattern

**BLoC (Business Logic Component)** separates business logic from UI.

### Flow:
```
UI Widget → Dispatches EVENT → BLoC processes → Emits STATE → UI rebuilds
```

---

## Components

### 1. **Events** (What you want to do)
Events are user actions or system triggers that tell the BLoC what to do.

```dart
// Examples of events:
context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
context.read<AlmacenBloc>().add(LoadAlmacenById(id: '123'));
context.read<AlmacenBloc>().add(CreateAlmacen(almacen: newAlmacen));
```

### 2. **States** (What happened)
States represent the current status of your data/operation.

```dart
// States you'll see:
AlmacenInitial()         // Nothing loaded yet
AlmacenLoading()         // Currently fetching data
AlmacenLoaded()          // Data successfully loaded
AlmacenDetailLoaded()    // Single almacen loaded
AlmacenError()           // Something went wrong
AlmacenOperationSuccess() // Create/Update/Delete succeeded
AlmacenEmpty()           // No data found
```

### 3. **BLoC** (The processor)
Receives events, processes them using use cases, and emits states.

---

## Practical Usage Examples

### Example 1: Display List of Active Almacenes

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlmacenesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Step 1: Dispatch event when page loads
    context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());

    // Step 2: Listen to state changes
    return Scaffold(
      appBar: AppBar(title: const Text('Almacenes')),
      body: BlocBuilder<AlmacenBloc, AlmacenState>(
        builder: (context, state) {
          // Step 3: React to different states
          
          if (state is AlmacenLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlmacenError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is AlmacenEmpty) {
            return const Center(child: Text('No hay almacenes'));
          }

          if (state is AlmacenLoaded) {
            return ListView.builder(
              itemCount: state.almacenes.length,
              itemBuilder: (context, index) {
                final almacen = state.almacenes[index];
                return ListTile(
                  title: Text(almacen.nombre),
                  subtitle: Text(almacen.codigo),
                  onTap: () {
                    // Navigate to detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlmacenDetailPage(
                          almacenId: almacen.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateAlmacenPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Example 2: Create New Almacen

```dart
class CreateAlmacenPage extends StatefulWidget {
  @override
  _CreateAlmacenPageState createState() => _CreateAlmacenPageState();
}

class _CreateAlmacenPageState extends State<CreateAlmacenPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  String _selectedTipo = 'Principal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Almacén')),
      body: BlocConsumer<AlmacenBloc, AlmacenState>(
        // Listen for operation results
        listener: (context, state) {
          if (state is AlmacenOperationSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Go back to list
            Navigator.pop(context);
            // Reload list
            context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
          }

          if (state is AlmacenOperationFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // Build UI based on state
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(labelText: 'Código'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un código';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedTipo,
                    items: ['Principal', 'Obra', 'Transito']
                        .map((tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedTipo = value!);
                    },
                    decoration: const InputDecoration(labelText: 'Tipo'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is AlmacenCreating
                        ? null // Disable while creating
                        : () {
                            if (_formKey.currentState!.validate()) {
                              // Create almacen entity
                              final newAlmacen = Almacen(
                                id: const Uuid().v4(),
                                nombre: _nombreController.text,
                                codigo: _codigoController.text,
                                tipo: _selectedTipo,
                                tiendaId: 'your-tienda-id', // Get from auth
                                ubicacion: 'Default',
                                activo: true,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );

                              // Dispatch create event
                              context.read<AlmacenBloc>().add(
                                    CreateAlmacen(almacen: newAlmacen),
                                  );
                            }
                          },
                    child: state is AlmacenCreating
                        ? const CircularProgressIndicator()
                        : const Text('Crear Almacén'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Example 3: View Almacen Detail

```dart
class AlmacenDetailPage extends StatelessWidget {
  final String almacenId;

  const AlmacenDetailPage({required this.almacenId});

  @override
  Widget build(BuildContext context) {
    // Load almacen by ID
    context.read<AlmacenBloc>().add(LoadAlmacenById(id: almacenId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Almacén'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text('¿Está seguro de eliminar este almacén?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        // Dispatch delete event
                        context.read<AlmacenBloc>().add(
                              DeleteAlmacen(id: almacenId),
                            );
                      },
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AlmacenBloc, AlmacenState>(
        listener: (context, state) {
          if (state is AlmacenOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context); // Go back after delete
          }
        },
        builder: (context, state) {
          if (state is AlmacenLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlmacenError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is AlmacenDetailLoaded) {
            final almacen = state.almacen;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${almacen.nombre}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('Código: ${almacen.codigo}'),
                  Text('Tipo: ${almacen.tipo}'),
                  Text('Ubicación: ${almacen.ubicacion}'),
                  Text('Estado: ${almacen.activo ? "Activo" : "Inactivo"}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to edit
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditAlmacenPage(almacen: almacen),
                        ),
                      );
                    },
                    child: const Text('Editar'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
```

### Example 4: Search Almacenes

```dart
class SearchAlmacenesPage extends StatefulWidget {
  @override
  _SearchAlmacenesPageState createState() => _SearchAlmacenesPageState();
}

class _SearchAlmacenesPageState extends State<SearchAlmacenesPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Almacenes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, código o ubicación',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Dispatch search event
                    context.read<AlmacenBloc>().add(
                          SearchAlmacenes(query: _searchController.text),
                        );
                  },
                ),
              ),
              onSubmitted: (query) {
                context.read<AlmacenBloc>().add(SearchAlmacenes(query: query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<AlmacenBloc, AlmacenState>(
              builder: (context, state) {
                if (state is AlmacenLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AlmacenEmpty) {
                  return const Center(child: Text('No se encontraron resultados'));
                }

                if (state is AlmacenLoaded) {
                  return ListView.builder(
                    itemCount: state.almacenes.length,
                    itemBuilder: (context, index) {
                      final almacen = state.almacenes[index];
                      return ListTile(
                        title: Text(almacen.nombre),
                        subtitle: Text(almacen.codigo),
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Ingrese un término de búsqueda'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Key Concepts

### BlocBuilder vs BlocListener vs BlocConsumer

```dart
// BlocBuilder: Only rebuilds UI when state changes
BlocBuilder<AlmacenBloc, AlmacenState>(
  builder: (context, state) {
    // Return widgets based on state
  },
)

// BlocListener: Only executes side effects (navigation, snackbars)
BlocListener<AlmacenBloc, AlmacenState>(
  listener: (context, state) {
    // Show snackbar, navigate, etc.
  },
  child: ...,
)

// BlocConsumer: Both builder and listener
BlocConsumer<AlmacenBloc, AlmacenState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    // Build UI
  },
)
```

### Dispatching Events

```dart
// Using context.read (preferred in event handlers)
context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());

// Using BlocProvider
BlocProvider.of<AlmacenBloc>(context).add(const LoadAlmacenesActivos());
```

### Providing BLoC

```dart
// Single BLoC
BlocProvider(
  create: (context) => AlmacenBloc(...),
  child: AlmacenesListPage(),
)

// Multiple BLoCs
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => AlmacenBloc(...)),
    BlocProvider(create: (context) => ProductoBloc(...)),
  ],
  child: MyApp(),
)
```

---

## Complete Flow Example

1. **User taps "Load Almacenes" button**
   ```dart
   onPressed: () {
     context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
   }
   ```

2. **BLoC receives event**
   ```dart
   on<LoadAlmacenesActivos>(_onLoadAlmacenesActivos);
   ```

3. **BLoC handler executes**
   ```dart
   Future<void> _onLoadAlmacenesActivos(...) async {
     emit(const AlmacenLoading()); // UI shows loading
     final result = await getAlmacenesActivosUsecase();
     result.fold(
       (failure) => emit(AlmacenError(message: failure.message)),
       (almacenes) => emit(AlmacenLoaded(almacenes: almacenes)),
     );
   }
   ```

4. **UI rebuilds based on state**
   ```dart
   if (state is AlmacenLoading) return CircularProgressIndicator();
   if (state is AlmacenLoaded) return ListView(...);
   ```

---

## Common Patterns

### Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<AlmacenBloc>().add(const RefreshAlmacenes());
    // Wait for state to change
    await context.read<AlmacenBloc>().stream.firstWhere(
          (state) => state is! AlmacenLoading,
        );
  },
  child: ...,
)
```

### Reload After Operation
```dart
listener: (context, state) {
  if (state is AlmacenOperationSuccess) {
    // Reload list
    context.read<AlmacenBloc>().add(const LoadAlmacenesActivos());
  }
}
```

---

## Tips

1. **Always emit loading state first** when fetching data
2. **Use BlocConsumer** when you need both UI updates and side effects
3. **Keep events simple** - one action per event
4. **States should be immutable** - use Equatable
5. **Handle all possible states** in your UI
6. **Dispatch events, don't call repository directly** from UI
