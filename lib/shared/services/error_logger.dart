import 'package:flutter/material.dart';

class ErrorLogger {
  static void logFlutterError(FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');
  }

  static void logCustom(String message, {Object? error, StackTrace? stack}) {
    debugPrint(message);

    if (error != null) {
      debugPrint(error.toString());
    }

    if (stack != null) {
      debugPrint(stack.toString());
    }
  }
}
