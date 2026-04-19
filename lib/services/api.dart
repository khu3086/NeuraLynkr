import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static String? _accessToken;
  static String? _userId;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _userId = prefs.getString('user_id');
  }

  static bool get isLoggedIn => _accessToken != null;
  static String? get userId => _userId;

  static Future<void> _saveSession(String token, String userId) async {
    _accessToken = token;
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString('user_id', userId);
  }

  static Future<void> logout() async {
    _accessToken = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_id');
  }

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String displayName,
    required int age,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': displayName,
        'age': age,
      }),
    );

    if (response.statusCode != 200) {
      throw ApiException(_extractError(response));
    }

    final data = jsonDecode(response.body);
    await _saveSession(data['access_token'], data['user_id']);
    return data;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw ApiException(_extractError(response));
    }

    final data = jsonDecode(response.body);
    await _saveSession(data['access_token'], data['user_id']);
    return data;
  }

  static Future<Map<String, dynamic>> getMyProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profiles/me'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode != 200) {
      throw ApiException(_extractError(response));
    }

    return jsonDecode(response.body);
  }

  static String _extractError(http.Response r) {
    try {
      final data = jsonDecode(r.body);
      return data['detail']?.toString() ?? 'Request failed';
    } catch (_) {
      return 'Request failed (${r.statusCode})';
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
