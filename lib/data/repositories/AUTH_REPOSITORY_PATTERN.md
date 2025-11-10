# Authentication Repository - Complete Implementation Pattern

This document explains the complete implementation of `AuthRepositoryImpl` as a reference pattern for implementing other repositories in this project.

## 📁 Architecture Overview

```
domain/
  repositories/
    auth_repository.dart          # Interface (contract)
  entities/
    usuario.dart                  # Pure business object

data/
  repositories/
    auth_repository_impl.dart     # Concrete implementation
  datasources/
    remote/
      auth_remote_datasource.dart # Supabase operations
    local/
      auth_local_datasource.dart  # Local caching (SharedPreferences)
  models/
    usuario_model.dart            # Data transfer object with JSON + Entity conversion
```

## 🎯 Key Principles

### 1. **Offline-First Pattern**
```dart
Future<Either<Failure, Usuario>> getCurrentUser() async {
  // 1. Try cache first (fast, works offline)
  if (await localDatasource.hasCachedUser()) {
    final cachedUser = await localDatasource.getCachedUser();
    return Right(cachedUser.toEntity());
  }

  // 2. Check network
  if (!await networkInfo.isConnected) {
    return Left(NetworkFailure(message: 'No cached user and no internet'));
  }

  // 3. Fetch from server and cache
  final userProfile = await remoteDatasource.getUserProfile();
  final usuarioModel = UsuarioModel.fromJson(userProfile);
  await localDatasource.cacheUser(usuarioModel);
  
  return Right(usuarioModel.toEntity());
}
```

### 2. **Functional Error Handling with Either**
```dart
// Left = Failure (error)
// Right = Success (data)
Future<Either<Failure, Usuario>> login({...}) async {
  try {
    // ... operations ...
    return Right(usuarioModel.toEntity());
  } on AuthenticationException catch (e) {
    return Left(AuthenticationFailure(message: e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } catch (e) {
    return Left(ServerFailure(message: 'Unexpected error: $e'));
  }
}
```

### 3. **Layer Separation**

#### Domain Layer (Business Logic)
- **Entity** (`Usuario`): Pure Dart class, no external dependencies
- **Repository Interface** (`AuthRepository`): Abstract contract
- **Use Cases**: Will use repository interface (not implementation)

#### Data Layer (Implementation)
- **Model** (`UsuarioModel`): 
  - JSON serialization (`fromJson`, `toJson`)
  - Entity conversion (`toEntity()`, `fromEntity()`)
- **Remote Datasource**: Supabase Auth + Database operations
- **Local Datasource**: SharedPreferences caching
- **Repository Implementation**: Orchestrates datasources + error handling

### 4. **Dependency Injection**
```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });
}
```

## 📝 Implementation Checklist

When creating a new repository, follow these steps:

### Step 1: Domain Layer
- [ ] Create entity in `lib/domain/entities/` (pure Dart, Equatable)
- [ ] Create repository interface in `lib/domain/repositories/`
- [ ] Define all CRUD + business methods with `Either<Failure, T>` returns

### Step 2: Data Layer - Models
- [ ] Create model in `lib/data/models/` extending from entity
- [ ] Add `fromJson` factory for API deserialization
- [ ] Add `toJson` method for API serialization
- [ ] Add `toEntity()` method (Model → Entity)
- [ ] Add `fromEntity()` factory (Entity → Model)
- [ ] Add `copyWith` for immutable updates

### Step 3: Data Layer - Datasources
- [ ] Create remote datasource interface + implementation
  - Supabase operations (CRUD, queries)
  - Throw `ServerException` on errors
  - Return raw data (Map, List, or Model)
- [ ] Create local datasource interface + implementation
  - Drift DAO operations (if using Drift)
  - Or SharedPreferences caching
  - Throw `CacheException` on errors

### Step 4: Data Layer - Repository Implementation
- [ ] Implement repository interface
- [ ] Inject datasources and NetworkInfo
- [ ] For each method:
  - [ ] Check network connectivity when needed
  - [ ] Try local datasource first (offline-first)
  - [ ] Fallback to remote datasource
  - [ ] Cache results locally
  - [ ] Convert Models to Entities
  - [ ] Wrap exceptions in Failures
  - [ ] Return `Either<Failure, T>`

## 🔍 Code Examples

### Example 1: Create Operation (Requires Network)

```dart
@override
Future<Either<Failure, Usuario>> register({
  required String email,
  required String password,
  required String nombreCompleto,
  String? telefono,
}) async {
  // Registration always requires network
  if (!await networkInfo.isConnected) {
    return Left(NetworkFailure(message: 'No internet connection'));
  }

  try {
    // 1. Create in remote database
    await remoteDatasource.register(
      email: email,
      password: password,
      nombreCompleto: nombreCompleto,
    );

    // 2. Fetch complete profile
    final userProfile = await remoteDatasource.getUserProfile();
    final usuarioModel = UsuarioModel.fromJson(userProfile);

    // 3. Cache locally for offline access
    await localDatasource.cacheUser(usuarioModel);

    // 4. Convert to entity and return
    return Right(usuarioModel.toEntity());
  } on AuthenticationException catch (e) {
    return Left(AuthenticationFailure(message: e.message));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } catch (e) {
    return Left(ServerFailure(message: 'Unexpected error: $e'));
  }
}
```

### Example 2: Read Operation (Offline-First)

```dart
@override
Future<Either<Failure, Usuario>> getCurrentUser() async {
  try {
    // 1. Try cache first (fast, works offline)
    if (await localDatasource.hasCachedUser()) {
      final cachedUser = await localDatasource.getCachedUser();
      return Right(cachedUser.toEntity());
    }

    // 2. No cache, need network
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No cached user and no internet'));
    }

    // 3. Fetch from server
    final userProfile = await remoteDatasource.getUserProfile();
    final usuarioModel = UsuarioModel.fromJson(userProfile);

    // 4. Cache for next time
    await localDatasource.cacheUser(usuarioModel);

    return Right(usuarioModel.toEntity());
  } on CacheException {
    // Handle cache miss, try server...
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}
```

### Example 3: Delete Operation (Optimistic)

```dart
@override
Future<Either<Failure, Unit>> logout() async {
  try {
    // 1. Clear local cache first (always succeeds)
    await localDatasource.clearCache();

    // 2. Try server logout if online
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.logout();
      } catch (e) {
        // Even if server fails, local cache is cleared
        // User is effectively logged out
      }
    }

    return const Right(unit);
  } on CacheException catch (e) {
    return Left(CacheFailure(message: e.message));
  }
}
```

## 🧪 Testing Strategy

### Unit Tests for Repository
```dart
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDatasource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDatasource();
    mockNetwork = MockNetworkInfo();
    
    repository = AuthRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('login', () {
    test('should return Usuario when login successful', () async {
      // Arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.login(...)).thenAnswer((_) async => {...});
      when(mockRemote.getUserProfile()).thenAnswer((_) async => {...});
      
      // Act
      final result = await repository.login(email: 'test@test.com', password: 'pass');
      
      // Assert
      expect(result, isA<Right<Failure, Usuario>>());
      verify(mockLocal.cacheUser(any));
    });
    
    test('should return NetworkFailure when offline', () async {
      // Arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
      
      // Act
      final result = await repository.login(email: 'test@test.com', password: 'pass');
      
      // Assert
      expect(result, Left(NetworkFailure(message: 'No internet connection')));
      verifyNever(mockRemote.login(...));
    });
  });
}
```

## 📊 Dependency Graph

```
Presentation Layer (BLoC)
         ↓
    Use Cases
         ↓
Repository Interface (Domain)
         ↓
Repository Implementation (Data)
    ↙          ↘
Remote DS    Local DS
    ↓            ↓
  Supabase   SharedPreferences/Drift
```

## 🚀 Usage in BLoC

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    // Use case calls repository
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
}
```

## 🔑 Key Takeaways

1. **Repository = Orchestrator**: Coordinates datasources, handles errors, manages offline-first logic
2. **Datasources = Workers**: Execute specific operations (network, database, cache)
3. **Models bridge layers**: Convert between JSON ↔ Model ↔ Entity
4. **Either for errors**: No throwing exceptions to UI, explicit error handling
5. **Offline-first**: Cache locally, sync when online
6. **Network awareness**: Check connectivity before remote operations
7. **Graceful degradation**: Continue working with cached data when offline

## 📚 Next Steps

Use this AuthRepositoryImpl as template for:
- ProductoRepositoryImpl
- InventarioRepositoryImpl  
- MovimientoRepositoryImpl
- Other repositories...

Each will follow same pattern with variations for:
- Sync queue integration (for CREATE/UPDATE/DELETE)
- Different caching strategies
- Business-specific logic
- Conflict resolution for offline edits
