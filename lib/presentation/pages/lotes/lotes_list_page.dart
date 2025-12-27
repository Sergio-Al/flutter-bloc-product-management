import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/permissions/permission_helper.dart';
import '../../../domain/entities/lote.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/lote/lote_bloc.dart';
import '../../blocs/lote/lote_event.dart';
import '../../blocs/lote/lote_state.dart';
import 'lotes_detail_page.dart';
import 'lotes_form_page.dart';

// Filter options enum
enum LoteFilter {
  conStock('Con Stock', Icons.inventory, Colors.blue),
  todos('Todos', Icons.all_inclusive, Colors.grey),
  porVencer('Por Vencer', Icons.warning_amber, Colors.orange),
  vencidos('Vencidos', Icons.error, Colors.red),
  vacios('Vacíos', Icons.inventory_2_outlined, Colors.grey),
  conCertificado('Con Certificado', Icons.verified, Colors.blue);

  final String label;
  final IconData icon;
  final Color color;
  const LoteFilter(this.label, this.icon, this.color);
}

// View mode enum
enum ViewMode { list, grid, compact }

class LotesListPage extends StatefulWidget {
  const LotesListPage({Key? key}) : super(key: key);

  @override
  State<LotesListPage> createState() => _LotesListPageState();
}

class _LotesListPageState extends State<LotesListPage> {
  LoteFilter _currentFilter = LoteFilter.conStock;
  ViewMode _viewMode = ViewMode.list;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadLotes();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLotes() {
    switch (_currentFilter) {
      case LoteFilter.conStock:
        context.read<LoteBloc>().add(const LoadLotesConStock());
        break;
      case LoteFilter.vencidos:
        context.read<LoteBloc>().add(const LoadLotesVencidos());
        break;
      case LoteFilter.porVencer:
        context.read<LoteBloc>().add(const LoadLotesPorVencer());
        break;
      case LoteFilter.vacios:
        context.read<LoteBloc>().add(const LoadLotesVacios());
        break;
      case LoteFilter.conCertificado:
        context.read<LoteBloc>().add(const LoadLotesConCertificado());
        break;
      case LoteFilter.todos:
        context.read<LoteBloc>().add(const LoadLotes());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(context),
          _buildStatsSummary(context),
          Expanded(child: _buildLotesList(context)),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Lotes'),
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(_getViewModeIcon()),
          onPressed: _toggleViewMode,
          tooltip: 'Cambiar vista',
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortOptions(context),
          tooltip: 'Ordenar',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.file_download),
                title: Text('Exportar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'bulk',
              child: ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Carga masiva'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'stats',
              child: ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Estadísticas'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por número de lote o factura...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadLotes();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) => setState(() {}),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<LoteBloc>().add(SearchLotes(value));
          }
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: LoteFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = LoteFilter.values[index];
          final isSelected = _currentFilter == filter;

          return FilterChip(
            selected: isSelected,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  filter.icon,
                  size: 18,
                  color: isSelected ? Colors.white : filter.color,
                ),
                const SizedBox(width: 6),
                Text(filter.label),
              ],
            ),
            selectedColor: filter.color,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (selected) {
              setState(() => _currentFilter = filter);
              _loadLotes();
            },
          );
        },
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return BlocBuilder<LoteBloc, LoteState>(
      builder: (context, state) {
        if (state is LoteLoaded || state is LoteOperationSuccess) {
          final lotes = state is LoteLoaded
              ? state.lotes
              : (state as LoteOperationSuccess).lotes;

          final vencidos = lotes.where((l) => l.isExpired).length;
          final porVencer = lotes.where((l) => l.isNearExpiration).length;
          final conStock = lotes.where((l) => !l.isEmpty).length;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.inventory,
                    label: 'Con Stock',
                    value: conStock.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.warning_amber,
                    label: 'Por Vencer',
                    value: porVencer.toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.error,
                    label: 'Vencidos',
                    value: vencidos.toString(),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLotesList(BuildContext context) {
    return BlocConsumer<LoteBloc, LoteState>(
      listener: (context, state) {
        if (state is LoteOperationSuccess) {
          _showSuccessSnackbar(context, state.message);
        }
        if (state is LoteError) {
          _showErrorSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is LoteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is LoteLoaded || state is LoteOperationSuccess) {
          final lotes = state is LoteLoaded
              ? state.lotes
              : (state as LoteOperationSuccess).lotes;

          if (lotes.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadLotes();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildViewByMode(context, lotes),
          );
        }

        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildViewByMode(BuildContext context, List<Lote> lotes) {
    switch (_viewMode) {
      case ViewMode.list:
        return _buildListView(context, lotes);
      case ViewMode.grid:
        return _buildGridView(context, lotes);
      case ViewMode.compact:
        return _buildCompactView(context, lotes);
    }
  }

  Widget _buildListView(BuildContext context, List<Lote> lotes) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: lotes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _LoteListCard(
          lote: lotes[index],
          onTap: () => _navigateToDetail(context, lotes[index].id),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, List<Lote> lotes) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: lotes.length,
      itemBuilder: (context, index) {
        return _LoteGridCard(
          lote: lotes[index],
          onTap: () => _navigateToDetail(context, lotes[index].id),
        );
      },
    );
  }

  Widget _buildCompactView(BuildContext context, List<Lote> lotes) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: lotes.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return _LoteCompactCard(
          lote: lotes[index],
          onTap: () => _navigateToDetail(context, lotes[index].id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay lotes',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Crea tu primer lote para comenzar\na gestionar tu inventario',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  /// Build create button for empty state with permission check
  Widget _buildCreateButton(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    // Only show create button if user can create lotes
    if (!PermissionHelper.canCreateLote(userRole)) {
      return const SizedBox.shrink();
    }

    return ElevatedButton.icon(
      onPressed: () => _navigateToCreate(context),
      icon: const Icon(Icons.add),
      label: const Text('Crear Lote'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.rolNombre;
    }

    // Only show FAB if user can create lotes (Gerente and Almacenero)
    if (!PermissionHelper.canCreateLote(userRole)) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreate(context),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo Lote'),
      elevation: 4,
    );
  }

  // Helper methods
  IconData _getViewModeIcon() {
    switch (_viewMode) {
      case ViewMode.list:
        return Icons.grid_view;
      case ViewMode.grid:
        return Icons.view_agenda;
      case ViewMode.compact:
        return Icons.view_list;
    }
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = ViewMode.values[(_viewMode.index + 1) % ViewMode.values.length];
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ordenar por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 24),
          _SortOption(
            icon: Icons.numbers,
            title: 'Número de lote',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.date_range,
            title: 'Fecha de vencimiento',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.inventory,
            title: 'Stock disponible',
            onTap: () => Navigator.pop(context),
          ),
          _SortOption(
            icon: Icons.receipt,
            title: 'Número de factura',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'export':
        _showSnackbar(context, 'Exportar funcionalidad próximamente');
        break;
      case 'bulk':
        _showSnackbar(context, 'Carga masiva próximamente');
        break;
      case 'stats':
        _showSnackbar(context, 'Estadísticas próximamente');
        break;
    }
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoteBloc>(),
          child: const LotesFormPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadLotes();
    }
  }

  void _navigateToDetail(BuildContext context, String loteId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoteBloc>()..add(LoadLoteById(loteId)),
          child: LoteDetailPage(loteId: loteId),
        ),
      ),
    );

    if (result == true && mounted) {
      _loadLotes();
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Sort option widget
class _SortOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// List view card
class _LoteListCard extends StatelessWidget {
  final Lote lote;
  final VoidCallback onTap;

  const _LoteListCard({
    required this.lote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getLoteStatus();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(status.icon, color: status.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                lote.numeroLote,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (lote.hasCertificate)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified, size: 14, color: Colors.blue),
                                    SizedBox(width: 4),
                                    Text(
                                      'Certificado',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stock: ${lote.cantidadActual} / ${lote.cantidadInicial}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: lote.cantidadInicial > 0
                      ? lote.cantidadActual / lote.cantidadInicial
                      : 0,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(status.color),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (lote.fechaVencimiento != null)
                    Row(
                      children: [
                        Icon(Icons.event, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Vence: ${_formatDate(lote.fechaVencimiento!)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: status.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: status.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _LoteStatus _getLoteStatus() {
    if (lote.isExpired) {
      return _LoteStatus(
        color: Colors.red,
        icon: Icons.error,
        label: 'Vencido',
      );
    } else if (lote.isNearExpiration) {
      return _LoteStatus(
        color: Colors.orange,
        icon: Icons.warning_amber,
        label: 'Por vencer',
      );
    } else if (lote.isEmpty) {
      return _LoteStatus(
        color: Colors.grey,
        icon: Icons.inventory_2_outlined,
        label: 'Vacío',
      );
    }
    return _LoteStatus(
      color: Colors.green,
      icon: Icons.check_circle,
      label: 'Disponible',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

// Grid view card
class _LoteGridCard extends StatelessWidget {
  final Lote lote;
  final VoidCallback onTap;

  const _LoteGridCard({
    required this.lote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getLoteStatus();
    final percentage = lote.cantidadInicial > 0
        ? (lote.cantidadActual / lote.cantidadInicial * 100).round()
        : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(status.icon, size: 48, color: status.color),
                  ),
                  if (lote.hasCertificate)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.verified, size: 16, color: Colors.white),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: lote.cantidadInicial > 0
                            ? lote.cantidadActual / lote.cantidadInicial
                            : 0,
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(status.color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lote.numeroLote,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.inventory, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${lote.cantidadActual}/${lote.cantidadInicial}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: status.color,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (lote.fechaVencimiento != null)
                      Text(
                        _formatDate(lote.fechaVencimiento!),
                        style: TextStyle(
                          fontSize: 11,
                          color: status.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: status.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _LoteStatus _getLoteStatus() {
    if (lote.isExpired) {
      return _LoteStatus(
        color: Colors.red,
        icon: Icons.error,
        label: 'Vencido',
      );
    } else if (lote.isNearExpiration) {
      return _LoteStatus(
        color: Colors.orange,
        icon: Icons.warning_amber,
        label: 'Por vencer',
      );
    } else if (lote.isEmpty) {
      return _LoteStatus(
        color: Colors.grey,
        icon: Icons.inventory_2_outlined,
        label: 'Vacío',
      );
    }
    return _LoteStatus(
      color: Colors.green,
      icon: Icons.check_circle,
      label: 'Disponible',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

// Compact view card
class _LoteCompactCard extends StatelessWidget {
  final Lote lote;
  final VoidCallback onTap;

  const _LoteCompactCard({
    required this.lote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getLoteStatus();

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: status.color.withOpacity(0.1),
        child: Icon(status.icon, color: status.color, size: 20),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              lote.numeroLote,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          if (lote.hasCertificate)
            const Icon(Icons.verified, size: 16, color: Colors.blue),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              'Stock: ${lote.cantidadActual}/${lote.cantidadInicial}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          if (lote.fechaVencimiento != null)
            Text(
              _formatDate(lote.fechaVencimiento!),
              style: TextStyle(
                fontSize: 11,
                color: status.color,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: status.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status.label,
          style: TextStyle(
            fontSize: 10,
            color: status.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _LoteStatus _getLoteStatus() {
    if (lote.isExpired) {
      return _LoteStatus(
        color: Colors.red,
        icon: Icons.error,
        label: 'Vencido',
      );
    } else if (lote.isNearExpiration) {
      return _LoteStatus(
        color: Colors.orange,
        icon: Icons.warning_amber,
        label: 'Por vencer',
      );
    } else if (lote.isEmpty) {
      return _LoteStatus(
        color: Colors.grey,
        icon: Icons.inventory_2_outlined,
        label: 'Vacío',
      );
    }
    return _LoteStatus(
      color: Colors.green,
      icon: Icons.check_circle,
      label: 'Disponible',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

// Lote status helper class
class _LoteStatus {
  final Color color;
  final IconData icon;
  final String label;

  _LoteStatus({
    required this.color,
    required this.icon,
    required this.label,
  });
}
