import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nfc_reader_flush/enum/index.dart';
import 'package:nfc_reader_flush/util/ToastUtils.dart';

import '../../util/StorageUtils.dart';

Future<Object?> register(
  String email,
  String password,
  String firstname,
  String lastname,
  String birthdate,
  String phone,
) async {
  final response = await http.post(
    Uri.parse(
        'https://unique-helpful-filly.ngrok-free.app/auth/register'), // Android emulator
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'birthdate': birthdate,
      'phone': phone
    }),
  );

  if (response.statusCode == 201) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Register failed: ${response.body}');
    return null;
  }
}

Future<String?> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('https://unique-helpful-filly.ngrok-free.app/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        "ngrok-skip-browser-warning": "69420"
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    print("Login response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error during login: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> getProfile() async {
  final token = await StorageUtils.get("token");
  if (token == null) {
    ToastUtils.showAppToast("Token not found in storage", ToastType.error);
    return null;
  }

  final response = await http.get(
    Uri.parse('https://unique-helpful-filly.ngrok-free.app/auth/profile'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      "ngrok-skip-browser-warning": "69420"
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Get profile failed: ${response.body}');
    return null;
  }
}
