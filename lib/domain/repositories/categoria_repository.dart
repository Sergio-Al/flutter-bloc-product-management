import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/categoria.dart';

/// Categoria repository interface
/// Defines the contract for category management operations
abstract class CategoriaRepository {
  /// Get all categories
  Future<Either<Failure, List<Categoria>>> getCategorias();

  /// Get category by ID
  Future<Either<Failure, Categoria>> getCategoriaById(String id);

  /// Get category by code
  Future<Either<Failure, Categoria>> getCategoriaByCodigo(String codigo);

  /// Get root categories (no parent)
  Future<Either<Failure, List<Categoria>>> getCategoriasRaiz();

  /// Get subcategories by parent category
  Future<Either<Failure, List<Categoria>>> getSubcategorias(
    String categoriaPadreId,
  );

  /// Get active categories only
  Future<Either<Failure, List<Categoria>>> getCategoriasActivas();

  /// Get categories that require lot tracking
  Future<Either<Failure, List<Categoria>>> getCategoriasRequierenLote();

  /// Get categories that require certification
  Future<Either<Failure, List<Categoria>>> getCategoriasRequierenCertificacion();

  /// Search categories by name or code
  Future<Either<Failure, List<Categoria>>> searchCategorias(String query);

  /// Create a new category
  Future<Either<Failure, Categoria>> createCategoria(Categoria categoria);

  /// Update existing category
  Future<Either<Failure, Categoria>> updateCategoria(Categoria categoria);

  /// Delete category
  Future<Either<Failure, Unit>> deleteCategoria(String id);

  /// Activate/deactivate category
  Future<Either<Failure, Categoria>> toggleCategoriaActiva(String id);
}
