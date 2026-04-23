import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileApiService {
  static const String baseUrl = 'http://ritadjl.pythonanywhere.com/api/profiles';

  static String token = '';

  static Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
 static Map<String, String> get multipartHeaders => {
    'Authorization': 'Bearer $token',
  };

   // GET /api/profiles/{student_id}/
  static Future<Map<String, dynamic>> getPublicProfile(int studentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/profiles/$studentId/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load profile');
  }

   // GET /api/profiles/me/
  static Future<Map<String, dynamic>> getMyProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/profiles/me/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load my profile');
  }

   // PATCH /api/profiles/me/update/
  static Future<Map<String, dynamic>> updateMyProfile({
    bool? notificationsEnabled,
    bool? showEmail,
    bool? isActiveSeller,
    String? responseTime,
  }) async {
    final body = <String, dynamic>{};
    if (notificationsEnabled != null) body['notifications_enabled'] = notificationsEnabled;
    if (showEmail != null) body['show_email'] = showEmail;
    if (isActiveSeller != null) body['is_active_seller'] = isActiveSeller;
    if (responseTime != null) body['response_time'] = responseTime;

    final res = await http.patch(
      Uri.parse('$baseUrl/profiles/me/update/'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to update profile: ${res.body}');
  }

  // PATCH /api/users/me/
  static Future<void> updateAccount({
    String? fullName,
    String? currentPassword,
    String? newPassword,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (currentPassword != null) body['current_password'] = currentPassword;
    if (newPassword != null) body['new_password'] = newPassword;

    final res = await http.patch(
      Uri.parse('$baseUrl/users/me/'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update account: ${res.body}');
    }
  }

   // POST /api/users/logout/
  static Future<void> logout(String refreshToken) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/logout/'),
      headers: headers,
      body: jsonEncode({'refresh': refreshToken}),
    );
    if (res.statusCode != 200) {
      throw Exception('Logout failed: ${res.body}');
    }
  }

   // GET /api/listings/
  static Future<List<dynamic>> getAllListings() async {
    final res = await http.get(
      Uri.parse('$baseUrl/listings/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load listings');
  }

    // GET /api/listings/{listing_id}/
  static Future<Map<String, dynamic>> getListingDetail(int listingId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/listings/$listingId/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load listing');
  }
  // POST /api/listings/create/
  static Future<Map<String, dynamic>> createListing({
    required String title,
    required String description,
    required double price,
    required String currency,
    required String category,
    required String condition,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/listings/create/'),
      headers: headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
        'category': category,
        'condition': condition,
      }),
    );
    if (res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('Failed to create listing: ${res.body}');
  }

   // PATCH /api/listings/{listing_id}/update/
  static Future<Map<String, dynamic>> updateListing(
    int listingId, Map<String, dynamic> data
  ) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/listings/$listingId/update/'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to update listing: ${res.body}');
  }

    // DELETE /api/listings/{listing_id}/delete/
  static Future<void> deleteListing(int listingId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/listings/$listingId/delete/'),
      headers: headers,
    );
    if (res.statusCode != 204) {
      throw Exception('Failed to delete listing: ${res.body}');
    }
  }
   // PATCH /api/listings/{listing_id}/mark-sold/
  static Future<void> markListingAsSold(int listingId) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/listings/$listingId/mark-sold/'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to mark as sold: ${res.body}');
    }
  }

   // GET /api/listings/my/
  static Future<List<dynamic>> getMyListings() async {
    final res = await http.get(
      Uri.parse('$baseUrl/listings/my/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load my listings');
  }

   // GET /api/listings/seller/{student_id}/
  static Future<List<dynamic>> getSellerListings(int studentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/listings/seller/$studentId/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load seller listings');
  }

   // GET /api/reviews/{student_id}/
  static Future<List<dynamic>> getUserReviews(int studentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/reviews/$studentId/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load reviews');
  }

   // POST /api/reviews/create/{student_id}/
  static Future<void> createReview({
    required int studentId,
    required int score,
    String comment = '',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reviews/create/$studentId/'),
      headers: headers,
      body: jsonEncode({'score': score, 'comment': comment}),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to submit review: ${res.body}');
    }
  }

  // DELETE /api/reviews/{review_id}/delete/
  static Future<void> deleteReview(int reviewId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/reviews/$reviewId/delete/'),
      headers: headers,
    );
    if (res.statusCode != 204) {
      throw Exception('Failed to delete review: ${res.body}');
    }
  }

   // GET /api/deals/my/
  static Future<List<dynamic>> getMyDeals() async {
    final res = await http.get(
      Uri.parse('$baseUrl/deals/my/'),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load deals');
  }

  // POST /api/deals/create/{listing_id}/
  static Future<Map<String, dynamic>> createDeal(int listingId) async {
    final res = await http.post(
      Uri.parse('$baseUrl/deals/create/$listingId/'),
      headers: headers,
    );
    if (res.statusCode == 201) return jsonDecode(res.body);
    throw Exception('Failed to create deal: ${res.body}');
  }

   // PATCH /api/deals/{deal_id}/complete/
  static Future<void> completeDeal(int dealId) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/deals/$dealId/complete/'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to complete deal: ${res.body}');
    }
  }
   // PATCH /api/deals/{deal_id}/cancel/
  static Future<void> cancelDeal(int dealId) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/deals/$dealId/cancel/'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to cancel deal: ${res.body}');
    }
  }
 
}