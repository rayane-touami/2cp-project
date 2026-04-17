//import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
//import 'package:compusmarket/screens/authentication/sign_in.dart';
//import 'package:compusmarket/screens/home/home_screen.dart';
//import 'package:compusmarket/screens/home/favorites_screen.dart';
import 'package:compusmarket/screens/chats/chats_out.dart';
import 'package:compusmarket/screens/home/home_screen.dart';
import 'package:compusmarket/screens/profiles/My_profile.dart';
import 'package:compusmarket/screens/home/add_new_product.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(fontFamily: 'Inter'),
      //inter font
      home: const HomeScreen(),
      // home: const AddNewProductScreen(),
      //home: SignInScreen(),
    );
  }
}
