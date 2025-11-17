# Naming Convention Guide

## Overview
This application uses different naming conventions for local vs remote data storage:
- **Local (Drift/SQLite)**: camelCase
- **Remote (Supabase/PostgreSQL)**: snake_case

## Data Flow & Conversion Points

### 1. Local → Remote (Create/Update)
**Path**: User Action → BLoC → Repository → Sync Manager → Remote DataSource → Supabase

**Conversion Point**: `SyncManager._convertToRemoteFormat()`
- Converts: `categoriaId` → `categoria_id`
- Location: `lib/core/sync/sync_manager.dart`

```dart
// In SyncManager
final remoteData = _convertToRemoteFormat(item.data);
await _productoRemote.createProducto(remoteData);
```

### 2. Remote → Local (Fetch/Sync)
**Path**: Supabase → Remote DataSource → Repository → Entity → BLoC → UI

**Conversion Point**: `Producto.fromRemoteJson()`
- Converts: `categoria_id` → `categoriaId`
- Location: `lib/domain/entities/producto.dart`

```dart
// In Repository
final remoteProductos = remoteProductosMaps
    .map((map) => Producto.fromRemoteJson(map)) // ← Uses fromRemoteJson
    .toList();
```

### 3. Local Storage (No Conversion)
**Path**: User Action → BLoC → Repository → DAO → Drift → SQLite

**No Conversion Needed**: Already camelCase
```dart
// Local operations use fromJson/toJson (camelCase)
final producto = Producto.fromJson(productoMap); // ← Local data
```

## Field Mapping Reference

| Local (camelCase) | Remote (snake_case) |
|-------------------|---------------------|
| `id` | `id` |
| `codigo` | `codigo` |
| `nombre` | `nombre` |
| `descripcion` | `descripcion` |
| `categoriaId` | `categoria_id` |
| `unidadMedidaId` | `unidad_medida_id` |
| `proveedorPrincipalId` | `proveedor_principal_id` |
| `precioCompra` | `precio_compra` |
| `precioVenta` | `precio_venta` |
| `margenUtilidad` | `margen_utilidad` |
| `pesoUnitarioKg` | `peso_unitario_kg` |
| `volumenUnitarioM3` | `volumen_unitario_m3` |
| `stockMinimo` | `stock_minimo` |
| `stockMaximo` | `stock_maximo` |
| `puntoReorden` | `punto_reorden` |
| `gradoCalidad` | `grado_calidad` |
| `normaTecnica` | `norma_tecnica` |
| `requiereAlmacenCubierto` | `requiere_almacen_cubierto` |
| `materialPeligroso` | `material_peligroso` |
| `imagenUrl` | `imagen_url` |
| `fichaTecnicaUrl` | `ficha_tecnica_url` |
| `activo` | `activo` |
| `observaciones` | `observaciones` |
| `createdAt` | `created_at` |
| `updatedAt` | `updated_at` |
| `deletedAt` | `deleted_at` |
| `syncId` | `sync_id` |
| `lastSync` | `last_sync` |

## Implementation Details

### Entity Methods (producto.dart)

#### For Local Storage (camelCase)
```dart
// Serialize TO local database
Map<String, dynamic> toJson() {
  return {
    'categoriaId': categoriaId,
    'precioCompra': precioCompra,
    // ... uses camelCase
  };
}

// Deserialize FROM local database
factory Producto.fromJson(Map<String, dynamic> json) {
  return Producto(
    categoriaId: json['categoriaId'],
    precioCompra: json['precioCompra'],
    // ... expects camelCase
  );
}
```

#### For Remote Storage (snake_case)
```dart
// Serialize TO Supabase
Map<String, dynamic> toRemoteJson() {
  return {
    'categoria_id': categoriaId,
    'precio_compra': precioCompra,
    // ... converts to snake_case
  };
}

// Deserialize FROM Supabase
factory Producto.fromRemoteJson(Map<String, dynamic> json) {
  return Producto(
    categoriaId: json['categoria_id'],
    precioCompra: json['precio_compra'],
    // ... expects snake_case
  );
}
```

### SyncManager Helper (sync_manager.dart)

```dart
/// Converts camelCase map to snake_case for Supabase
Map<String, dynamic> _convertToRemoteFormat(Map<String, dynamic> data) {
  return {
    'id': data['id'],
    'codigo': data['codigo'],
    'nombre': data['nombre'],
    'categoria_id': data['categoriaId'],
    'precio_compra': data['precioCompra'],
    // ... all 27 fields mapped
  };
}
```

### Repository Usage (producto_repository_impl.dart)

```dart
// When fetching FROM Supabase (snake_case → camelCase)
final remoteProductos = remoteProductosMaps
    .map((map) => Producto.fromRemoteJson(map)) // ← Remote conversion
    .toList();

// When reading FROM local database (already camelCase)
final producto = Producto.fromJson(productoMap); // ← No conversion
```

## Testing Checklist

- [ ] Create producto offline → Sync to Supabase with snake_case
- [ ] Fetch from Supabase → Parse snake_case correctly  
- [ ] Update producto locally → Sync updates with snake_case
- [ ] Delete producto locally → Sync soft delete to Supabase
- [ ] Verify all 27 fields map correctly in both directions
- [ ] Test offline → online → offline data integrity
- [ ] Check logs for proper field naming in remote operations

## Common Pitfalls

1. ❌ **Don't use `toJson()` for remote operations**
   ```dart
   // WRONG - sends camelCase to Supabase
   await remote.createProducto(producto.toJson());
   ```
   
   ✅ **Use `toRemoteJson()` instead**
   ```dart
   // CORRECT - sends snake_case to Supabase
   await remote.createProducto(producto.toRemoteJson());
   ```

2. ❌ **Don't use `fromJson()` for remote data**
   ```dart
   // WRONG - expects camelCase from Supabase
   final producto = Producto.fromJson(remoteMap);
   ```
   
   ✅ **Use `fromRemoteJson()` instead**
   ```dart
   // CORRECT - expects snake_case from Supabase
   final producto = Producto.fromRemoteJson(remoteMap);
   ```

3. ❌ **Don't manually convert field names**
   ```dart
   // WRONG - error-prone and hard to maintain
   final data = {
     'categoria_id': producto.categoriaId,
     // ... manual mapping
   };
   ```
   
   ✅ **Use the helper methods**
   ```dart
   // CORRECT - centralized and tested
   final data = _convertToRemoteFormat(item.data);
   ```

## Future Considerations

If you add new fields to the `Producto` entity:
1. Add to local schema (camelCase) in `lib/data/datasources/local/models/producto_table.dart`
2. Add to Supabase schema (snake_case) via migration
3. Update all 4 conversion methods:
   - `toJson()` (entity)
   - `fromJson()` (entity)
   - `toRemoteJson()` (entity)
   - `fromRemoteJson()` (entity)
   - `_convertToRemoteFormat()` (sync_manager)

## Summary

✅ **Local operations**: Use `toJson()` / `fromJson()` (camelCase)
✅ **Remote operations**: Use `toRemoteJson()` / `fromRemoteJson()` (snake_case)
✅ **Sync operations**: Use `_convertToRemoteFormat()` helper (camelCase → snake_case)

This dual approach ensures clean code that follows Dart conventions locally while respecting PostgreSQL/Supabase conventions remotely.
