import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_datasource.dart';
import '../../../core/utils/logger.dart';

/// Datasource remoto para operaciones de movimientos con Supabase
///
/// ⚠️ IMPORTANTE: NO incluye método de eliminación (delete)
/// Los movimientos son registros de auditoría permanentes que no deben eliminarse.
/// Usar cancelarMovimiento() para marcar como CANCELADO en su lugar.
class MovimientoRemoteDataSource extends SupabaseDataSource {
  static const String _tableName = 'movimientos';

  /// Obtiene todos los movimientos
  Future<List<Map<String, dynamic>>> getMovimientos({
    DateTime? lastSync,
    String? tiendaId,
    String? tipo,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
    int? limit,
    int? offset,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo movimientos');

      PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
          SupabaseDataSource.client.from(_tableName).select('''
                *,
                producto:productos(*),
                inventario:inventarios(*),
                lote:lotes(*),
                tienda_origen:tiendas!movimientos_tienda_origen_id_fkey(*),
                tienda_destino:tiendas!movimientos_tienda_destino_id_fkey(*),
                proveedor:proveedores(*),
                usuario:usuarios(*)
              ''');

      if (lastSync != null) {
        query = SupabaseDataSource.applySyncFilters(query, lastSync);
      }

      if (tiendaId != null) {
        query = query.or(
          'tienda_origen_id.eq.$tiendaId,tienda_destino_id.eq.$tiendaId',
        );
      }

      if (tipo != null) {
        query = query.eq('tipo', tipo);
      }

      if (fechaDesde != null) {
        query = query.gte('fecha_movimiento', fechaDesde.toIso8601String());
      }

      if (fechaHasta != null) {
        query = query.lte('fecha_movimiento', fechaHasta.toIso8601String());
      }

      var transformedQuery = SupabaseDataSource.applyPagination(
        query,
        limit: limit,
        offset: offset,
      );
      transformedQuery = SupabaseDataSource.applyOrdering(
        transformedQuery,
        column: 'fecha_movimiento',
        ascending: false,
      );

      final response = await transformedQuery;

      AppLogger.database('✅ ${response.length} movimientos obtenidos');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene un movimiento por ID
  Future<Map<String, dynamic>> getMovimientoById(String id) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo movimiento: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('''
            *,
            producto:productos(*),
            tienda_origen:tiendas!movimientos_tienda_origen_id_fkey(*),
            tienda_destino:tiendas!movimientos_tienda_destino_id_fkey(*),
            proveedor:proveedores(*),
            usuario:usuarios(*)
          ''')
          .eq('id', id)
          .single();

      AppLogger.database('✅ Movimiento obtenido');
      return response;
    });
  }

  /// Crea un nuevo movimiento
  Future<Map<String, dynamic>> createMovimiento(
    Map<String, dynamic> data,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      try {
        AppLogger.database('Creando movimiento tipo: ${data['tipo']}');

        final response = await SupabaseDataSource.client
            .from(_tableName)
            .insert(data)
            .select()
            .single();

        AppLogger.database(
          '✅ Movimiento creado: ${response['numero_movimiento']}',
        );
        return response;
      } catch (e) {
        AppLogger.database('❌ Error creando movimiento: $e');
        rethrow;
      }
    });
  }

  /// Actualiza un movimiento
  Future<Map<String, dynamic>> updateMovimiento({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Actualizando movimiento: $id');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Movimiento actualizado');
      return response;
    });
  }

  /// Cambia el estado de un movimiento
  Future<Map<String, dynamic>> cambiarEstado({
    required String id,
    required String nuevoEstado,
    String? observaciones,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Cambiando estado del movimiento $id a $nuevoEstado');

      final data = <String, dynamic>{
        'estado': nuevoEstado,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (observaciones != null) {
        data['observaciones'] = observaciones;
      }

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      AppLogger.database('✅ Estado del movimiento actualizado');
      return response;
    });
  }

  /// Completa un movimiento (cambia estado a COMPLETADO)
  Future<Map<String, dynamic>> completarMovimiento(String id) async {
    return cambiarEstado(id: id, nuevoEstado: 'COMPLETADO');
  }

  /// Cancela un movimiento
  Future<Map<String, dynamic>> cancelarMovimiento({
    required String id,
    required String motivo,
  }) async {
    return cambiarEstado(
      id: id,
      nuevoEstado: 'CANCELADO',
      observaciones: 'Cancelado: $motivo',
    );
  }

  /// Crea una compra (movimiento tipo COMPRA)
  Future<Map<String, dynamic>> createCompra({
    required String productoId,
    required String almacenId,
    required String proveedorId,
    required int cantidad,
    required double costoUnitario,
    String? numeroFactura,
    String? loteId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando compra de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_compra',
        params: {
          'p_producto_id': productoId,
          'p_almacen_id': almacenId,
          'p_proveedor_id': proveedorId,
          'p_cantidad': cantidad,
          'p_costo_unitario': costoUnitario,
          if (numeroFactura != null) 'p_numero_factura': numeroFactura,
          if (loteId != null) 'p_lote_id': loteId,
        },
      );

      AppLogger.database('✅ Compra creada');
      return response;
    });
  }

  /// Crea una venta (movimiento tipo VENTA)
  Future<Map<String, dynamic>> createVenta({
    required String productoId,
    required String almacenId,
    required int cantidad,
    required double precioUnitario,
    String? numeroFactura,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando venta de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_venta',
        params: {
          'p_producto_id': productoId,
          'p_almacen_id': almacenId,
          'p_cantidad': cantidad,
          'p_precio_unitario': precioUnitario,
          if (numeroFactura != null) 'p_numero_factura': numeroFactura,
        },
      );

      AppLogger.database('✅ Venta creada');
      return response;
    });
  }

  /// Crea una transferencia entre almacenes/tiendas
  Future<Map<String, dynamic>> createTransferencia({
    required String productoId,
    required String almacenOrigenId,
    required String almacenDestinoId,
    required int cantidad,
    String? numeroGuiaRemision,
    String? vehiculoPlaca,
    String? conductor,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando transferencia de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_transferencia',
        params: {
          'p_producto_id': productoId,
          'p_almacen_origen_id': almacenOrigenId,
          'p_almacen_destino_id': almacenDestinoId,
          'p_cantidad': cantidad,
          if (numeroGuiaRemision != null) 'p_numero_guia': numeroGuiaRemision,
          if (vehiculoPlaca != null) 'p_vehiculo': vehiculoPlaca,
          if (conductor != null) 'p_conductor': conductor,
        },
      );

      AppLogger.database('✅ Transferencia creada');
      return response;
    });
  }

  /// Crea un ajuste de inventario (movimiento tipo AJUSTE)
  Future<Map<String, dynamic>> createAjuste({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? observaciones,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando ajuste de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_ajuste',
        params: {
          'p_producto_id': productoId,
          'p_tienda_id': tiendaId,
          'p_cantidad': cantidad,
          'p_motivo': motivo,
          if (observaciones != null) 'p_observaciones': observaciones,
        },
      );

      AppLogger.database('✅ Ajuste creado');
      return response;
    });
  }

  /// Crea una devolución (movimiento tipo DEVOLUCION)
  Future<Map<String, dynamic>> createDevolucion({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? numeroFactura,
    String? observaciones,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando devolución de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_devolucion',
        params: {
          'p_producto_id': productoId,
          'p_tienda_id': tiendaId,
          'p_cantidad': cantidad,
          'p_motivo': motivo,
          if (numeroFactura != null) 'p_numero_factura': numeroFactura,
          if (observaciones != null) 'p_observaciones': observaciones,
        },
      );

      AppLogger.database('✅ Devolución creada');
      return response;
    });
  }

  /// Crea una merma/pérdida (movimiento tipo MERMA)
  Future<Map<String, dynamic>> createMerma({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String motivo,
    String? observaciones,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Creando merma de producto: $productoId');

      final response = await SupabaseDataSource.client.rpc(
        'create_merma',
        params: {
          'p_producto_id': productoId,
          'p_tienda_id': tiendaId,
          'p_cantidad': cantidad,
          'p_motivo': motivo,
          if (observaciones != null) 'p_observaciones': observaciones,
        },
      );

      AppLogger.database('✅ Merma creada');
      return response;
    });
  }

  /// Obtiene movimientos por tipo
  Future<List<Map<String, dynamic>>> getMovimientosByTipo({
    required String tipo,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) async {
    return getMovimientos(
      tipo: tipo,
      fechaDesde: fechaDesde,
      fechaHasta: fechaHasta,
    );
  }

  /// Obtiene movimientos pendientes
  Future<List<Map<String, dynamic>>> getMovimientosPendientes({
    String? tiendaId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo movimientos pendientes');

      var query = SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .eq('estado', 'PENDIENTE');

      if (tiendaId != null) {
        query = query.or(
          'tienda_origen_id.eq.$tiendaId,tienda_destino_id.eq.$tiendaId',
        );
      }

      final response = await query.order('fecha_movimiento');

      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Marca un movimiento como sincronizado
  Future<void> markAsSynced(String id, DateTime syncTime) async {
    return SupabaseDataSource.executeQuery(() async {
      await SupabaseDataSource.client
          .from(_tableName)
          .update({
            'last_sync': syncTime.toIso8601String(),
            'sincronizado': true,
          })
          .eq('id', id);

      AppLogger.sync('Movimiento marcado como sincronizado: $id');
    });
  }

  /// Obtiene movimientos modificados desde una fecha
  Future<List<Map<String, dynamic>>> getMovimientosModificados(
    DateTime since,
  ) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.sync('Obteniendo movimientos modificados desde: $since');

      final response = await SupabaseDataSource.client
          .from(_tableName)
          .select('*')
          .gt('updated_at', since.toIso8601String())
          .order('updated_at');

      AppLogger.sync('✅ ${response.length} movimientos modificados');
      return List<Map<String, dynamic>>.from(response);
    });
  }

  /// Obtiene reporte de movimientos por periodo
  Future<Map<String, dynamic>> getReporteMovimientos({
    required DateTime fechaDesde,
    required DateTime fechaHasta,
    String? tiendaId,
  }) async {
    return SupabaseDataSource.executeQuery(() async {
      AppLogger.database('Obteniendo reporte de movimientos');

      final response = await SupabaseDataSource.client.rpc(
        'get_reporte_movimientos',
        params: {
          'p_fecha_desde': fechaDesde.toIso8601String(),
          'p_fecha_hasta': fechaHasta.toIso8601String(),
          if (tiendaId != null) 'p_tienda_id': tiendaId,
        },
      );

      return response;
    });
  }
}
