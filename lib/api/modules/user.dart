import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Object?> register(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/auth/register'), // Android emulator
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Register failed: ${response.body}');
    return null;
  }
}

Future<String?> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['token'];
  } else {
    print('Login failed: ${response.body}');
    return null;
  }
}
