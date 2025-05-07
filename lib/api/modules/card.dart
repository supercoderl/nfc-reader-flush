import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nfc_reader_flush/enum/index.dart';
import 'package:nfc_reader_flush/util/StorageUtils.dart';
import 'package:nfc_reader_flush/util/ToastUtils.dart';
import 'package:nfc_reader_flush/model/CardInfo.dart';

Future<int> createCard(CardInfo card) async {
  try {
    final token = await StorageUtils.get("token");
    if (token == null) {
      ToastUtils.showAppToast("Token not found in storage", ToastType.error);
      return -1;
    }
    final response = await http.post(
      Uri.parse('https://unique-helpful-filly.ngrok-free.app/cards'), // Android emulator
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        "ngrok-skip-browser-warning": "69420"
      },
      body: jsonEncode({'cardData': card.toJson()}),
    );

    return response.statusCode;
  } catch (e) {
    print('Error creating card: $e');
    return -1; // Return -1 to indicate an error
  }
}

Future<List<dynamic>?> getCards() async {
  final token = await StorageUtils.get("token");
  if (token == null) {
    ToastUtils.showAppToast("Token not found in storage", ToastType.error);
    return null;
  }
  final response = await http.get(
    Uri.parse('https://unique-helpful-filly.ngrok-free.app/cards'), // Android emulator
    headers: {
      'Authorization': 'Bearer $token',
      "ngrok-skip-browser-warning": "69420"
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    print('Get cards failed: ${response.body}');
    return null;
  }
}

Future<int> deleteCard(String cardId) async {
  final token = await StorageUtils.get("token");
  if (token == null) {
    ToastUtils.showAppToast("Token not found in storage", ToastType.error);
    return -1;
  }
  final response = await http.delete(
    Uri.parse('https://unique-helpful-filly.ngrok-free.app/cards/$cardId'), // Android emulator
    headers: {
      'Authorization': 'Bearer $token',
      "ngrok-skip-browser-warning": "69420"
    },
  );

  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    print('Delete card failed: ${response.body}');
    return -1; // Return -1 to indicate an error
  }
}
