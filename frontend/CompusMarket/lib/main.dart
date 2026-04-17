import 'package:compusmarket/screens/home/add_new_product.dart';
import 'package:flutter/material.dart';
import 'package:compusmarket/screens/authentication/sign_in.dart';
import 'screens/home/home_screen.dart';
import 'package:compusmarket/screens/home/favorites_screen.dart';
//import 'package:compusmarket/screens/home/add_new_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompusMarket',
      debugShowCheckedModeBanner: false,
      //inter font
      theme: ThemeData(fontFamily: 'Inter'),
      home: const HomeScreen(),
      // home: const AddNewProductScreen(),
      //home: SignInScreen(),
    );
  }
}
