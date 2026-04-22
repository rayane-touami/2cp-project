import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UniversityService {
  /// 8. Home page — Get universities (for the filter)
  static Future<List<dynamic>> getUniversities() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/universities/'), // ← fixed
      headers: await ApiConfig.getHeaders(),
    );

    print('Universities status: ${response.statusCode}');
    print('Universities body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load universities: ${response.body}');
    }
  }
}
