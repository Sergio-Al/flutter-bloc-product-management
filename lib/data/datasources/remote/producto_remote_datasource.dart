import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_datasource.dart';
import '../../../core/errors/exceptions.dart' as app_exceptions;
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de productos con Supabase
class ProductoRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'productos';

  /// Obtiene todos los productos
  ///
  /// [lastSync] - Fecha de última sincronización (opcional)
  /// [limit] - Límite de resultados
  /// [offset] - Offset para paginación
  Future<List<Map<String, dynamic>>> getProductos({
    DateTime? lastSync,
    int? limit,
    int? offset,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo productos');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            categoria:categorias(*),
            unidad_medida:unidades_medida(*),
            proveedor_principal:proveedores(*)
          ''');

      query = SupabaseDataSource.applySyncFilters(query, lastSync);
      query = SupabaseDataSource.applyActiveFilter(query);
      query = SupabaseDataSource.applyPagination(query, limit: limit, offset: offset);
      query = SupabaseDataSource.applyOrdering(query, column: 'nombre', ascending: true);

      final response = await query;

      AppLogger.database('✅ ${response.length} productos obtenidos');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene un producto por ID
  Future<Map<String, dynamic>> getProductoById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo producto: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            categoria:categorias(*),
            unidad_medida:unidades_medida(*),
            proveedor_principal:proveedores(*)
          ''')
          .eq('id', id)
          .single();

      AppLogger.database('✅ Producto obtenido: ${response['nombre']}');
      return response;
    });
  }

  /// Busca productos por término de búsqueda
  Future<List<Map<String, dynamic>>> searchProductos({
    required String searchTerm,
    int? limit,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Buscando productos: $searchTerm');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            categoria:categorias(*),
            unidad_medida:unidades_medida(*)
          ''')
          .or('nombre.ilike.%$searchTerm%,codigo.ilike.%$searchTerm%,descripcion.ilike.%$searchTerm%');

      query = SupabaseDataSource.applyActiveFilter(query);
      
      if (limit != null) {
        query = query.limit(limit) as PostgrestFilterBuilder<PostgrestList>;
      }

      final response = await query;

      AppLogger.database('✅ ${response.length} productos encontrados');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Crea un nuevo producto
  Future<Map<String, dynamic>> createProducto(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando producto: ${data['nombre']}');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      AppLogger.database('✅ Producto creado: ${response['id']}');
      return response;
    });
  }

  /// Actualiza un producto existente
  Future<Map<String, dynamic>> updateProducto({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando producto: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Producto actualizado: ${response['nombre']}');
      return response;
    });
  }

  /// Elimina un producto (soft delete)
  Future<void> deleteProducto(String id) async {
    await SupabaseDataSource.softDelete(_tableName, id);
    AppLogger.database('✅ Producto eliminado: $id');
  }

  /// Elimina permanentemente un producto
  Future<void> hardDeleteProducto(String id) async {
    await SupabaseDataSource.hardDelete(_tableName, id);
    AppLogger.database('✅ Producto eliminado permanentemente: $id');
  }

  /// Restaura un producto eliminado
  Future<void> restoreProducto(String id) async {
    await SupabaseDataSource.restore(_tableName, id);
    AppLogger.database('✅ Producto restaurado: $id');
  }

  /// Obtiene productos por categoría
  Future<List<Map<String, dynamic>>> getProductosByCategoria(
    String categoriaId,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo productos por categoría: $categoriaId');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('categoria_id', categoriaId)
          .order('nombre');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene productos por proveedor
  Future<List<Map<String, dynamic>>> getProductosByProveedor(
    String proveedorId,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo productos por proveedor: $proveedorId');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('proveedor_principal_id', proveedorId)
          .order('nombre');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene productos con stock bajo
  Future<List<Map<String, dynamic>>> getProductosStockBajo() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo productos con stock bajo');

      // Esta query necesita join con inventarios
      final response = await SupabaseDataSource.client
          .rpc('get_productos_stock_bajo');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Actualiza precios de productos de un proveedor
  Future<void> updatePreciosByProveedor({
    required String proveedorId,
    required double porcentajeIncremento,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database(
        'Actualizando precios del proveedor $proveedorId en $porcentajeIncremento%',
      );

      await SupabaseDataSource.client.rpc('update_precios_by_proveedor', params: {
        'proveedor_id': proveedorId,
        'porcentaje': porcentajeIncremento,
      });

      AppLogger.database('✅ Precios actualizados');
    });
  }

  /// Marca un producto como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client.from(_tableName).update({
        'last_sync': syncTime.toIso8601String(),
      }).eq('id', id);

      AppLogger.sync('Producto marcado como sincronizado: $id');
    });
  }

  /// Obtiene productos modificados desde una fecha
  Future<List<Map<String, dynamic>>> getProductosModificados(
    DateTime since,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('Obteniendo productos modificados desde: $since');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .gt('updated_at', since.toIso8601String())
          .order('updated_at');

      AppLogger.sync('✅ ${response.length} productos modificados');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Sube una imagen para un producto
  Future<String> uploadProductoImage({
    required String productoId,
    required String filePath,
  }) async {
    final path = 'productos/$productoId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    return await SupabaseDataSource.uploadImage(
      bucket: 'productos-images',
      path: path,
      file: filePath as dynamic,
    );
  }

  /// Elimina la imagen de un producto
  Future<void> deleteProductoImage(String imageUrl) async {
    // Extraer el path de la URL
    final uri = Uri.parse(imageUrl);
    final path = uri.pathSegments.sublist(4).join('/');

    await SupabaseDataSource.deleteImage(
      bucket: 'productos-images',
      path: path,
    );
  }

  /// Obtiene estadísticas de productos
  Future<Map<String, dynamic>> getEstadisticas() async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo estadísticas de productos');

      final response = await SupabaseDataSource.client
          .rpc('get_productos_estadisticas');

      return response;
    });
  }
}
