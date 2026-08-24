import 'package:flutter/material.dart';
import 'package:mobile_app/pages/products.dart';
import '../pages/home.dart';
import '../pages/cart.dart';
import '../pages/profile.dart';


class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override 
  State<MainScreen> createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen>{
  final pages =  [
    HomePage(),
    ProductsPage(),
    CartPage(),
    ProfilePage(),

  ];
  int currentIndex = 0;

  @override 
  Widget build(BuildContext context){
   // final cartService = context.watch<CartService>();

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index){
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
            ),
            
            NavigationDestination(
            icon: Icon(Icons.local_grocery_store_outlined),
            selectedIcon: Icon(Icons.local_grocery_store),
            label: "Products",
            ),

            NavigationDestination(
            icon: Badge(
            isLabelVisible: false,
            label: Text('Cart'),
            child: Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: false,
              label: Text('Cart'),
              child: Icon(Icons.shopping_cart),
            ),
            label: "Cart",
            ),
           
            NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
            ),
            
        ],
      ),
    );
  }

}