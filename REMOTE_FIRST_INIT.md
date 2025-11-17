# Remote-First Initialization Strategy

## Overview
The application now uses a **remote-first** approach for initializing default data (categorías and unidades de medida). This ensures consistency across devices and reduces data duplication.

## How It Works

### Initialization Flow
```
App Start
    ↓
ensureDefaultsExist()
    ↓
Try: _syncDefaultsFromRemote()
    ↓
├─ Success: Load categorías & unidades from Supabase ✅
│   └─ Insert/Update local database
│
└─ Failure: Network error / Supabase unavailable ⚠️
    └─ Fallback: _seedInitialData() (local seeds)
```

### Key Benefits

1. **✅ Single Source of Truth**: Supabase is the master database
2. **✅ Consistent Data**: All devices get same defaults
3. **✅ Easy Updates**: Change defaults in Supabase, propagates to all devices
4. **✅ Offline Resilience**: Falls back to local seeds if remote unavailable
5. **✅ No Hardcoded IDs**: Uses actual IDs from Supabase

## Implementation Details

### Remote Datasources Created

#### `categoria_remote_datasource.dart`
```dart
- getCategoriasActivas()  // All active categories
- getCategoriaById(id)     // Single category
- createCategoria(data)    // Create new
- updateCategoria(id, data) // Update existing
- deleteCategoria(id)      // Soft delete
```

#### `unidad_medida_remote_datasource.dart`
```dart
- getUnidadesActivas()     // All active units
- getUnidadById(id)        // Single unit
- getUnidadesByTipo(tipo)  // Filter by type
- createUnidad(data)       // Create new
- updateUnidad(id, data)   // Update existing
- deleteUnidad(id)         // Soft delete
```

### Database Initialization (app_database.dart)

#### New Method: `_syncDefaultsFromRemote()`
Fetches defaults from Supabase and syncs to local database:

```dart
Future<void> _syncDefaultsFromRemote() async {
  final categoriaRemote = CategoriaRemoteDataSource();
  final unidadRemote = UnidadMedidaRemoteDataSource();

  // 1. Fetch categorías from Supabase
  final remoteCategorias = await categoriaRemote.getCategoriasActivas();
  
  // 2. Insert/update local database
  for (final categoriaMap in remoteCategorias) {
    await into(categorias).insertOnConflictUpdate(
      CategoriasCompanion.insert(
        id: categoriaMap['id'],
        nombre: categoriaMap['nombre'],
        // ... maps snake_case → camelCase
      ),
    );
  }
  
  // 3. Ensure critical defaults exist (fallback)
  if (!remoteCategorias.any((cat) => cat['codigo'] == 'GEN')) {
    // Insert local "Sin Categoría" if not in remote
  }
  
  // Same process for unidades...
}
```

#### Updated Method: `ensureDefaultsExist()`
Try-catch wrapper with fallback:

```dart
Future<void> ensureDefaultsExist() async {
  try {
    // Try remote first
    await _syncDefaultsFromRemote();
    AppLogger.database('✅ Defaults synced from remote');
  } catch (e) {
    // Fallback to local seeds
    AppLogger.warning('⚠️ Using local seeds: $e');
    await _seedInitialData();
  }
}
```

## Field Mapping (snake_case → camelCase)

### Categorías
| Supabase (snake_case) | Local (camelCase) |
|----------------------|-------------------|
| `id` | `id` |
| `nombre` | `nombre` |
| `codigo` | `codigo` |
| `descripcion` | `descripcion` |
| `requiere_lote` | `requiereLote` |
| `requiere_certificacion` | `requiereCertificacion` |
| `activo` | `activo` |

### Unidades de Medida
| Supabase (snake_case) | Local (camelCase) |
|----------------------|-------------------|
| `id` | `id` |
| `nombre` | `nombre` |
| `abreviatura` | `abreviatura` |
| `tipo` | `tipo` |
| `factor_conversion` | `factorConversion` |

## Usage

### On App Initialization
Called automatically in `injection_container.dart`:

```dart
// Initialize database first
final db = AppDatabase();

// Sync defaults from remote (or use local seeds)
await db.ensureDefaultsExist();

// Register as singleton
getIt.registerSingleton<AppDatabase>(db);
```

### Manual Refresh
You can manually refresh defaults at any time:

```dart
final db = getIt<AppDatabase>();
await db.ensureDefaultsExist();
```

## Managing Defaults in Supabase

### Adding New Categories
Use Supabase Dashboard or SQL:

```sql
INSERT INTO categorias (id, nombre, codigo, descripcion, requiere_lote, activo)
VALUES (
  'cat-tuberia',
  'Tubería',
  'TUB',
  'Tubos y accesorios de PVC y metal',
  false,
  true
);
```

Next time the app syncs, this category will be available locally.

### Adding New Units
```sql
INSERT INTO unidades_medida (id, nombre, abreviatura, tipo, factor_conversion, activo)
VALUES (
  'unidad-rollo',
  'Rollo',
  'RLL',
  'Unidad',
  1.0,
  true
);
```

### Updating Existing Data
Just update in Supabase, then call `ensureDefaultsExist()`:

```sql
UPDATE categorias 
SET descripcion = 'Updated description'
WHERE codigo = 'CEM';
```

## Fallback Seeds

If Supabase is unavailable, the app uses these local seeds:

### Roles
- Administrador
- Gerente
- Almacenero
- Vendedor

### Categorías
- Sin Categoría (default)
- Cemento
- Fierro y Acero
- Madera
- Agregados
- Pintura
- Calaminas
- Material Eléctrico
- Plomería
- Herramientas

### Unidades de Medida
- Unidad (default)
- Bolsa
- Metro
- Kilogramo
- Litro
- Plancha
- Pieza
- Metro Cuadrado
- Galón

## Testing

### Test Remote Sync
1. Ensure you have internet connection
2. Add data to Supabase
3. Delete local database (or use fresh install)
4. Launch app
5. Check logs: Should see "✅ Defaults synced from remote"

### Test Offline Fallback
1. Turn off internet / disconnect from Supabase
2. Delete local database
3. Launch app
4. Check logs: Should see "⚠️ Using local seeds"

### Verify Data
```dart
// Get synced categories
final db = getIt<AppDatabase>();
final categorias = await db.categoriaDao.getCategorias();
print('Categories: ${categorias.length}');

// Get synced units
final unidades = await db.select(db.unidadesMedida).get();
print('Units: ${unidades.length}');
```

## Troubleshooting

### "Could not fetch from remote"
- Check internet connection
- Verify Supabase credentials
- Check if tables exist: `categorias`, `unidades_medida`
- Verify RLS policies allow read access

### "Defaults synced but data missing"
- Check if data is marked `activo = true` in Supabase
- Verify field names match (snake_case in Supabase)
- Check logs for parsing errors

### "Foreign key constraint failed"
- Ensure default category/unit exists
- Check IDs match between Supabase and local
- Run `ensureDefaultsExist()` again

## Best Practices

1. **Always use `ensureDefaultsExist()`** during app initialization
2. **Don't hardcode default IDs** in forms - fetch from database
3. **Add new defaults in Supabase** for consistency across devices
4. **Keep local seeds updated** as fallback for offline scenarios
5. **Test both online and offline** initialization flows

## Summary

✅ **Remote-first**: Fetch from Supabase when online
✅ **Offline resilient**: Fall back to local seeds
✅ **Consistent data**: Single source of truth
✅ **Easy management**: Update defaults in Supabase dashboard
✅ **No hardcoded IDs**: Uses actual database IDs

This approach provides the best of both worlds: centralized management with offline resilience.
