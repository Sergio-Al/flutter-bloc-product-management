# Solución al Error de Registro PGRST116

## Problema
Al registrar un nuevo usuario, se produce el error:
```
PostgrestException(message: Cannot coerce the result to a single JSON object, 
code: PGRST116, details: The result contains 0 rows)
```

## Causa
Después de crear un usuario en Supabase Auth, la aplicación intenta obtener su perfil de la tabla `usuarios`, pero ese perfil no existe todavía porque no hay trigger que lo cree automáticamente.

## Soluciones Implementadas

### Solución 1: Modificación de Código (Ya Aplicada) ✅

La función `register()` en `auth_repository_impl.dart` ahora crea un perfil temporal de usuario después del registro, sin intentar obtenerlo de la base de datos.

**Ventaja:** Funciona inmediatamente sin cambios en la base de datos.
**Desventaja:** El usuario no tendrá rol ni tienda asignados hasta que un administrador los configure.

### Solución 2: Trigger de Base de Datos (Recomendada) 🔧

Para producción, deberías ejecutar el script `supabase_auth_trigger.sql` en tu base de datos Supabase.

#### Pasos:

1. **Ve a tu proyecto Supabase**
   - Abre https://app.supabase.com
   - Selecciona tu proyecto
   - Ve a "SQL Editor"

2. **Verifica que tienes roles creados**
   ```sql
   SELECT id, nombre FROM public.roles;
   ```
   
   Si no tienes roles, créalos primero:
   ```sql
   INSERT INTO public.roles (nombre, descripcion, permisos, activo)
   VALUES ('Usuario', 'Usuario básico del sistema', '{"leer": true}', true);
   ```

3. **Ejecuta el script del trigger**
   - Abre el archivo `supabase_auth_trigger.sql`
   - Copia todo el contenido
   - Pégalo en el SQL Editor de Supabase
   - Haz clic en "Run"

4. **Verifica que funciona**
   - Registra un nuevo usuario desde la app
   - En SQL Editor ejecuta:
   ```sql
   SELECT * FROM public.usuarios WHERE email = 'email@del.usuario';
   ```
   - Deberías ver el perfil creado automáticamente

## Qué Hace el Trigger

El trigger `on_auth_user_created`:
- Se ejecuta automáticamente después de cada registro
- Crea un registro en `public.usuarios` con:
  - `id` y `auth_user_id`: ID del usuario de Supabase Auth
  - `email`: Email del usuario
  - `nombre_completo`: Tomado de los metadatos del registro
  - `rol_id`: Rol por defecto ("Usuario")
  - `activo`: true

## Después de Implementar el Trigger

Una vez que el trigger esté activo, puedes actualizar el código de registro para volver a obtener el perfil de la base de datos:

```dart
// En auth_repository_impl.dart, método register()
// Reemplazar el código temporal por:

final authResponse = await remoteDatasource.register(
  email: email,
  password: password,
  nombreCompleto: nombreCompleto,
);

// Esperar un momento para que el trigger se ejecute
await Future.delayed(const Duration(milliseconds: 500));

// Obtener el perfil completo de la base de datos
final userProfile = await remoteDatasource.getUserProfile();
final usuarioModel = UsuarioModel.fromJson(userProfile);

await localDatasource.cacheUser(usuarioModel);
return Right(usuarioModel.toEntity());
```

## Notas Importantes

⚠️ **Solución Temporal Actual:**
- Los usuarios registrados tendrán un `rolId` placeholder
- No tendrán tienda asignada
- La app funcionará pero con permisos limitados

✅ **Con el Trigger de Base de Datos:**
- Los usuarios tendrán rol asignado automáticamente
- El perfil se crea completo desde el inicio
- Mejor experiencia de usuario

## Testing

Para probar el registro:

1. **Con la solución temporal (actual):**
   ```bash
   flutter run
   ```
   - Ve a la página de registro
   - Completa el formulario
   - El registro debería funcionar sin errores
   - El usuario podrá hacer login

2. **Con el trigger (recomendado):**
   - Ejecuta el script SQL en Supabase
   - Registra un nuevo usuario
   - Verifica en la base de datos que el perfil se creó
   - El usuario tendrá rol y permisos completos
