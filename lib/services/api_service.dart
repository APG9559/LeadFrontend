import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "https://lead-demo-one.vercel.app";
  // Android emulator localhost

  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    String? token = await storage.read(key: "token");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<http.Response> get(String endpoint) async {
    return await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
  }

  Future<http.Response> post(String endpoint, Map data) async {
    return await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(data),
    );
  }

  Future<http.Response> patch(String endpoint, Map data) async {
    return await http.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(data),
    );
  }
}
