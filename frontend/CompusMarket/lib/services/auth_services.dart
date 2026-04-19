import 'dart:convert';
import 'package:http/http.dart' as http;

 const String baseUrl = 'http://10.0.2.2:8000/api/auth';

class AuthService {
    static String accessToken = '';
  static String refreshToken = '';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

     if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      accessToken = data['access'];
      refreshToken = data['refresh'];
      return data;
    } else {
      throw Exception('Login failed');
    }
  }
 static Future<List<dynamic>> getUniversities() async {
  final response = await http.get(Uri.parse('$baseUrl/universities/'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load universities');
  }
}

static Future<void> register(String email, String password, String fullName, String universityId,String phoneNumber,) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'full_name': fullName,
      'university_id': universityId,
       'phone_number': phoneNumber,
    }),
  );
    print('📦 Register response: ${response.body}'); 
  if (response.statusCode != 201) {
    throw Exception('Register failed: ${response.body}');
  }
}

static Future<Map<String, dynamic>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/me/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Failed to get user info');
  }

static Future<void> logout() async {
    await http.post(
      Uri.parse('$baseUrl/logout/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refresh': refreshToken}),
    );
    accessToken = '';
    refreshToken = '';
  }

  static Future<void> verifyEmail(String email, String code) async {
  final response = await http.post(
    Uri.parse('$baseUrl/verify-email/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'code': code}),
  );
  if (response.statusCode != 200) {
    throw Exception('Invalid or expired code');
  }
  final data = jsonDecode(response.body);
  accessToken = data['access'];
  refreshToken = data['refresh'];
}

static Future<void> forgotPassword(String email) async {
  final response = await http.post(
    Uri.parse('$baseUrl/forgot-password/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
  if (response.statusCode != 200) {
    throw Exception('Email not found');
  }
}

static Future<void> resetPassword(String email, String code, String newPassword) async {
  final response = await http.post(
    Uri.parse('$baseUrl/reset-password/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'code': code,
      'new_password': newPassword,
    }),
  );
  if (response.statusCode != 200) {
    throw Exception('Reset failed');
  }
}

}
