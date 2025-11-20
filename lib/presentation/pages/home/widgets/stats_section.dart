import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/producto/producto_bloc.dart';
import '../../../blocs/producto/producto_state.dart';
import '../../../blocs/movimiento/movimiento_bloc.dart';
import '../../../blocs/movimiento/movimiento_state.dart';
import 'stat_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Productos count
        Expanded(
          child: BlocBuilder<ProductoBloc, ProductoState>(
            builder: (context, state) {
              String value = '---';
              if (state is ProductoLoaded) {
                value = state.productos.length.toString();
              } else if (state is ProductoEmpty) {
                value = '0';
              }
              return StatCard(
                icon: Icons.inventory_2,
                label: 'Productos',
                value: value,
                color: Colors.blue,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Movimientos count
        Expanded(
          child: BlocBuilder<MovimientoBloc, MovimientoState>(
            builder: (context, state) {
              String value = '---';
              if (state is MovimientosLoaded) {
                value = state.movimientos.length.toString();
              }
              return StatCard(
                icon: Icons.trending_up,
                label: 'Movimientos',
                value: value,
                color: Colors.green,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Alertas (placeholder)
        const Expanded(
          child: StatCard(
            icon: Icons.warning_amber,
            label: 'Alertas',
            value: '---',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
