# Roles de usuarios

En este proyecto, se han definido varios roles de usuarios para gestionar el acceso y las funcionalidades dentro del sistema de gestión. A continuación se describen los roles principales:

1. **Administrador**
   - Tiene acceso completo a todas las funcionalidades del sistema.
   - Puede gestionar usuarios, productos, inventarios, proveedores y configuraciones del sistema.
   - Responsable de la supervisión general y mantenimiento del sistema.

2. **Gerente de Inventario**
   - Encargado de la gestión y control del inventario.
   - Puede agregar, editar y eliminar productos y categorías.
   - Responsable de la supervisión de los niveles de stock y la realización de pedidos a proveedores.
   - Transfiere productos entre almacenes.

3. **Vendedor**
   - Consulta y gestiona las ventas de productos.
   - Accede a la información de productos y realiza ventas.
   - No tiene permisos para modificar el inventario o la configuración del sistema.


# secuencias

Se han creado las siguientes secuencias para gestionar los identificadores únicos de las tablas principales:

1. Flujo de registro y autenticación de usuarios

```
sequenceDiagram
    actor Usuario
    participant App as Flutter App
    participant AuthBloc
    participant AuthRepo as Auth Repository
    participant Supabase
    participant Trigger as DB Trigger
    participant DB as Tabla usuarios

    %% REGISTRO
    rect rgb(200, 220, 255)
    note right of Usuario: REGISTRO DE NUEVO USUARIO
    Usuario->>App: Completa formulario registro
    App->>AuthBloc: AuthRegisterRequested(email, password, nombre)
    AuthBloc->>AuthRepo: register(email, password, nombre)
    AuthRepo->>Supabase: auth.signUp()
    Supabase-->>Supabase: Crea usuario en auth.users
    
    Note over Supabase,Trigger: Trigger automático se ejecuta
    Trigger->>DB: INSERT INTO usuarios<br/>(rol: Vendedor, tienda: default)
    DB-->>Trigger: Usuario creado con perfil
    
    Supabase-->>AuthRepo: AuthResponse + session
    AuthRepo->>Supabase: Espera 1 segundo (trigger completa)
    AuthRepo->>Supabase: getUserProfile(userId)
    Supabase-->>AuthRepo: UsuarioModel completo
    AuthRepo-->>AuthBloc: Right(Usuario entity)
    AuthBloc-->>App: AuthAuthenticated(usuario)
    App-->>Usuario: Navega a HomePage
    end

    %% LOGIN
    rect rgb(200, 255, 220)
    note right of Usuario: LOGIN DE USUARIO EXISTENTE
    Usuario->>App: Ingresa email y password
    App->>AuthBloc: AuthLoginRequested(email, password)
    AuthBloc->>AuthRepo: login(email, password)
    
    alt Cache disponible
        AuthRepo->>AuthRepo: Check cached user
        AuthRepo-->>AuthBloc: Right(Usuario from cache)
    else Sin cache o expirado
        AuthRepo->>Supabase: auth.signInWithPassword()
        Supabase-->>AuthRepo: AuthResponse + session
        AuthRepo->>Supabase: getUserProfile()
        Supabase-->>AuthRepo: UsuarioModel
        AuthRepo->>AuthRepo: Cache user locally
        AuthRepo-->>AuthBloc: Right(Usuario entity)
    end
    
    AuthBloc-->>App: AuthAuthenticated(usuario)
    App-->>Usuario: Navega a HomePage
    end
```

2. Flujo de creacion de productos

```
sequenceDiagram
    actor Gerente
    participant App as Flutter App
    participant ProductoBloc
    participant ProductoRepo as Producto Repository
    participant LocalDB as SQLite (Drift)
    participant Network as Network Check
    participant Supabase
    participant SyncQueue

    %% CREAR PRODUCTO
    rect rgb(255, 240, 200)
    note right of Gerente: CREAR NUEVO PRODUCTO
    Gerente->>App: Completa formulario producto
    App->>ProductoBloc: CreateProductoEvent(producto)
    ProductoBloc->>ProductoRepo: createProducto(producto)
    
    ProductoRepo->>Network: isConnected?
    
    alt Online
        Network-->>ProductoRepo: true
        ProductoRepo->>Supabase: INSERT INTO productos
        Supabase-->>ProductoRepo: Producto creado (UUID remoto)
        ProductoRepo->>LocalDB: Guarda en cache local
    else Offline
        Network-->>ProductoRepo: false
        ProductoRepo->>LocalDB: INSERT producto (UUID local)
        ProductoRepo->>SyncQueue: Encola para sincronización
        Note over SyncQueue: Esperará conectividad<br/>para enviar a Supabase
    end
    
    ProductoRepo-->>ProductoBloc: Right(Producto)
    ProductoBloc-->>App: ProductoCreated state
    App-->>Gerente: Muestra confirmación
    end

    %% LISTAR PRODUCTOS
    rect rgb(220, 255, 240)
    note right of Gerente: CONSULTAR PRODUCTOS
    Gerente->>App: Abre lista de productos
    App->>ProductoBloc: GetProductosEvent()
    ProductoBloc->>ProductoRepo: getProductos()
    
    ProductoRepo->>Network: isConnected?
    
    alt Online
        Network-->>ProductoRepo: true
        ProductoRepo->>Supabase: SELECT * FROM productos
        Supabase-->>ProductoRepo: List<ProductoModel>
        ProductoRepo->>LocalDB: Actualiza cache
        ProductoRepo-->>ProductoBloc: Right(List<Producto>)
    else Offline
        Network-->>ProductoRepo: false
        ProductoRepo->>LocalDB: SELECT * FROM productos_table
        LocalDB-->>ProductoRepo: List<ProductoModel>
        ProductoRepo-->>ProductoBloc: Right(List<Producto>)
        Note over App: Muestra badge<br/>"Modo Offline"
    end
    
    ProductoBloc-->>App: ProductosLoaded state
    App-->>Gerente: Renderiza lista
    end

    %% SINCRONIZACIÓN
    rect rgb(255, 220, 220)
    note right of Network: SINCRONIZACIÓN AUTOMÁTICA
    Network->>Network: Detecta conexión restaurada
    Network->>SyncQueue: Trigger sync
    SyncQueue->>Supabase: Envía cambios pendientes
    Supabase-->>SyncQueue: Confirmación
    SyncQueue->>LocalDB: Marca como sincronizado
    SyncQueue->>App: Notificación "Datos sincronizados"
    end
```

3. Flujo de gestion de inventario

```
sequenceDiagram
    actor Vendedor
    participant App
    participant InventarioBloc
    participant InventarioRepo
    participant MovimientoRepo
    participant LocalDB
    participant Supabase
    participant Auditoria as Trigger Auditoría

    %% CONSULTAR STOCK
    rect rgb(240, 240, 255)
    note right of Vendedor: CONSULTAR STOCK DE PRODUCTO
    Vendedor->>App: Busca producto "Cemento IP-30"
    App->>InventarioBloc: GetInventarioByProducto(productoId)
    InventarioBloc->>InventarioRepo: getInventarioByProducto(productoId)
    InventarioRepo->>LocalDB: Query inventario + almacén + tienda
    LocalDB-->>InventarioRepo: InventarioModel con relaciones
    InventarioRepo-->>InventarioBloc: Right(Inventario)
    InventarioBloc-->>App: InventarioLoaded
    App-->>Vendedor: Muestra stock disponible:<br/>Almacén Central: 150 bolsas<br/>Almacén Obra: 30 bolsas
    end

    %% REGISTRAR VENTA (Salida)
    rect rgb(255, 240, 240)
    note right of Vendedor: REGISTRAR VENTA
    Vendedor->>App: Registra venta: 10 bolsas de cemento
    App->>MovimientoRepo: createMovimiento({<br/>tipo: VENTA,<br/>cantidad: 10,<br/>producto: cemento<br/>})
    
    MovimientoRepo->>LocalDB: BEGIN TRANSACTION
    MovimientoRepo->>LocalDB: INSERT INTO movimientos
    MovimientoRepo->>LocalDB: UPDATE inventarios<br/>SET cantidad_actual = actual - 10
    
    alt Stock suficiente
        LocalDB-->>MovimientoRepo: Transaction OK
        MovimientoRepo->>LocalDB: COMMIT
        
        alt Online
            MovimientoRepo->>Supabase: Sincroniza movimiento
            Supabase->>Auditoria: Registra cambio en auditorías
            Auditoria-->>Supabase: Log creado
        else Offline
            MovimientoRepo->>LocalDB: Marca pendiente sincronización
        end
        
        MovimientoRepo-->>App: Right(Movimiento)
        App-->>Vendedor: ✅ Venta registrada<br/>Stock actualizado: 140 bolsas
    else Stock insuficiente
        LocalDB-->>MovimientoRepo: Error: Stock insuficiente
        MovimientoRepo->>LocalDB: ROLLBACK
        MovimientoRepo-->>App: Left(StockInsuficiente)
        App-->>Vendedor: ❌ Error: Solo hay 8 bolsas disponibles
    end
    end

    %% ALERTA DE STOCK BAJO
    rect rgb(255, 255, 220)
    note over App,Supabase: SISTEMA DE ALERTAS
    App->>InventarioBloc: CheckStockMinimo()
    InventarioBloc->>InventarioRepo: getProductosStockBajo()
    InventarioRepo->>LocalDB: SELECT WHERE actual < minimo
    LocalDB-->>InventarioRepo: List<Inventario>
    InventarioRepo-->>InventarioBloc: Right(List)
    InventarioBloc-->>App: StockBajoDetected
    App-->>Vendedor: 🔔 Notificación:<br/>"3 productos por debajo del stock mínimo"
    end
```


4. Flujo de transferencia entre tiendas
   
```
sequenceDiagram
    actor Gerente
    participant App
    participant MovimientoBloc
    participant MovimientoRepo
    participant InventarioRepo
    participant LocalDB
    participant Supabase
    participant TiendaDestino as Tienda Destino

    rect rgb(230, 250, 240)
    note right of Gerente: TRANSFERENCIA ENTRE TIENDAS
    
    Gerente->>App: Solicita transferencia:<br/>50 bolsas cemento<br/>Tienda A → Tienda B
    App->>MovimientoBloc: CreateTransferenciaEvent({<br/>origen: TiendaA,<br/>destino: TiendaB,<br/>producto: cemento,<br/>cantidad: 50<br/>})
    
    MovimientoBloc->>MovimientoRepo: createTransferencia(datos)
    
    %% VALIDACIONES
    MovimientoRepo->>InventarioRepo: checkStockDisponible(TiendaA, cemento)
    InventarioRepo->>LocalDB: SELECT cantidad_disponible
    LocalDB-->>InventarioRepo: 80 bolsas disponibles
    InventarioRepo-->>MovimientoRepo: Stock OK
    
    %% CREAR MOVIMIENTO
    MovimientoRepo->>LocalDB: BEGIN TRANSACTION
    
    %% Paso 1: Crear movimiento
    MovimientoRepo->>LocalDB: INSERT movimiento<br/>tipo: TRANSFERENCIA<br/>estado: PENDIENTE<br/>tienda_origen: A<br/>tienda_destino: B
    
    %% Paso 2: Descontar de origen
    MovimientoRepo->>LocalDB: UPDATE inventarios<br/>SET cantidad_reservada += 50<br/>WHERE tienda_id = A
    
    LocalDB-->>MovimientoRepo: Movimiento creado
    MovimientoRepo->>LocalDB: COMMIT
    
    MovimientoRepo-->>MovimientoBloc: Right(Movimiento)
    MovimientoBloc-->>App: TransferenciaCreated<br/>estado: PENDIENTE
    App-->>Gerente: ✅ Transferencia creada<br/>Número: TR-2024-001<br/>Estado: En tránsito
    
    %% COMPLETAR TRANSFERENCIA
    rect rgb(220, 240, 255)
    note right of TiendaDestino: RECEPCIÓN EN TIENDA DESTINO
    
    TiendaDestino->>App: Confirma recepción de 50 bolsas
    App->>MovimientoBloc: CompletarTransferenciaEvent(TR-2024-001)
    MovimientoBloc->>MovimientoRepo: completarTransferencia(movimientoId)
    
    MovimientoRepo->>LocalDB: BEGIN TRANSACTION
    
    %% Paso 1: Liberar reserva en origen
    MovimientoRepo->>LocalDB: UPDATE inventarios<br/>SET cantidad_actual -= 50,<br/>cantidad_reservada -= 50<br/>WHERE tienda_id = A
    
    %% Paso 2: Sumar en destino
    MovimientoRepo->>LocalDB: UPDATE inventarios<br/>SET cantidad_actual += 50<br/>WHERE tienda_id = B
    
    %% Paso 3: Cambiar estado
    MovimientoRepo->>LocalDB: UPDATE movimientos<br/>SET estado = COMPLETADO<br/>WHERE id = TR-2024-001
    
    LocalDB-->>MovimientoRepo: Transferencia completada
    MovimientoRepo->>LocalDB: COMMIT
    
    alt Online
        MovimientoRepo->>Supabase: Sincroniza cambios
        Supabase-->>MovimientoRepo: OK
    else Offline
        MovimientoRepo->>LocalDB: Marca pendiente sync
    end
    
    MovimientoRepo-->>MovimientoBloc: Right(Movimiento)
    MovimientoBloc-->>App: TransferenciaCompleted
    App-->>TiendaDestino: ✅ Transferencia completada<br/>Stock Tienda A: 30 bolsas<br/>Stock Tienda B: 100 bolsas
    end
    end
```


5. Flujo de sincronizacion offline-first

```
sequenceDiagram
    participant App
    participant SyncBloc
    participant SyncManager
    participant SyncQueue
    participant NetworkInfo
    participant LocalDB
    participant Supabase
    participant ConflictResolver

    %% DETECCIÓN DE CONEXIÓN
    rect rgb(255, 240, 230)
    note over App: APP RECUPERA CONEXIÓN
    NetworkInfo->>NetworkInfo: Detecta WiFi/4G
    NetworkInfo->>SyncBloc: ConnectionRestored event
    SyncBloc->>SyncManager: startSync()
    
    SyncManager->>SyncQueue: getPendingItems()
    SyncQueue->>LocalDB: SELECT * WHERE sincronizado = false
    LocalDB-->>SyncQueue: [Movimiento1, Producto2, Inventario3]
    SyncQueue-->>SyncManager: 3 items pendientes
    
    %% SINCRONIZACIÓN ITEM POR ITEM
    loop Para cada item pendiente
        SyncManager->>Supabase: Envía cambio (POST/PUT)
        
        alt Sin conflictos
            Supabase-->>SyncManager: 200 OK + timestamp
            SyncManager->>LocalDB: UPDATE sincronizado = true,<br/>last_sync = NOW()
            SyncManager->>App: Progress: 1/3 completado
        else Conflicto detectado (409)
            Supabase-->>SyncManager: 409 Conflict<br/>version_server: 5<br/>version_local: 3
            
            SyncManager->>ConflictResolver: resolve(localData, serverData)
            
            alt Auto-resolución
                ConflictResolver->>ConflictResolver: Server wins (más reciente)
                ConflictResolver->>LocalDB: UPDATE con datos del servidor
                ConflictResolver-->>SyncManager: Resuelto
            else Requiere intervención
                ConflictResolver-->>SyncManager: Manual resolution needed
                SyncManager->>App: Muestra diálogo de conflicto
                App-->>App: Usuario elige versión
                App->>SyncManager: Resolution selected
                SyncManager->>Supabase: Aplica resolución
            end
            
            Supabase-->>SyncManager: 200 OK
            SyncManager->>LocalDB: UPDATE sincronizado = true
        end
    end
    
    SyncManager-->>SyncBloc: SyncCompleted(success: 3, conflicts: 0)
    SyncBloc-->>App: Muestra notificación:<br/>"✅ Datos sincronizados"
    end

    %% SINCRONIZACIÓN PERIÓDICA
    rect rgb(240, 255, 240)
    note over App: SINCRONIZACIÓN AUTOMÁTICA CADA 5 MIN
    
    loop Cada 5 minutos
        SyncManager->>NetworkInfo: isConnected?
        
        alt Online
            NetworkInfo-->>SyncManager: true
            SyncManager->>Supabase: GET /productos?last_sync=2024-11-10T20:00:00
            Supabase-->>SyncManager: [Producto3 (updated), Producto4 (new)]
            SyncManager->>LocalDB: MERGE datos nuevos/actualizados
            LocalDB-->>SyncManager: OK
            SyncManager->>App: Background sync OK
        else Offline
            NetworkInfo-->>SyncManager: false
            SyncManager->>App: Skip sync (offline)
        end
    end
    end
```

## Arquitectura del sistema

```
graph TB
    subgraph "Presentation Layer"
        UI[Pages & Widgets]
        BLoC[BLoC States/Events]
    end
    
    subgraph "Domain Layer"
        UC[Use Cases]
        ENT[Entities]
        REPO_INT[Repository Interfaces]
    end
    
    subgraph "Data Layer"
        REPO_IMPL[Repository Implementations]
        MODEL[Models]
        DS_LOCAL[Local DataSource<br/>SQLite/Drift]
        DS_REMOTE[Remote DataSource<br/>Supabase]
    end
    
    subgraph "Core"
        SYNC[Sync Manager]
        NET[Network Info]
        CONFIG[Configuration]
    end
    
    subgraph "Backend Supabase"
        AUTH[Auth Service]
        DB[(PostgreSQL)]
        RLS[Row Level Security]
        TRIGGER[Triggers & Functions]
    end
    
    UI --> BLoC
    BLoC --> UC
    UC --> REPO_INT
    REPO_INT -.implements.-> REPO_IMPL
    REPO_IMPL --> MODEL
    REPO_IMPL --> DS_LOCAL
    REPO_IMPL --> DS_REMOTE
    REPO_IMPL --> NET
    
    DS_LOCAL --> SQLite[(SQLite DB)]
    DS_REMOTE --> AUTH
    DS_REMOTE --> DB
    
    SYNC --> DS_LOCAL
    SYNC --> DS_REMOTE
    SYNC --> NET
    
    DB --> RLS
    DB --> TRIGGER
    
    style UI fill:#e1f5ff
    style BLoC fill:#b3e5fc
    style UC fill:#81d4fa
    style REPO_IMPL fill:#4fc3f7
    style DS_LOCAL fill:#29b6f6
    style DS_REMOTE fill:#039be5
    style DB fill:#0277bd
```
