import 'package:compusmarket/screens/authentication/ON_Boadring.dart';
import 'package:compusmarket/screens/home/home_screen.dart';
import 'package:compusmarket/services/profile_api_service.dart';
import 'package:compusmarket/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('auth_token') ?? '';
  final savedRefresh = prefs.getString('refresh_token') ?? '';
  ProfileApiService.token = savedToken;
  AuthService.accessToken = savedToken;
  AuthService.refreshToken = savedRefresh;

  if (savedRefresh.isNotEmpty) {
    await AuthService.refreshAccessToken(); 
  }
  
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
      home: OnBoadringScreen()
    );
  }
}