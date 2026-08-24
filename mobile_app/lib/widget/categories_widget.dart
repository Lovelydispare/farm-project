import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/products_service.dart';
import '../models/products_model.dart';

class CategoriesWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoriesWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    return SizedBox(
      height: 42,
      child: Consumer<ProductService>(
        builder: (context, productService, child) {
          
          final categories = [
            CategoryModel( id: 0, name: 'All', ),
            ...productService.categories,
          ];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = category.name == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category.name),
                  selected: selected,
                  onSelected: (_) {
                    onCategorySelected(category.name);
                  },
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}