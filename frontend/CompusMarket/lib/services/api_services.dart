import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000/api/auth';

class ApiService {
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
      return jsonDecode(response.body);
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

static Future<void> register(String email, String password, String fullName, String universityId) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'full_name': fullName,
      'university_id': universityId,
    }),
  );
  if (response.statusCode != 201) {
    throw Exception('Register failed: ${response.body}');
  }
}
}
