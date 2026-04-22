import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  // Replace with your actual IP if testing on physical device (e.g. 'http://192.168.1.X:8000')
  // static const String baseUrl = 'http://192.168.1.X:8000/api';
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Retrieves the Bearer token from SharedPreferences.
  /// If you haven't implemented login token saving yet, you can temporarily return a hardcoded token here.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
    // For testing without login, comment above and uncomment below:
    // return 'eyJ...';
  }

  /// Helper to get generic headers
  static Future<Map<String, String>> getHeaders({
    bool isMultipart = false,
  }) async {
    final token = await getToken();
    final headers = <String, String>{};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }
}
