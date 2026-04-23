import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class FavoriteService {
  /// 11. Favorite page — Get favorites
  static Future<List<dynamic>> getFavorites() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/favorites/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites: ${response.body}');
    }
  }

  /// 12. Favorite page — Add to favorites
  static Future<Map<String, dynamic>> addFavorite(int announcementId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/favorites/'),
      headers: await ApiConfig.getHeaders(),
      body: jsonEncode({'announcement_id': announcementId}),
    );

    // The API responds with 200 or 201 typically
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add favorite: ${response.body}');
    }
  }

  /// 13. Favorite page — Remove from favorites
  static Future<void> removeFavorite(int favoriteId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/favorites/$favoriteId/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove favorite: ${response.body}');
    }
  }

  /// 14. Favorite page — Check which are favorited (bulk)
  static Future<Map<String, dynamic>> checkFavorites(List<int> announcementIds) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/favorites/check/'),
      headers: await ApiConfig.getHeaders(),
      body: jsonEncode({'announcement_ids': announcementIds}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check favorites: ${response.body}');
    }
  }
}
