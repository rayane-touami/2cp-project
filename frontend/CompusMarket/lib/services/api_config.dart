import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_services.dart';
import 'profile_api_service.dart';

class ApiConfig {
  static const String baseUrl = 'https://twocp-project-1-gtam.onrender.com/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _refreshIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString('refresh_token') ?? AuthService.refreshToken;
    if (refresh.isEmpty) return;

    final response = await http.post(
      Uri.parse('$baseUrl/auth/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['access'];
      await prefs.setString('auth_token', newToken);
      AuthService.accessToken = newToken;
      ProfileApiService.token = newToken;
    } else {
      // Fully expired → clear
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      AuthService.accessToken = '';
      AuthService.refreshToken = '';
    }
  }

  static Future<Map<String, String>> getHeaders({
    bool isMultipart = false,
  }) async {
    String? token = await getToken();

    // If token is missing, try to refresh
    if (token == null || token.isEmpty) {
      await _refreshIfNeeded();
      token = await getToken();
    }

    final headers = <String, String>{};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
  }
}