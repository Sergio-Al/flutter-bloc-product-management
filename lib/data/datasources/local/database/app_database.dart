// lib/data/datasources/local/database/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Importar todas las tablas
import 'tables/usuarios_table.dart';
import 'tables/roles_table.dart';
import 'tables/tiendas_table.dart';
import 'tables/almacenes_table.dart';
import 'tables/categorias_table.dart';
import 'tables/unidades_medida_table.dart';
import 'tables/proveedores_table.dart';
import 'tables/productos_table.dart';
import 'tables/lotes_table.dart';
import 'tables/inventarios_table.dart';
import 'tables/movimientos_table.dart';
import 'tables/auditorias_table.dart';

// Importar DAOs
import 'daos/usuario_dao.dart';
import 'daos/producto_dao.dart';
import 'daos/inventario_dao.dart';
import 'daos/movimiento_dao.dart';
import 'daos/tienda_dao.dart';
import 'daos/almacen_dao.dart';
import 'daos/proveedor_dao.dart';
import 'daos/lote_dao.dart';
import 'daos/categoria_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Usuarios,
    Roles,
    Tiendas,
    Almacenes,
    Categorias,
    UnidadesMedida,
    Proveedores,
    Productos,
    Lotes,
    Inventarios,
    Movimientos,
    Auditorias,
  ],
  daos: [
    UsuarioDao,
    ProductoDao,
    InventarioDao,
    MovimientoDao,
    TiendaDao,
    AlmacenDao,
    ProveedorDao,
    LoteDao,
    CategoriaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Aquí irán las migraciones futuras
        if (from < 2) {
          // Ejemplo de migración
          // await m.addColumn(productos, productos.nuevoCampo);
        }
      },
      beforeOpen: (details) async {
        // Habilitar foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
        
        // Configurar para mejor performance
        await customStatement('PRAGMA journal_mode = WAL');
        await customStatement('PRAGMA synchronous = NORMAL');
        await customStatement('PRAGMA temp_store = MEMORY');
        await customStatement('PRAGMA cache_size = -64000'); // 64MB cache
      },
    );
  }

  // Seed de datos iniciales
  Future<void> _seedInitialData() async {
    // Insertar roles por defecto
    final rolesDefault = [
      RolesCompanion.insert(
        id: 'admin-role-id',
        nombre: 'Administrador',
        descripcion: const Value('Acceso completo al sistema'),
        permisos: '{"all": true}',
      ),
      RolesCompanion.insert(
        id: 'gerente-role-id',
        nombre: 'Gerente',
        descripcion: const Value('Gestión de tienda y reportes'),
        permisos: '{"inventarios": true, "movimientos": true, "reportes": true}',
      ),
      RolesCompanion.insert(
        id: 'almacenero-role-id',
        nombre: 'Almacenero',
        descripcion: const Value('Gestión de inventarios'),
        permisos: '{"inventarios": true, "movimientos": true}',
      ),
      RolesCompanion.insert(
        id: 'vendedor-role-id',
        nombre: 'Vendedor',
        descripcion: const Value('Consulta de productos y ventas'),
        permisos: '{"productos": "read", "inventarios": "read"}',
      ),
    ];

    for (final rol in rolesDefault) {
      await into(roles).insert(rol, mode: InsertMode.insertOrIgnore);
    }

    // Insertar unidades de medida por defecto
    final unidadesDefault = [
      UnidadesMedidaCompanion.insert(
        id: 'unidad-bolsa',
        nombre: 'Bolsa',
        abreviatura: 'BLS',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-metro',
        nombre: 'Metro',
        abreviatura: 'M',
        tipo: 'Longitud',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-kilo',
        nombre: 'Kilogramo',
        abreviatura: 'KG',
        tipo: 'Peso',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-litro',
        nombre: 'Litro',
        abreviatura: 'LT',
        tipo: 'Volumen',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-plancha',
        nombre: 'Plancha',
        abreviatura: 'PLCH',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-pieza',
        nombre: 'Pieza',
        abreviatura: 'PZA',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-metro-cuadrado',
        nombre: 'Metro Cuadrado',
        abreviatura: 'M²',
        tipo: 'Area',
      ),
      UnidadesMedidaCompanion.insert(
        id: 'unidad-galon',
        nombre: 'Galón',
        abreviatura: 'GAL',
        tipo: 'Volumen',
        factorConversion: const Value(3.785), // litros
      ),
    ];

    for (final unidad in unidadesDefault) {
      await into(unidadesMedida).insert(unidad, mode: InsertMode.insertOrIgnore);
    }

    // Insertar categorías por defecto
    final categoriasDefault = [
      CategoriasCompanion.insert(
        id: 'cat-cemento',
        nombre: 'Cemento',
        codigo: 'CEM',
        descripcion: const Value('Cementos y derivados'),
        requiereLote: const Value(true),
        requiereCertificacion: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: 'cat-fierro',
        nombre: 'Fierro y Acero',
        codigo: 'FIE',
        descripcion: const Value('Varillas, mallas, perfiles'),
        requiereCertificacion: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: 'cat-madera',
        nombre: 'Madera',
        codigo: 'MAD',
        descripcion: const Value('Madera y derivados'),
      ),
      CategoriasCompanion.insert(
        id: 'cat-agregados',
        nombre: 'Agregados',
        codigo: 'AGR',
        descripcion: const Value('Arena, grava, piedra'),
      ),
      CategoriasCompanion.insert(
        id: 'cat-pintura',
        nombre: 'Pintura',
        codigo: 'PIN',
        descripcion: const Value('Pinturas y barnices'),
        requiereLote: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: 'cat-calamina',
        nombre: 'Calaminas',
        codigo: 'CAL',
        descripcion: const Value('Calaminas y cubiertas'),
      ),
      CategoriasCompanion.insert(
        id: 'cat-electricidad',
        nombre: 'Material Eléctrico',
        codigo: 'ELE',
        descripcion: const Value('Cables, interruptores, enchufes'),
      ),
      CategoriasCompanion.insert(
        id: 'cat-plomeria',
        nombre: 'Plomería',
        codigo: 'PLO',
        descripcion: const Value('Tuberías, conexiones, grifería'),
      ),
      CategoriasCompanion.insert(
        id: 'cat-herramientas',
        nombre: 'Herramientas',
        codigo: 'HER',
        descripcion: const Value('Herramientas manuales y eléctricas'),
      ),
    ];

    for (final categoria in categoriasDefault) {
      await into(categorias).insert(categoria, mode: InsertMode.insertOrIgnore);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gestion_materiales.sqlite'));
    return NativeDatabase(file);
  });
}
