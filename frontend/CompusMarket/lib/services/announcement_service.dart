import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AnnouncementService {
  /// 1. Home page — Announcements feed
  /// 2,3,4,5,6 — Apply filters dynamically
  static Future<Map<String, dynamic>> getAnnouncements({
    int page = 1,
    String? search,
    int? categoryId,
    int? universityId,
    double? minPrice,
    double? maxPrice,
  }) async {
    final queryParams = <String, String>{'page': page.toString()};
    
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null) queryParams['category'] = categoryId.toString();
    if (universityId != null) queryParams['university'] = universityId.toString();
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();

    final uri = Uri.parse('${ApiConfig.baseUrl}/announcements/').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: await ApiConfig.getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load announcements: ${response.body}');
    }
  }

  /// 9. Home page — Nearby announcements
  static Future<List<dynamic>> getNearbyAnnouncements(double lat, double lon, {double radius = 50.0}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/announcements/nearby/').replace(queryParameters: {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'radius': radius.toString(),
    });
    final response = await http.get(uri, headers: await ApiConfig.getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load nearby announcements: ${response.body}');
    }
  }

  /// 10. Announcement detail page
  static Future<Map<String, dynamic>> getAnnouncementDetails(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/announcements/$id/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load announcement details: ${response.body}');
    }
  }

  /// 19. My announcements page
  static Future<List<dynamic>> getMyAnnouncements() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/announcements/my/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load my announcements: ${response.body}');
    }
  }

  
  /// 16. Add announcement — Update
  static Future<Map<String, dynamic>> updateAnnouncement(
    int id,
    Map<String, String> data,
    List<String>? photoPaths, 
  ) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/announcements/$id/update/');
    var request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(await ApiConfig.getHeaders(isMultipart: true))
      ..fields.addAll(data);

    if (photoPaths != null) {
      for (String path in photoPaths) {
        request.files.add(await http.MultipartFile.fromPath('photos', path));
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update announcement: ${response.body}');
    }
  }

  /// 17. Add announcement — Change status
  static Future<Map<String, dynamic>> changeStatus(int id, String status) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/announcements/$id/status/'),
      headers: await ApiConfig.getHeaders(),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to change status: ${response.body}');
    }
  }

  /// 18. Add announcement — Archive
  static Future<Map<String, dynamic>> archiveAnnouncement(int id) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/announcements/$id/archive/'),
      headers: await ApiConfig.getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to archive announcement: ${response.body}');
    }
  }

//post product button
static Future<Map<String, dynamic>> createAnnouncement({
  required String title,
  required String description,
  required String price,
  required int categoryId,
  required int universityId,
  required String location,
  required String phoneNumber,
  required List<File> photos,
}) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('${ApiConfig.baseUrl}/announcements/create/'),
  );

  // Add headers
  final headers = await ApiConfig.getHeaders(isMultipart: true);
  request.headers.addAll(headers);

  // Add text fields
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['price'] = price;
  request.fields['category'] = categoryId.toString();
  request.fields['university'] = universityId.toString();
  request.fields['location'] = location;
  request.fields['phone_number'] = phoneNumber;

  // Add photos
  for (final photo in photos) {
    request.files.add(await http.MultipartFile.fromPath('photos', photo.path));
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create: ${response.body}');
  }
}

}
