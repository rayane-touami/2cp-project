import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class CategoryService {
  /// 7. Home page — Get categories (for the chips)
  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/categories/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load categories: ${response.body}');
    }
  }
}
