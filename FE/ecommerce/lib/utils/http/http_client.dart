import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CHttpHelper {
  // static const String _baseUrl =
  // 'http://10.0.0.2:8000/api'; //Android Emulator
  // // 'http://localhost:8000/api'; //iOS Emulator, web
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api'; // Địa chỉ cho web
    } else if (Platform.isAndroid) {
      return 'http://10.0.0.2:8000/api'; // Địa chỉ cho Android Emulator
    }
    // Có thể thêm các điều kiện khác nếu cần
    return 'http://localhost:8000/api'; // Giá trị mặc định
  }

  // Helper to get headers with Bearer token
  static Future<Map<String, String>> _getHeaders({
    bool withAuth = false,
  }) async {
    final headers = {'Content-Type': 'application/json'};

    if (withAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool withAuth = false,
  }) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic data, {
    bool withAuth = false,
  }) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    dynamic data, {
    bool withAuth = false,
  }) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool withAuth = false,
  }) async {
    final headers = await _getHeaders(withAuth: withAuth);
    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // Response handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw Exception('Unexpected response format');
    }
  }
}
