import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import 'menu_card.dart';

class MenuGrid extends StatelessWidget {
  final List<MenuItem> items;
  final Function(MenuItem) onItemTap;

  const MenuGrid({
    Key? key,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuCard(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}
