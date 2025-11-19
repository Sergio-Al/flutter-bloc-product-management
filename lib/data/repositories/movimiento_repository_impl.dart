import 'package:dartz/dartz.dart';
import 'package:flutter_management_system/core/errors/failures.dart';
import 'package:flutter_management_system/core/network/network_info.dart';
import 'package:flutter_management_system/core/sync/sync_manager.dart';
import 'package:flutter_management_system/core/sync/sync_item.dart';
import 'package:flutter_management_system/core/utils/logger.dart';
import 'package:flutter_management_system/core/utils/uuid_generator.dart';
import 'package:flutter_management_system/data/datasources/local/database/daos/movimiento_dao.dart';
import 'package:flutter_management_system/data/datasources/remote/movimiento_remote_datasource.dart';
import 'package:flutter_management_system/data/mappers/movimiento_mapper.dart';
import 'package:flutter_management_system/domain/entities/movimiento.dart';
import 'package:flutter_management_system/domain/repositories/movimiento_repository.dart';

class MovimientoRepositoryImpl extends MovimientoRepository {
  final MovimientoRemoteDataSource remoteDataSource;
  final MovimientoDao movimientoDao;
  final NetworkInfo networkInfo;
  final SyncManager syncManager;

  MovimientoRepositoryImpl({
    required this.remoteDataSource,
    required this.movimientoDao,
    required this.networkInfo,
    required this.syncManager,
  });

  @override
  Future<Either<Failure, Movimiento>> cancelarMovimiento({
    required String id,
    required String motivo,
  }) async {
    try {
      // Validation: Can only cancel if not already completed/cancelled
      final movimientoTable = await movimientoDao.getMovimientoById(id);
      if (movimientoTable == null) {
        return Left(CacheFailure(message: 'Movimiento no encontrado'));
      }

      final movimiento = movimientoTable.toEntity();
      if (!movimiento.canBeCancelled) {
        return Left(
          ValidationFailure(
            message:
                'Solo los movimientos PENDIENTES o EN_TRANSITO pueden cancelarse. Estado actual: ${movimiento.estado}',
          ),
        );
      }

      // Update estado to CANCELADO and add motivo to observaciones
      final success = await movimientoDao.updateEstadoMovimiento(
        id,
        'CANCELADO',
      );
      if (success) {
        // Also update observaciones with cancellation reason
        final updatedTable = await movimientoDao.getMovimientoById(id);
        if (updatedTable != null) {
          final currentObservaciones = updatedTable.observaciones ?? '';
          final newObservaciones = currentObservaciones.isEmpty
              ? 'CANCELADO: $motivo'
              : '$currentObservaciones\nCANCELADO: $motivo';

          await movimientoDao.updateObservaciones(id, newObservaciones);

          final finalTable = await movimientoDao.getMovimientoById(id);
          if (finalTable != null) {
            final entity = finalTable.toEntity();
            await syncManager.queueChange(
              entityId: id,
              entityType: SyncEntityType.movimiento,
              operation: SyncOperation.update,
              data: entity.toJson(),
            );
            return Right(entity);
          }
        }
        return Left(
          CacheFailure(message: 'Movimiento not found after cancellation'),
        );
      } else {
        return Left(CacheFailure(message: 'Failed to cancel movimiento'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to cancel movimiento: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> completarMovimiento(String id) async {
    try {
      // Validation: Can only complete PENDIENTE or EN_TRANSITO
      final movimientoTable = await movimientoDao.getMovimientoById(id);
      if (movimientoTable == null) {
        return Left(CacheFailure(message: 'Movimiento no encontrado'));
      }

      final movimiento = movimientoTable.toEntity();
      if (movimiento.isCompletado) {
        return Left(
          ValidationFailure(message: 'El movimiento ya está completado'),
        );
      }
      if (movimiento.isCancelado) {
        return Left(
          ValidationFailure(
            message: 'No se puede completar un movimiento cancelado',
          ),
        );
      }

      // Update estado to COMPLETADO
      final success = await movimientoDao.updateEstadoMovimiento(
        id,
        'COMPLETADO',
      );
      if (success) {
        final updatedTable = await movimientoDao.getMovimientoById(id);
        if (updatedTable != null) {
          final entity = updatedTable.toEntity();
          await syncManager.queueChange(
            entityId: id,
            entityType: SyncEntityType.movimiento,
            operation: SyncOperation.update,
            data: entity.toJson(),
          );
          return Right(entity);
        } else {
          return Left(
            CacheFailure(message: 'Movimiento not found after completion'),
          );
        }
      } else {
        return Left(CacheFailure(message: 'Failed to complete movimiento'));
      }
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to complete movimiento: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createAjuste({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String usuarioId,
    required String motivo,
    String? observaciones,
  }) async {
    try {
      final id = UuidGenerator.generate();
      final numeroMovimiento =
          'AJUSTE-${DateTime.now().millisecondsSinceEpoch}';

      final tiendaOrigenId = cantidad < 0 ? tiendaId : null;
      final tiendaDestinoId = cantidad > 0 ? tiendaId : null;

      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null,
        loteId: null,
        tiendaOrigenId: tiendaOrigenId,
        tiendaDestinoId: tiendaDestinoId,
        proveedorId: null,
        tipo: 'AJUSTE',
        motivo: motivo,
        cantidad: cantidad.abs(),
        costoUnitario: 0.0,
        costoTotal: 0.0,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: null,
        numeroGuiaRemision: null,
        vehiculoPlaca: null,
        conductor: null,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      await movimientoDao.insertMovimiento(movimiento.toTable());
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create ajuste: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createCompra({
    required String productoId,
    required String tiendaDestinoId,
    required String proveedorId,
    required int cantidad,
    required String usuarioId,
    required double costoUnitario,
    String? loteId,
    String? numeroFactura,
    String? observaciones,
  }) async {
    try {
      // Generate IDs
      final id = UuidGenerator.generate();
      final numeroMovimiento =
          'COMPRA-${DateTime.now().millisecondsSinceEpoch}';
      final costoTotal = cantidad * costoUnitario;

      // Create movimiento entity
      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null, // Will be set when linked to inventory
        loteId: loteId,
        tiendaOrigenId: null, // COMPRA has no origin
        tiendaDestinoId: tiendaDestinoId,
        proveedorId: proveedorId,
        tipo: 'COMPRA',
        motivo: null,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        costoTotal: costoTotal,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: numeroFactura,
        numeroGuiaRemision: null,
        vehiculoPlaca: null,
        conductor: null,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      // Save to local database
      await movimientoDao.insertMovimiento(movimiento.toTable());

      // Queue for sync
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      AppLogger.error('MovimientoRepositoryImpl.createCompra', e.toString());
      return Left(CacheFailure(message: 'Failed to create compra: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createDevolucion({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String usuarioId,
    required String motivo,
    String? numeroFactura,
    String? observaciones,
  }) async {
    try {
      final id = UuidGenerator.generate();
      final numeroMovimiento = 'DEV-${DateTime.now().millisecondsSinceEpoch}';

      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null,
        loteId: null,
        tiendaOrigenId: null,
        tiendaDestinoId: tiendaId,
        proveedorId: null,
        tipo: 'DEVOLUCION',
        motivo: motivo,
        cantidad: cantidad,
        costoUnitario: 0.0,
        costoTotal: 0.0,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: numeroFactura,
        numeroGuiaRemision: null,
        vehiculoPlaca: null,
        conductor: null,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      await movimientoDao.insertMovimiento(movimiento.toTable());
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create devolucion: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createMerma({
    required String productoId,
    required String tiendaId,
    required int cantidad,
    required String usuarioId,
    required String motivo,
    String? observaciones,
  }) async {
    try {
      final id = UuidGenerator.generate();
      final numeroMovimiento = 'MERMA-${DateTime.now().millisecondsSinceEpoch}';

      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null,
        loteId: null,
        tiendaOrigenId: tiendaId,
        tiendaDestinoId: null,
        proveedorId: null,
        tipo: 'MERMA',
        motivo: motivo,
        cantidad: cantidad,
        costoUnitario: 0.0,
        costoTotal: 0.0,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: null,
        numeroGuiaRemision: null,
        vehiculoPlaca: null,
        conductor: null,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      await movimientoDao.insertMovimiento(movimiento.toTable());
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create merma: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createTransferencia({
    required String productoId,
    required String tiendaOrigenId,
    required String tiendaDestinoId,
    required int cantidad,
    required String usuarioId,
    String? loteId,
    String? vehiculoPlaca,
    String? conductor,
    String? numeroGuiaRemision,
    String? observaciones,
  }) async {
    try {
      final id = UuidGenerator.generate();
      final numeroMovimiento = 'TRANS-${DateTime.now().millisecondsSinceEpoch}';

      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null,
        loteId: loteId,
        tiendaOrigenId: tiendaOrigenId,
        tiendaDestinoId: tiendaDestinoId,
        proveedorId: null,
        tipo: 'TRANSFERENCIA',
        motivo: null,
        cantidad: cantidad,
        costoUnitario: 0.0,
        costoTotal: 0.0,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: null,
        numeroGuiaRemision: numeroGuiaRemision,
        vehiculoPlaca: vehiculoPlaca,
        conductor: conductor,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      await movimientoDao.insertMovimiento(movimiento.toTable());
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create transferencia: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> createVenta({
    required String productoId,
    required String tiendaOrigenId,
    required int cantidad,
    required double costoUnitario,
    required String usuarioId,
    String? loteId,
    String? numeroFactura,
    String? observaciones,
  }) async {
    try {
      final id = UuidGenerator.generate();
      final numeroMovimiento = 'VENTA-${DateTime.now().millisecondsSinceEpoch}';
      final costoTotal = cantidad * costoUnitario;

      final movimiento = Movimiento(
        id: id,
        numeroMovimiento: numeroMovimiento,
        productoId: productoId,
        inventarioId: null,
        loteId: loteId,
        tiendaOrigenId: tiendaOrigenId,
        tiendaDestinoId: null,
        proveedorId: null,
        tipo: 'VENTA',
        motivo: null,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        costoTotal: costoTotal,
        pesoTotalKg: null,
        usuarioId: usuarioId,
        estado: 'PENDIENTE',
        fechaMovimiento: DateTime.now(),
        numeroFactura: numeroFactura,
        numeroGuiaRemision: null,
        vehiculoPlaca: null,
        conductor: null,
        observaciones: observaciones,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sincronizado: false,
      );

      await movimientoDao.insertMovimiento(movimiento.toTable());
      await syncManager.queueChange(
        entityId: id,
        entityType: SyncEntityType.movimiento,
        operation: SyncOperation.create,
        data: movimiento.toJson(),
      );

      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create venta: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMovimiento(String id) async {
    // ⚠️ MOVIMIENTOS SHOULD NEVER BE DELETED
    // Movimientos are audit/transaction records required for:
    // - Legal compliance (tax authorities require complete transaction history)
    // - Inventory integrity (deleting would corrupt stock calculations)
    // - Accounting accuracy (each movimiento affects financial records)
    // - Supply chain traceability
    //
    // Use cancelarMovimiento() instead to mark as CANCELADO
    return Left(
      ValidationFailure(
        message:
            'Los movimientos no pueden eliminarse. Use cancelarMovimiento() para cancelar.',
      ),
    );
  }

  @override
  Future<Either<Failure, Movimiento>> getMovimientoById(String id) async {
    try {
      final movimientoTable = await movimientoDao.getMovimientoById(id);
      if (movimientoTable == null) {
        return Left(
          CacheFailure(message: 'Movimiento no encontrado con id: $id'),
        );
      }
      final movimiento = movimientoTable.toEntity();
      return Right(movimiento);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get movimiento by id: $e'));
    }
  }

  @override
  Future<Either<Failure, Movimiento>> getMovimientoByNumero(
    String numeroMovimiento,
  ) async {
    try {
      // try local first
      final movimientoTable = await movimientoDao.getMovimientoByNumero(
        numeroMovimiento,
      );
      if (movimientoTable == null) {
        return Left(
          CacheFailure(
            message:
                'Movimiento no encontrado con numeroMovimiento: $numeroMovimiento',
          ),
        );
      }
      final movimiento = movimientoTable.toEntity();
      return Right(movimiento);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimiento by numero: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientos() async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getAllMovimientos();
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get movimientos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByEstado(
    String estado,
  ) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByEstado(
        estado,
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by estado: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByFechaRango({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByFechaRange(
        fechaInicio,
        fechaFin,
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by fecha rango: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByProducto(
    String productoId,
  ) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByProducto(
        productoId,
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by producto: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByTienda(
    String tiendaId,
  ) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByTienda(
        tiendaId,
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by tienda: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByTipo(
    String tipo,
  ) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByTipo(tipo);
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by tipo: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosByUsuario(
    String usuarioId,
  ) async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByUsuario(
        usuarioId,
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos by usuario: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosEnTransito() async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByEstado(
        'EN_TRANSITO',
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos en transito: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>>
  getMovimientosNoSincronizados() async {
    try {
      // try local first
      final movimientoTables = await movimientoDao
          .getMovimientosNoSincronizados();
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos no sincronizados: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movimiento>>> getMovimientosPendientes() async {
    try {
      // try local first
      final movimientoTables = await movimientoDao.getMovimientosByEstado(
        'PENDIENTE',
      );
      final movimientos = movimientoTables
          .map((table) => table.toEntity())
          .toList();
      return Right(movimientos);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get movimientos pendientes: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Movimiento>> marcarComoSincronizado(String id) async {
    try {
      final success = await movimientoDao.marcarComoSincronizado(id);
      if (success) {
        final movimientoTable = await movimientoDao.getMovimientoById(id);
        if (movimientoTable != null) {
          return Right(movimientoTable.toEntity());
        } else {
          return Left(
            CacheFailure(
              message: 'Movimiento not found after marking as synchronized',
            ),
          );
        }
      } else {
        return Left(
          CacheFailure(message: 'Failed to mark movimiento as synchronized'),
        );
      }
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to mark movimiento as synchronized: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Movimiento>> updateMovimiento(
    Movimiento movimiento,
  ) async {
    try {
      // Validation: Only PENDIENTE movimientos can be fully edited
      if (!movimiento.canBeEdited) {
        return Left(
          ValidationFailure(
            message:
                'Solo los movimientos PENDIENTES pueden editarse. Estado actual: ${movimiento.estado}',
          ),
        );
      }

      // Update local database
      final success = await movimientoDao.updateMovimiento(
        movimiento.toTable(),
      );
      if (success) {
        final updatedTable = await movimientoDao.getMovimientoById(
          movimiento.id,
        );
        if (updatedTable != null) {
          final entity = updatedTable.toEntity();
          await syncManager.queueChange(
            entityId: entity.id,
            entityType: SyncEntityType.movimiento,
            operation: SyncOperation.update,
            data: entity.toJson(),
          );
          return Right(entity);
        } else {
          return Left(
            CacheFailure(message: 'Movimiento not found after update'),
          );
        }
      } else {
        return Left(CacheFailure(message: 'Failed to update movimiento'));
      }
    } on Exception catch (e) {
      // Catch validation exceptions from DAO
      return Left(ValidationFailure(message: e.toString()));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update movimiento: $e'));
    }
  }
}
