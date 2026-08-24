import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//pages and widgets
import '../widget/search_bar.dart';
import '../widget/product_card.dart';
import '../widget/app_bar.dart';
import 'products.dart';
import 'product_details.dart';

// services
import '../services/products_service.dart';
import '../services/cart_service.dart';
import '../models/products_model.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductService>().fetchProducts();
    });
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: const AppBarWidget(title: 'Shamba Online'),

          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Greeting(),
                SizedBox(height: 20),
                SearchBox(
                  onChanged: (value) {}, 
                ),
                SizedBox(height: 20),
                Banner(),
                SizedBox(height: 20),
                PopularProducts(),
                SizedBox(height: 20),
                Consumer<ProductService>(
                  builder: (context, productService, child){
                    if (productService.products.isEmpty){
                      return const SizedBox();
                    }
                    final product = productService.products.first;

                    return featuredProductCard(context, product, );
                  },
                )
                
              ],
            ),
          )
        );

    
  }
}

class Greeting extends StatelessWidget{
  const Greeting({super.key});

  String getGreeting(){
    final hour = DateTime.now().hour;

    if(hour < 12){
      return "Good Morning 👋";
    }else if( hour < 17){
      return "Good Afternoon 👋";
    }else{
      return "Good Evening 👋";
    }
  }

  @override  
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getGreeting(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'What would you like today?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}

class Banner extends StatelessWidget {
    const Banner({super.key});
    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
                children: [
                const Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                        'Fresh From The Farm',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                        ),
                        ),
                        SizedBox(height: 8),
                        Text('Fresh produce delivered to your doorstep'),
                    ],
                    ),
                ),

                FilledButton(
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProductsPage(),
                            ),
                        );
                    },
                    child: const Text('Shop Now'),
                ),
                ],
            ),
        );  
    }
}

class PopularProducts extends StatelessWidget {
    const PopularProducts({super.key});
    @override
    Widget build(BuildContext context) {
        return SizedBox(
            height: 280,
            child: Consumer<ProductService>(
                builder: (context, productService, child) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productService.products.length,
                    itemBuilder: (context, index) {
                    final product = productService.products[index];

                    return SizedBox(
                        width: 180,
                        child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ProductCard(
                            product: product,
                        ),
                        ),
                    );
                    },
                );
                },
            ),
        );  
    }
}

Widget featuredProductCard(BuildContext context, ProductsModel product,) {
    final theme = Theme.of(context);
    
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
                onTap: () {
                    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProductDetailsPage(),
                ),
            );
                },
                child: Row(
                    children: [
                        SizedBox(width: 120,
                            height: 140,
                            child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                    color: theme.colorScheme.primaryContainer,
                                    child: Icon(
                                        Icons.eco,
                                        size: 50,
                                        color: theme.colorScheme.primary,
                                    ),
                                    );
                                },
                            ),
                        ),
                        
                        Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                                'Fresh Produce Today',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                                'Freshly harvested and available now',
                            ),
                            
                        const SizedBox(height: 10),

                        Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                            children: [
                                Text(
                                    'KSh ${product.price.toStringAsFixed(0)}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                            
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                        context.read<CartService>().addProduct(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                            content: Text("${product.name} added to cart"),
                                            ),
                                        );
                                    },
                                    icon: const Icon(Icons.add_circle),
                                ),
                            ]
                        ),
                        ],
                        ),
                        ),
                    ],
                ),
            ),
        ),
    );  
}
