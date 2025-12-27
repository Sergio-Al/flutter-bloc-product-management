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
import 'daos/unidad_medida_dao.dart';
import 'daos/rol_dao.dart';

// Importar remote datasources para sync inicial
import '../../remote/categoria_remote_datasource.dart';
import '../../remote/unidad_medida_remote_datasource.dart';
import '../../remote/proveedor_remote_datasource.dart';
import '../../remote/tienda_remote_datasource.dart';
import '../../remote/almacen_remote_datasource.dart';

// Importar logger
import '../../../../core/utils/logger.dart';

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
    UnidadMedidaDao,
    RolDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migration from version 1 to 2: Make inventarioId nullable in movimientos table
        if (from < 2) {
          // SQLite doesn't support ALTER COLUMN, so we need to recreate the table
          await customStatement('''
            CREATE TABLE movimientos_new (
              id TEXT NOT NULL PRIMARY KEY,
              numero_movimiento TEXT NOT NULL UNIQUE,
              producto_id TEXT NOT NULL REFERENCES productos(id),
              inventario_id TEXT REFERENCES inventarios(id),
              lote_id TEXT REFERENCES lotes(id),
              tienda_origen_id TEXT REFERENCES tiendas(id),
              tienda_destino_id TEXT REFERENCES tiendas(id),
              proveedor_id TEXT REFERENCES proveedores(id),
              tipo TEXT NOT NULL,
              motivo TEXT,
              cantidad INTEGER NOT NULL,
              costo_unitario REAL NOT NULL DEFAULT 0.0,
              costo_total REAL NOT NULL DEFAULT 0.0,
              peso_total_kg REAL,
              usuario_id TEXT NOT NULL REFERENCES usuarios(id),
              estado TEXT NOT NULL,
              fecha_movimiento INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
              numero_factura TEXT,
              numero_guia_remision TEXT,
              vehiculo_placa TEXT,
              conductor TEXT,
              observaciones TEXT,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
              updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
              sync_id TEXT,
              last_sync INTEGER,
              sincronizado INTEGER NOT NULL DEFAULT 0
            )
          ''');
          
          // Copy data from old table to new table, converting empty strings to NULL
          await customStatement('''
            INSERT INTO movimientos_new 
            SELECT 
              id, numero_movimiento, producto_id,
              CASE WHEN inventario_id = '' THEN NULL ELSE inventario_id END,
              CASE WHEN lote_id = '' THEN NULL ELSE lote_id END,
              CASE WHEN tienda_origen_id = '' THEN NULL ELSE tienda_origen_id END,
              CASE WHEN tienda_destino_id = '' THEN NULL ELSE tienda_destino_id END,
              CASE WHEN proveedor_id = '' THEN NULL ELSE proveedor_id END,
              tipo,
              CASE WHEN motivo = '' THEN NULL ELSE motivo END,
              cantidad, costo_unitario, costo_total,
              CASE WHEN peso_total_kg = 0.0 THEN NULL ELSE peso_total_kg END,
              usuario_id, estado, fecha_movimiento,
              CASE WHEN numero_factura = '' THEN NULL ELSE numero_factura END,
              CASE WHEN numero_guia_remision = '' THEN NULL ELSE numero_guia_remision END,
              CASE WHEN vehiculo_placa = '' THEN NULL ELSE vehiculo_placa END,
              CASE WHEN conductor = '' THEN NULL ELSE conductor END,
              CASE WHEN observaciones = '' THEN NULL ELSE observaciones END,
              created_at, updated_at,
              CASE WHEN sync_id = '' THEN NULL ELSE sync_id END,
              last_sync, sincronizado
            FROM movimientos
          ''');
          
          // Drop old table
          await customStatement('DROP TABLE movimientos');
          
          // Rename new table to original name
          await customStatement('ALTER TABLE movimientos_new RENAME TO movimientos');
        }
        
        // Migration from version 2 to 3: Update role IDs to match Supabase UUIDs
        if (from < 3) {
          // Update roles to use UUID format instead of string IDs
          await customStatement('DELETE FROM roles');
          await customStatement('''
            INSERT INTO roles (id, nombre, descripcion, permisos, created_at, updated_at) VALUES
            ('00000000-0000-0000-0000-000000000001', 'Administrador', 'Acceso completo al sistema', '{"all": true}', strftime('%s', 'now'), strftime('%s', 'now')),
            ('00000000-0000-0000-0000-000000000002', 'Gerente', 'Gestión de tienda y reportes', '{"inventarios": true, "movimientos": true, "reportes": true}', strftime('%s', 'now'), strftime('%s', 'now')),
            ('00000000-0000-0000-0000-000000000003', 'Almacenero', 'Gestión de inventarios y movimientos', '{"inventarios": true, "movimientos": true}', strftime('%s', 'now'), strftime('%s', 'now')),
            ('00000000-0000-0000-0000-000000000004', 'Vendedor', 'Consulta de productos y ventas', '{"productos": "read", "inventarios": "read"}', strftime('%s', 'now'), strftime('%s', 'now'))
          ''');
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
    AppLogger.database('🌱 Starting initial data seed...');
    
    // Try to sync from NestJS first, fallback to local defaults on failure
    try {
      await _syncDefaultsFromRemote();
      AppLogger.database('✅ Initial data synced from NestJS successfully');
      
      // Still need to insert roles locally (they're not in NestJS)
      await _seedRoles();
      return;
    } catch (e) {
      AppLogger.warning('⚠️ Could not fetch from NestJS, using local defaults: $e');
    }
    
    // Fallback: Insert local default data
    await _seedRoles();
    await _seedLocalDefaults();
  }

  // Seed roles (always local, not in NestJS)
  Future<void> _seedRoles() async {
    final rolesDefault = [
      RolesCompanion.insert(
        id: '00000000-0000-0000-0000-000000000001',
        nombre: 'Administrador',
        descripcion: const Value('Acceso completo al sistema'),
        permisos: '{"all": true}',
      ),
      RolesCompanion.insert(
        id: '00000000-0000-0000-0000-000000000002',
        nombre: 'Gerente',
        descripcion: const Value('Gestión de tienda y reportes'),
        permisos:
            '{"inventarios": true, "movimientos": true, "reportes": true}',
      ),
      RolesCompanion.insert(
        id: '00000000-0000-0000-0000-000000000003',
        nombre: 'Almacenero',
        descripcion: const Value('Gestión de inventarios y movimientos'),
        permisos: '{"inventarios": true, "movimientos": true}',
      ),
      RolesCompanion.insert(
        id: '00000000-0000-0000-0000-000000000004',
        nombre: 'Vendedor',
        descripcion: const Value('Consulta de productos y ventas'),
        permisos: '{"productos": "read", "inventarios": "read"}',
      ),
    ];

    for (final rol in rolesDefault) {
      await into(roles).insert(rol, mode: InsertMode.insertOrIgnore);
    }
  }

  // Seed local fallback defaults (only used when NestJS is unavailable)
  Future<void> _seedLocalDefaults() async {
    AppLogger.database('📝 Inserting local fallback defaults...');

    // Insertar unidades de medida por defecto
    final unidadesDefault = [
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000001',
        nombre: 'Unidad',
        abreviatura: 'UND',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000002',
        nombre: 'Bolsa',
        abreviatura: 'BLS',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000003',
        nombre: 'Metro',
        abreviatura: 'M',
        tipo: 'Longitud',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000004',
        nombre: 'Kilogramo',
        abreviatura: 'KG',
        tipo: 'Peso',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000005',
        nombre: 'Litro',
        abreviatura: 'LT',
        tipo: 'Volumen',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000006',
        nombre: 'Plancha',
        abreviatura: 'PLCH',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000007',
        nombre: 'Pieza',
        abreviatura: 'PZA',
        tipo: 'Unidad',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000008',
        nombre: 'Metro Cuadrado',
        abreviatura: 'M²',
        tipo: 'Area',
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000009',
        nombre: 'Galón',
        abreviatura: 'GAL',
        tipo: 'Volumen',
        factorConversion: const Value(3.785), // litros
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000010',
        nombre: 'Tonelada',
        abreviatura: 'TON',
        tipo: 'Peso',
        factorConversion: const Value(1000.0), // kilogramos
      ),
      UnidadesMedidaCompanion.insert(
        id: '00000000-0000-0000-0000-000000000011',
        nombre: 'Metro Cúbico',
        abreviatura: 'M³',
        tipo: 'Volumen',
      ),
    ];

    for (final unidad in unidadesDefault) {
      await into(
        unidadesMedida,
      ).insert(unidad, mode: InsertMode.insertOrIgnore);
    }

    /*-- Insertar categorías principales
INSERT INTO public.categorias (id, nombre, codigo, descripcion, requiere_lote, requiere_certificacion) VALUES
    ('00000000-0000-0000-0000-000000000001','Sin categoria', 'GEN', 'Categoría genérica para productos sin clasificación', false, false),
    ('00000000-0000-0000-0000-000000000002','Cemento', 'CEM', 'Cementos y derivados', true, true),
    ('00000000-0000-0000-0000-000000000003','Fierro y Acero', 'FIE', 'Varillas, mallas, perfiles de acero', false, true),
    ('00000000-0000-0000-0000-000000000004','Madera', 'MAD', 'Madera y productos derivados', false, false),
    ('00000000-0000-0000-0000-000000000005','Agregados', 'AGR', 'Arena, grava, piedra', false, false),
    ('00000000-0000-0000-0000-000000000006','Pintura', 'PIN', 'Pinturas, barnices y lacas', true, false),
    ('00000000-0000-0000-0000-000000000007','Calaminas', 'CAL', 'Calaminas y materiales de cubierta', false, false),
    ('00000000-0000-0000-0000-000000000008','Material Eléctrico', 'ELE', 'Cables, interruptores, enchufes', false, false),
    ('00000000-0000-0000-0000-000000000009','Plomería', 'PLO', 'Tuberías, conexiones, grifería', false, false),
    ('00000000-0000-0000-0000-000000000010','Herramientas', 'HER', 'Herramientas manuales y eléctricas', false, false),
    ('00000000-0000-0000-0000-000000000011','Ladrillos y Bloques', 'LAD', 'Ladrillos, bloques, adoquines', false, false)
ON CONFLICT (codigo) DO NOTHING;--*/

    // Insertar categorías por defecto
    final categoriasDefault = [
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000001',
        nombre: 'Sin Categoría',
        codigo: 'GEN',
        descripcion: const Value(
          'Categoría general para productos sin clasificar',
        ),
        requiereLote: const Value(false),
        requiereCertificacion: const Value(false),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000002',
        nombre: 'Cemento',
        codigo: 'CEM',
        descripcion: const Value('Cementos y derivados'),
        requiereLote: const Value(true),
        requiereCertificacion: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000003',
        nombre: 'Fierro y Acero',
        codigo: 'FIE',
        descripcion: const Value('Varillas, mallas, perfiles'),
        requiereCertificacion: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000004',
        nombre: 'Madera',
        codigo: 'MAD',
        descripcion: const Value('Madera y derivados'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000005',
        nombre: 'Agregados',
        codigo: 'AGR',
        descripcion: const Value('Arena, grava, piedra'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000006',
        nombre: 'Pintura',
        codigo: 'PIN',
        descripcion: const Value('Pinturas y barnices'),
        requiereLote: const Value(true),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000007',
        nombre: 'Calaminas',
        codigo: 'CAL',
        descripcion: const Value('Calaminas y cubiertas'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000008',
        nombre: 'Material Eléctrico',
        codigo: 'ELE',
        descripcion: const Value('Cables, interruptores, enchufes'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000009',
        nombre: 'Plomería',
        codigo: 'PLO',
        descripcion: const Value('Tuberías, conexiones, grifería'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000010',
        nombre: 'Herramientas',
        codigo: 'HER',
        descripcion: const Value('Herramientas manuales y eléctricas'),
      ),
      CategoriasCompanion.insert(
        id: '00000000-0000-0000-0000-000000000011',
        nombre: 'Ladrillos y Bloques',
        codigo: 'LAD',
        descripcion: const Value('Ladrillos, bloques, adoquines'),
      ),
    ];

    for (final categoria in categoriasDefault) {
      await into(categorias).insert(categoria, mode: InsertMode.insertOrIgnore);
    }

    // Insertar una tienda principal por defecto
    final tiendaPrincipal = TiendasCompanion.insert(
      id: '00000000-0000-0000-0000-000000000001',
      nombre: 'Tienda Central',
      codigo: 'TIENDA-CENTRAL',
      direccion: 'Av. Principal #123',
      ciudad: 'Ciudad',
      departamento: 'Departamento',
      telefono: const Value('555-1234'),
      horarioAtencion: const Value('Lun-Vie 8:00-18:00; Sáb 9:00-14:00'),
    );

    await into(tiendas).insert(
      tiendaPrincipal,
      mode: InsertMode.insertOrIgnore,
    );

//   -- Insertar un proveedor genérico
// INSERT INTO public.proveedores (id, razon_social, nit, nombre_contacto, telefono, email, direccion, ciudad, tipo_material) VALUES
//     ('00000000-0000-0000-0000-000000000001', 'Proveedor Genérico', 'NIT-GEN-0001', 'Contacto Genérico', '555-0000', 'contacto@generico.com', 'Calle Falsa 123', 'Ciudad', 'Materiales Generales')
// ON CONFLICT (id) DO NOTHING;
    // Insertar un proveedor genérico
    final proveedorGenerico = ProveedoresCompanion.insert(
      id: '00000000-0000-0000-0000-000000000001',
      razonSocial: 'Proveedor Genérico',
      nit: 'NIT-GEN-0001',
      nombreContacto: Value('Contacto Genérico'),
      telefono: Value('555-0000'),
      email: Value('contacto@generico.com'),
      direccion: Value('Calle Falsa 123'),
      ciudad: Value('Ciudad'),
      tipoMaterial: Value('Materiales Generales'),
    );

    await into(proveedores).insert(
      proveedorGenerico,
      mode: InsertMode.insertOrIgnore,
    );

//     -- Insertar un almacén principal para la tienda
// INSERT INTO public.almacenes (id, nombre, codigo, tienda_id, ubicacion, tipo, capacidad_m3, area_m2) VALUES
//     ('00000000-0000-0000-0000-000000000001', 'Almacén Principal', 'ALM-PRINCIPAL', '00000000-0000-0000-0000-000000000001', 'Ubicación Central', 'Principal', 1000.0, 500.0)
// ON CONFLICT (id) DO NOTHING;

    // Insertar un almacén principal para la tienda
    final almacenPrincipal = AlmacenesCompanion.insert(
      id: '00000000-0000-0000-0000-000000000001',
      nombre: 'Almacén Principal',
      codigo: 'ALM-PRINCIPAL',
      tiendaId: '00000000-0000-0000-0000-000000000001',
      ubicacion: 'Ubicación Central',
      tipo: 'Principal',
      capacidadM3: Value(1000.0),
      areaM2: Value(500.0),
    );

    await into(almacenes).insert(
      almacenPrincipal,
      mode: InsertMode.insertOrIgnore,
    );
  }

  // Public method to ensure default data exists (can be called at any time)
  // Tries to fetch from Supabase first, then falls back to local seeds
  Future<void> ensureDefaultsExist() async {
    AppLogger.database('🔄 Ensuring default data exists...');

    try {
      // Try to sync from remote first
      await _syncDefaultsFromRemote();
      AppLogger.database('✅ Defaults synced from remote successfully');
    } catch (e) {
      // If remote fetch fails, use local seeds
      AppLogger.warning(
        '⚠️ Could not fetch from remote, using local seeds: $e',
      );
      await _seedInitialData();
      AppLogger.database('✅ Local seed data inserted');
    }
  }

  // Sync default data from NestJS backend
  Future<void> _syncDefaultsFromRemote() async {
    final categoriaRemote = CategoriaRemoteDataSource();
    final unidadRemote = UnidadMedidaRemoteDataSource();
    final proveedorRemote = ProveedorRemoteDataSource();
    final tiendaRemote = TiendaRemoteDataSource();
    final almacenRemote = AlmacenRemoteDataSource();

    // Fetch categorías from NestJS
    try {
      final remoteCategorias = await categoriaRemote.getCategoriasActivas();
      AppLogger.database(
        '📥 Fetched ${remoteCategorias.length} categorías from NestJS',
      );

      // Use insertOrReplace to sync data without deleting (avoids FK constraint issues)
      for (final categoriaMap in remoteCategorias) {
        // Handle categoria_padre as nested object or null
        String? categoriaPadreId;
        final categoriaPadre = categoriaMap['categoria_padre'];
        if (categoriaPadre is Map<String, dynamic>) {
          categoriaPadreId = categoriaPadre['id'] as String?;
        }

        await into(categorias).insert(
          CategoriasCompanion.insert(
            id: categoriaMap['id'] as String,
            nombre: categoriaMap['nombre'] as String,
            codigo: categoriaMap['codigo'] as String,
            descripcion: Value(categoriaMap['descripcion'] as String?),
            categoriaPadreId: Value(categoriaPadreId),
            requiereLote: Value(
              categoriaMap['requiere_lote'] as bool? ?? false,
            ),
            requiereCertificacion: Value(
              categoriaMap['requiere_certificacion'] as bool? ?? false,
            ),
            activo: Value(categoriaMap['activo'] as bool? ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // Ensure default category exists (fallback if not in remote)
      if (!remoteCategorias.any((cat) => cat['codigo'] == 'GEN')) {
        await into(categorias).insert(
          CategoriasCompanion.insert(
            id: 'b0e2f135-6f39-4b19-af25-f534bc1d2346',
            nombre: 'Sin Categoría',
            codigo: 'GEN',
            descripcion: const Value(
              'Categoría general para productos sin clasificar',
            ),
            requiereLote: const Value(false),
            requiereCertificacion: const Value(false),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      AppLogger.database(
        '✅ ${remoteCategorias.length} categorías synced from NestJS',
      );
    } catch (e) {
      AppLogger.error('Error fetching categorías from NestJS', e);
      rethrow;
    }

    // Fetch unidades from NestJS
    try {
      final remoteUnidades = await unidadRemote.getUnidadesActivas();
      AppLogger.database(
        '📥 Fetched ${remoteUnidades.length} unidades from NestJS',
      );

      // Use insertOrReplace to sync data without deleting (avoids FK constraint issues)
      for (final unidadMap in remoteUnidades) {
        // Parse factor_conversion - NestJS returns it as string "1.00"
        double factorConversion = 1.0;
        final factorValue = unidadMap['factor_conversion'];
        if (factorValue != null) {
          if (factorValue is num) {
            factorConversion = factorValue.toDouble();
          } else if (factorValue is String) {
            factorConversion = double.tryParse(factorValue) ?? 1.0;
          }
        }

        await into(unidadesMedida).insert(
          UnidadesMedidaCompanion.insert(
            id: unidadMap['id'] as String,
            nombre: unidadMap['nombre'] as String,
            abreviatura: unidadMap['abreviatura'] as String,
            tipo: unidadMap['tipo'] as String,
            factorConversion: Value(factorConversion),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // Ensure default unit exists (fallback if not in remote)
      if (!remoteUnidades.any((unit) => unit['abreviatura'] == 'UND')) {
        await into(unidadesMedida).insert(
          UnidadesMedidaCompanion.insert(
            id: 'default-unit-id',
            nombre: 'Unidad',
            abreviatura: 'UND',
            tipo: 'Unidad',
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      AppLogger.database(
        '✅ ${remoteUnidades.length} unidades synced from NestJS',
      );
    } catch (e) {
      AppLogger.error('Error fetching unidades from NestJS', e);
      rethrow;
    }

    // Fetch proveedores from NestJS
    try {
      final remoteProveedores = await proveedorRemote.getProveedores(soloActivos: true);
      AppLogger.database(
        '📥 Fetched ${remoteProveedores.length} proveedores from NestJS',
      );

      for (final proveedorMap in remoteProveedores) {
        final diasCreditoValue = proveedorMap['dias_credito'];
        await into(proveedores).insert(
          ProveedoresCompanion.insert(
            id: proveedorMap['id'] as String,
            razonSocial: proveedorMap['razon_social'] as String,
            nit: proveedorMap['nit'] as String,
            nombreContacto: Value(proveedorMap['nombre_contacto'] as String?),
            telefono: Value(proveedorMap['telefono'] as String?),
            email: Value(proveedorMap['email'] as String?),
            direccion: Value(proveedorMap['direccion'] as String?),
            ciudad: Value(proveedorMap['ciudad'] as String?),
            tipoMaterial: Value(proveedorMap['tipo_material'] as String?),
            diasCredito: diasCreditoValue != null ? Value(diasCreditoValue as int) : const Value.absent(),
            activo: Value(proveedorMap['activo'] as bool? ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // Ensure default proveedor exists (fallback if not in remote)
      if (remoteProveedores.isEmpty) {
        await into(proveedores).insert(
          ProveedoresCompanion.insert(
            id: '00000000-0000-0000-0000-000000000001',
            razonSocial: 'Proveedor Genérico',
            nit: 'NIT-GEN-0001',
            nombreContacto: const Value('Contacto Genérico'),
            telefono: const Value('555-0000'),
            email: const Value('contacto@generico.com'),
            direccion: const Value('Calle Falsa 123'),
            ciudad: const Value('Ciudad'),
            tipoMaterial: const Value('Materiales Generales'),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      AppLogger.database(
        '✅ ${remoteProveedores.length} proveedores synced from NestJS',
      );
    } catch (e) {
      AppLogger.error('Error fetching proveedores from NestJS', e);
      // Don't rethrow - proveedores are not critical for initial setup
    }

    // Fetch tiendas from NestJS
    try {
      final remoteTiendas = await tiendaRemote.getTiendas();
      AppLogger.database(
        '📥 Fetched ${remoteTiendas.length} tiendas from NestJS',
      );

      for (final tiendaMap in remoteTiendas) {
        await into(tiendas).insert(
          TiendasCompanion.insert(
            id: tiendaMap['id'] as String,
            nombre: tiendaMap['nombre'] as String,
            codigo: tiendaMap['codigo'] as String,
            direccion: tiendaMap['direccion'] as String,
            ciudad: tiendaMap['ciudad'] as String,
            departamento: tiendaMap['departamento'] as String,
            telefono: Value(tiendaMap['telefono'] as String?),
            horarioAtencion: Value(tiendaMap['horario_atencion'] as String?),
            activo: Value(tiendaMap['activo'] as bool? ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // Ensure default tienda exists (fallback if not in remote)
      if (remoteTiendas.isEmpty) {
        await into(tiendas).insert(
          TiendasCompanion.insert(
            id: '00000000-0000-0000-0000-000000000001',
            nombre: 'Tienda Central',
            codigo: 'TIENDA-CENTRAL',
            direccion: 'Av. Principal #123',
            ciudad: 'Ciudad',
            departamento: 'Departamento',
            telefono: const Value('555-1234'),
            horarioAtencion: const Value('Lun-Vie 8:00-18:00; Sáb 9:00-14:00'),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      AppLogger.database(
        '✅ ${remoteTiendas.length} tiendas synced from NestJS',
      );
    } catch (e) {
      AppLogger.error('Error fetching tiendas from NestJS', e);
      // Don't rethrow - tiendas are not critical for initial setup
    }

    // Fetch almacenes from NestJS
    try {
      final remoteAlmacenes = await almacenRemote.getAlmacenes();
      AppLogger.database(
        '📥 Fetched ${remoteAlmacenes.length} almacenes from NestJS',
      );

      for (final almacenMap in remoteAlmacenes) {
        // Handle tienda as nested object
        String? tiendaId;
        final tienda = almacenMap['tienda'];
        if (tienda is Map<String, dynamic>) {
          tiendaId = tienda['id'] as String?;
        } else {
          tiendaId = almacenMap['tienda_id'] as String?;
        }

        await into(almacenes).insert(
          AlmacenesCompanion.insert(
            id: almacenMap['id'] as String,
            nombre: almacenMap['nombre'] as String,
            codigo: almacenMap['codigo'] as String,
            tiendaId: tiendaId ?? '00000000-0000-0000-0000-000000000001',
            ubicacion: almacenMap['ubicacion'] as String? ?? '',
            tipo: almacenMap['tipo'] as String? ?? 'Principal',
            capacidadM3: Value(_parseDouble(almacenMap['capacidad_m3'])),
            areaM2: Value(_parseDouble(almacenMap['area_m2'])),
            activo: Value(almacenMap['activo'] as bool? ?? true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // Ensure default almacen exists (fallback if not in remote)
      if (remoteAlmacenes.isEmpty) {
        await into(almacenes).insert(
          AlmacenesCompanion.insert(
            id: '00000000-0000-0000-0000-000000000001',
            nombre: 'Almacén Principal',
            codigo: 'ALM-PRINCIPAL',
            tiendaId: '00000000-0000-0000-0000-000000000001',
            ubicacion: 'Ubicación Central',
            tipo: 'Principal',
            capacidadM3: const Value(1000.0),
            areaM2: const Value(500.0),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }

      AppLogger.database(
        '✅ ${remoteAlmacenes.length} almacenes synced from NestJS',
      );
    } catch (e) {
      AppLogger.error('Error fetching almacenes from NestJS', e);
      // Don't rethrow - almacenes are not critical for initial setup
    }
  }

  // Helper to parse double from various formats
  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gestion_materiales.sqlite'));
    return NativeDatabase(file);
  });
}
