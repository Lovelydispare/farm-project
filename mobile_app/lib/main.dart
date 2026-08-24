import 'package:flutter/material.dart';
import 'package:mobile_app/services/cart_service.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:mobile_app/widget/bottom_nav.dart';
import 'package:provider/provider.dart';

//services
import 'services/products_service.dart';
import 'services/auth_service.dart';
import 'services/order_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(), 
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersService(), 
        ),
        ChangeNotifierProvider(
          create: (_) => CartService(), 
        ),
      ],
      child: const MyApp()
    )
    
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shamba Online',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen()
    );
  }
}
