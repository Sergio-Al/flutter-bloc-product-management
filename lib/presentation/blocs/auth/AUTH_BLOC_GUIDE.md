# AuthBloc - Complete Implementation Guide

## 📦 What Was Created

Complete BLoC implementation for authentication following the BLoC pattern with clean separation of events, states, and business logic. Now uses use cases for better separation of concerns and testability.

## 📁 Files Created

### 1. **auth_event.dart** - Authentication Events
All user actions that trigger authentication operations:

- `AuthLoginRequested`: Login with email/password
- `AuthRegisterRequested`: Register new user
- `AuthLogoutRequested`: Logout current user
- `AuthCheckStatusRequested`: Check if user is authenticated (app startup)
- `AuthRefreshTokenRequested`: Refresh JWT token
- `AuthPasswordResetRequested`: Send password reset email
- `AuthPasswordUpdateRequested`: Update user password

### 2. **auth_state.dart** - Authentication States
All possible states of the authentication system:

- `AuthInitial`: Initial state when app starts
- `AuthLoading`: Operation in progress
- `AuthAuthenticated`: User is logged in (contains Usuario entity)
- `AuthUnauthenticated`: User is logged out
- `AuthError`: Error occurred (contains error message)
- `AuthPasswordResetSent`: Password reset email sent
- `AuthPasswordUpdated`: Password updated successfully
- `AuthTokenRefreshed`: Token refreshed successfully

### 3. **auth_usecases.dart** - Authentication Use Cases
Business logic encapsulated in use cases:

- `LoginUseCase`: Handles login validation and calls repository
- `RegisterUseCase`: Handles registration logic
- `LogoutUseCase`: Handles logout
- `RefreshTokenUsecase`: Handles token refresh
- `IsAuthenticatedUsecase`: Checks authentication status
- `GetCurrentUserUsecase`: Retrieves current user
- `UpdatePasswordUsecase`: Updates password
- `ResetPasswordUsecase`: Sends password reset

### 4. **auth_bloc.dart** - Authentication BLoC
Main business logic component that:
- Listens to events
- Calls use case methods
- Emits appropriate states
- Handles errors with Either pattern

### 4. **auth_barrel.dart** - Barrel Export
Convenience file to import all auth bloc files at once:
```dart
import 'package:your_app/presentation/blocs/auth/auth_barrel.dart';
```

## 🎯 Architecture Flow

```
UI (Widget)
    ↓ [User Action]
Event (AuthLoginRequested)
    ↓ [BlocProvider]
AuthBloc
    ↓ [calls]
Use Case (e.g., LoginUseCase)
    ↓ [calls]
AuthRepository
    ↓ [returns Either<Failure, Usuario>]
Use Case
    ↓ [returns Either<Failure, Usuario>]
AuthBloc
    ↓ [emits]
State (AuthAuthenticated or AuthError)
    ↓ [BlocBuilder/BlocListener]
UI (Update Widget)
```

## 💡 Usage Examples

### 1. Setup in main.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  await setupDependencies(); // Initialize GetIt DI
  runApp(
    BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(const AuthCheckStatusRequested()),
      child: MyApp(),
    ),
  );
}
```

### 2. Login Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/presentation/blocs/auth/auth_barrel.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home page
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthLoginRequested(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### 3. Register Page

```dart
class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre Completo'),
                ),
                ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                            AuthRegisterRequested(
                              email: emailController.text,
                              password: passwordController.text,
                              nombreCompleto: nombreController.text,
                            ),
                          );
                        },
                  child: state is AuthLoading
                      ? CircularProgressIndicator()
                      : Text('Register'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### 4. App Startup Check

```dart
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
```

### 5. Logout Button

```dart
IconButton(
  icon: Icon(Icons.logout),
  onPressed: () {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  },
)
```

### 6. Protected Route

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Welcome ${state.user.nombreCompleto}'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                ),
              ],
            ),
            body: Center(
              child: Text('User ID: ${state.user.id}'),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
```

### 7. Password Reset

```dart
class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password reset email sent to ${state.email}'),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  AuthPasswordResetRequested(email: emailController.text),
                );
              },
              child: Text('Send Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧪 Testing

### Unit Test Example

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  // Mock other use cases as needed...

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      // ... other use cases
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    final testUser = Usuario(
      id: '123',
      email: 'test@test.com',
      nombreCompleto: 'Test User',
      rolId: 'role-id',
      activo: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockLoginUseCase(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@test.com',
          password: 'password',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockLoginUseCase(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer(
          (_) async => Left(AuthenticationFailure(message: 'Invalid credentials')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@test.com',
          password: 'wrong',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
      build: () {
        when(mockLogoutUseCase())
            .thenAnswer((_) async => const Right(unit));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(message: 'Logged out successfully'),
      ],
    );
  });
}
```

## 🔑 Key Features

### 1. **State Management**
- Clear separation of events and states
- Immutable states using Equatable
- Type-safe event handling

### 2. **Error Handling**
- Graceful error handling with Either pattern
- User-friendly error messages
- Automatic state transition on errors

### 3. **Loading States**
- Shows loading indicators during operations
- Prevents duplicate requests
- Better UX with feedback

### 4. **Token Management**
- Automatic token refresh
- Session expiration handling
- Background token refresh without UI disruption

### 5. **Offline Support**
- Works with cached data
- Handles network failures gracefully
- Syncs when connection restored

### 6. **Use Cases**
- Business logic separated into testable use cases
- Each use case handles one specific operation
- Easier to mock and test independently

## 📊 State Transitions

```
AuthInitial
    ↓ [AuthCheckStatusRequested]
AuthLoading
    ↓ [isAuthenticated = true]
AuthAuthenticated
    ↓ [AuthLogoutRequested]
AuthLoading
    ↓ [logout success]
AuthUnauthenticated

AuthUnauthenticated
    ↓ [AuthLoginRequested]
AuthLoading
    ↓ [login success]
AuthAuthenticated

AuthInitial
    ↓ [AuthRegisterRequested]
AuthLoading
    ↓ [register success]
AuthAuthenticated

Any State
    ↓ [operation fails]
AuthError
    ↓ [auto transition after showing error]
Previous State or AuthUnauthenticated
```

## 🚀 Next Steps

1. **Create UI Pages**:
   - Login page
   - Register page
   - Forgot password page
   - Profile page

2. **Add Dependency Injection**:
   - Setup GetIt (already done)
   - Register use cases and BLoC (already done)
   - Add for other modules (products, users, etc.)

3. **Add Navigation**:
   - Protected routes
   - Automatic redirect on auth state change
   - Deep linking support

4. **Enhance Features**:
   - Remember me functionality
   - Biometric authentication
   - Social login (Google, Facebook)
   - Email verification flow

## ✅ Status

- ✅ AuthEvent: 7 events defined
- ✅ AuthState: 8 states defined
- ✅ AuthUseCases: 8 use cases implemented
- ✅ AuthBloc: All event handlers implemented with use cases
- ✅ Compiles without errors
- ✅ Uses use cases for business logic
- ✅ Follows Clean Architecture principles
- ✅ Ready for UI integration
