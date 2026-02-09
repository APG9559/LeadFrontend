import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/api_service.dart';

class AuthService {
  final ApiService api = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await api.post("/auth/login", {
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["access_token"]);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await storage.delete(key: "token");
  }

  Future<bool> register(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await api.post("/auth/register", {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["access_token"]);
      return true;
    }

    return false;
  }
}
