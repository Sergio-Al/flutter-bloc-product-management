# Home Page - Clean Architecture

Esta carpeta contiene la página de inicio (Home) del sistema, refactorizada siguiendo los principios de **Clean Architecture** y **Material Design**.

## 📁 Estructura

```
home/
├── home_page.dart              # Widget principal (StatefulWidget)
├── models/                     # Modelos de datos
│   └── menu_item.dart         # Modelo para items del menú
├── utils/                      # Utilidades y configuraciones
│   ├── menu_config.dart       # Configuración centralizada del menú
│   └── role_utils.dart        # Utilidades para manejo de roles
└── widgets/                    # Widgets reutilizables
    ├── home_app_bar.dart      # AppBar personalizada
    ├── home_drawer.dart       # Drawer de navegación
    ├── menu_card.dart         # Tarjeta individual de menú
    ├── menu_grid.dart         # Grid de items del menú
    ├── stat_card.dart         # Tarjeta de estadística
    ├── stats_section.dart     # Sección de estadísticas
    └── welcome_card.dart      # Tarjeta de bienvenida

```

## 🎯 Componentes Principales

### HomePage (`home_page.dart`)
- Widget principal que orquesta toda la página
- Usa **StatefulWidget** para manejar el ciclo de vida
- Carga datos iniciales (productos y movimientos) al montarse
- Gestiona la navegación y sincronización

### Models

#### MenuItem (`models/menu_item.dart`)
```dart
class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isImplemented;
  final List<String> allowedRoles;
}
```

### Utils

#### RoleUtils (`utils/role_utils.dart`)
- `getRoleNameFromId()`: Mapea UUID de rol a nombre
- `getRoleIcon()`: Retorna icono según rol
- `getRoleColor()`: Retorna color según rol

#### MenuConfig (`utils/menu_config.dart`)
- `menuItems`: Lista estática de todos los items del menú
- `getMenuItemsForRole()`: Filtra items según rol del usuario

### Widgets

#### HomeAppBar (`widgets/home_app_bar.dart`)
AppBar personalizada con acciones:
- Notificaciones
- Sincronización
- Configuración
- Cerrar sesión

#### WelcomeCard (`widgets/welcome_card.dart`)
Muestra información del usuario:
- Avatar con inicial del nombre
- Nombre completo
- Badge de rol con color e icono
- Email

#### StatsSection (`widgets/stats_section.dart`)
Sección de estadísticas usando **BlocBuilder**:
- Productos (de ProductoBloc)
- Movimientos (de MovimientoBloc)
- Alertas (placeholder)

#### StatCard (`widgets/stat_card.dart`)
Tarjeta individual de estadística:
- Icono con color temático
- Valor numérico destacado
- Label descriptivo

#### MenuGrid (`widgets/menu_grid.dart`)
Grid de 2 columnas con items del menú:
- Responsive
- Scroll deshabilitado (padre maneja scroll)

#### MenuCard (`widgets/menu_card.dart`)
Tarjeta individual de menú:
- Icono grande
- Título y subtítulo
- Badge "Próximo" para items no implementados
- Efecto ripple al tocar

#### HomeDrawer (`widgets/home_drawer.dart`)
Drawer de navegación lateral:
- Header con información del usuario
- Lista de items filtrados por rol
- Acciones de configuración y logout

## 🎨 Mejoras de Material Design

### 1. **Elevation & Shadows**
- Uso consistente de `elevation` en Cards
- Sombras sutiles para profundidad visual

### 2. **Spacing & Layout**
- Padding y margin consistentes (16.0, 12.0, 8.0)
- Uso de `SizedBox` para separación vertical/horizontal
- Grid con aspect ratio 1.0 para cards cuadradas

### 3. **Typography**
- Uso de `Theme.of(context).textTheme`
- Jerarquía clara: titleLarge, titleMedium, bodyMedium, bodySmall
- Font weights apropiados (bold para títulos)

### 4. **Color System**
- Colores temáticos por rol (rojo, azul, verde, naranja)
- Uso de `Colors.grey[600]` para texto secundario
- `Theme.of(context).primaryColor` para elementos principales

### 5. **Interactividad**
- `InkWell` con `borderRadius` para efectos ripple
- Tooltips en botones del AppBar
- Feedback visual en todas las interacciones

### 6. **Responsive**
- `SafeArea` para respetar notches y barras del sistema
- `SingleChildScrollView` para contenido que puede exceder pantalla
- Grid adaptable con `shrinkWrap`

## 🔄 Flujo de Datos

```
HomePage (StatefulWidget)
    ↓
initState() → Carga datos de BLoCs
    ↓
BlocBuilder<AuthBloc> → Obtiene usuario autenticado
    ↓
RoleUtils → Mapea rolId a nombre de rol
    ↓
MenuConfig → Filtra items por rol
    ↓
Renderiza UI con widgets especializados
```

## 🎯 Ventajas de esta Estructura

### ✅ Mantenibilidad
- Cada widget tiene una única responsabilidad
- Fácil encontrar y modificar componentes específicos
- Código más legible y testeable

### ✅ Reutilización
- Widgets independientes reutilizables en otras páginas
- Lógica de roles centralizada
- Configuración de menú en un solo lugar

### ✅ Escalabilidad
- Agregar nuevos items al menú es trivial (MenuConfig)
- Nuevos roles: solo actualizar RoleUtils
- Nuevas estadísticas: agregar BlocBuilder en StatsSection

### ✅ Testing
- Widgets pequeños más fáciles de testear
- Utils con funciones puras testeables unitariamente
- Mocks más simples para widgets individuales

## 🚀 Cómo Agregar Nuevas Features

### Agregar un nuevo item al menú:
```dart
// En utils/menu_config.dart
MenuItem(
  icon: Icons.new_feature,
  title: 'Nueva Feature',
  subtitle: 'Descripción',
  route: '/nueva-feature',
  isImplemented: true,
  allowedRoles: ['Administrador'],
),
```

### Agregar una nueva estadística:
```dart
// En widgets/stats_section.dart
Expanded(
  child: BlocBuilder<NuevoBloc, NuevoState>(
    builder: (context, state) {
      String value = '---';
      if (state is NuevoLoaded) {
        value = state.items.length.toString();
      }
      return StatCard(
        icon: Icons.new_icon,
        label: 'Nuevo',
        value: value,
        color: Colors.purple,
      );
    },
  ),
),
```

### Agregar un nuevo rol:
```dart
// En utils/role_utils.dart
case '00000000-0000-0000-0000-000000000005':
  return 'SuperAdmin';
```

## 📝 Notas

- **StatefulWidget**: Usado para `initState()` y manejo del ciclo de vida
- **BlocBuilder**: Reactivo a cambios en ProductoBloc y MovimientoBloc
- **mounted**: Verificado antes de operaciones async para evitar memory leaks
- **const**: Usado extensivamente para optimización de performance
- **Key**: Agregado a widgets para mejor identificación en el árbol de widgets

## 🔍 Debug

Para debugging, las siguientes líneas pueden ser útiles:
```dart
print('🔍 DEBUG - Usuario rolId: ${state.user.rolId}');
print('🔍 DEBUG - Rol detectado: $roleName');
print('🔍 DEBUG - Items filtrados: ${allowedMenuItems.length}');
```

---

**Última actualización**: Noviembre 2025  
**Versión**: 2.0 (Refactorizado con Clean Architecture)
