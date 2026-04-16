//import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
//import 'package:compusmarket/screens/authentication/ON_Boadring2.dart';
//import 'package:compusmarket/screens/authentication/ON_Boadring3.dart';
//import 'package:compusmarket/screens/chats/chats_out.dart';
import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
// import 'package:compusmarket/screens/authentication/sign_in.dart';

void main() {
=======
import 'package:compusmarket/screens/authentication/sign_in.dart';
import 'screens/home/home_screen.dart';
import 'package:compusmarket/screens/home/favorites_screen.dart';void main() {
>>>>>>> 5471524f10bc638978400f30eaa9a826d9da8d4a
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompusMarket',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home:OnBoadringScreen(),
=======
      //inter font
      theme: ThemeData(
        fontFamily: 'Inter', 
      ),
      home: const HomeScreen(),
      //home: SignInScreen(),
>>>>>>> 5471524f10bc638978400f30eaa9a826d9da8d4a
    );
  }
}
