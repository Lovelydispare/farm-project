import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../services/cart_service.dart';
import '../pages/product_details.dart';

class ProductCard extends StatelessWidget {
  final ProductsModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProductDetailsPage(),
                ),
            );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product Image
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.primaryContainer,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Product Information
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Category
                    Text(
                      product.categoryId.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Product Name
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // Price and Add Button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'KSh ${product.price.toStringAsFixed(0)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Material(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                                context.read<CartService>().addProduct(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                    content: Text("${product.name} added to cart"),
                                    ),
                                );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: theme.colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}