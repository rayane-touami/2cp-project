import 'package:flutter/material.dart';
import 'package:compusmarket/screens/authentication/sign_in.dart';

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
      home: SignInScreen(),
    );
  }
}