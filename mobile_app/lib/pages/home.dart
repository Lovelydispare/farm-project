import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      
    });
  }
  @override
  Widget build(BuildContext context) {
        return Text('Home');

    
  }
}