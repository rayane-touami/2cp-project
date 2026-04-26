
import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
import 'package:compusmarket/screens/profiles/His_profile.dart';
import 'package:compusmarket/screens/profiles/My_profile.dart';
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
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      //home:HomeScreen(),
      home: MyProfileScreen(), // change to HomeScreen() or SignInScreen() whenever you want
    );
  }
}