import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_reader_flush/enum/index.dart';

class ToastUtils {
  static void showAppToast(String message, ToastType type) {
    Color bgColor;

    switch (type) {
      case ToastType.success:
        bgColor = Colors.green;
        break;
      case ToastType.error:
        bgColor = Colors.red;
        break;
      case ToastType.info:
        bgColor = Colors.blueGrey;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
