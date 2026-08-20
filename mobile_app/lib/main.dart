import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:mobile_app/widget/bottom_nav.dart';

void main() {
  runApp(const MyApp());
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
