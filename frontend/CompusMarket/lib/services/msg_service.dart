import 'dart:convert';
import 'package:http/http.dart' as http;

class MsgService {
  static const String baseUrl = 'https://2cp-project-production-4365.up.railway.app/api';  
  static const String wsBase = 'wss://2cp-project-production-4365.up.railway.app/ws'; 

  static String currentUserEmail = '';
  static String currentUserId = '';  // String because Me returns UUID

  static Map<String, String> headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  static Future<List<dynamic>> getConversations(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/messaging/conversations/'),
      headers: headers(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load conversations');
  }

  static Future<List<dynamic>> getMessages(String token, int conversationId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/messaging/conversations/$conversationId/messages/'),
      headers: headers(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load messages');
  }

  static Future<void> markAsRead(String token, int conversationId) async {
    await http.patch(
      Uri.parse('$baseUrl/messaging/conversations/$conversationId/read/'),
      headers: headers(token),
    );
  }

  static String wsUrl(int conversationId, String token) =>
      '$wsBase/$conversationId/?token=$token';
}