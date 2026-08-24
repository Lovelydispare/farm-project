import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// services
import '../services/products_service.dart';

// widgets and pages
import '../widget/product_card.dart';
import '../widget/app_bar.dart';
import '../widget/categories_widget.dart';
import '../widget/search_bar.dart';

class ProductsPage extends StatefulWidget{
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsState();
}

class _ProductsState extends State<ProductsPage> {

  String searchText = '';
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductService>().fetchProducts();
      context.read<ProductService>().fetchCategories();
    });
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBarWidget(title: 'Products'),

          body: Consumer<ProductService>(
            builder: (context, productService, child){
              if(productService.isLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              // filtter products
              final products = productService.products.where((product){
                
                final matchsSearch =
                  product.name
                    .toLowerCase()
                    .contains(searchText.toLowerCase());

                final matchsCategory =
                  selectedCategory == 'All' ||
                  product.categoryName == selectedCategory;

                return matchsSearch && matchsCategory;

              }).toList();

              return Column(
                children: [

                  // Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB( 16, 8, 16, 12, ),
                    child: SearchBox(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),

                  // Categories
                  Padding(
                    padding: const EdgeInsets.only( left: 16, right: 16, bottom: 16, ),
                    child: CategoriesWidget(
                      selectedCategory: selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  ),

                  // Products
                  Expanded(
                    child: products.isEmpty
                        ? const Center( child: Text( 'No produce found', ), )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB( 16, 0, 16, 20, ),
                            itemCount: products.length,
                            gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.68,
                              ),
                              itemBuilder: (context, index) {

                                final product = products[index];

                                return ProductCard(
                                  product: product,
                                );
                              },
                          ),
                  ),
                ],
              );
            
            }
            )
        );

    
  }
}