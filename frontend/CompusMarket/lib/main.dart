//import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
//import 'package:compusmarket/screens/authentication/ON_Boadring2.dart';
//import 'package:compusmarket/screens/authentication/ON_Boadring3.dart';
//import 'package:compusmarket/screens/chats/chats_out.dart';
import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
import 'package:flutter/material.dart';
// import 'package:compusmarket/screens/authentication/sign_in.dart';

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
      home:OnBoadringScreen(),
    );
  }
}