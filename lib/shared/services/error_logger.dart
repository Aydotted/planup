import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ErrorLogger {
  static Future<void> _writeToFile(String message) async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/error_log.txt');

      await file.writeAsString('''

[${DateTime.now()}]

$message

----------------------------------------

''', mode: FileMode.append);
    } catch (_) {}
  }

  static void logFlutterError(FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exception}');

    _writeToFile('''
FLUTTER ERROR

${details.exception}

${details.stack}
''');
  }

  static void logCustom(String message, {Object? error, StackTrace? stack}) {
    debugPrint(message);

    if (error != null) {
      debugPrint(error.toString());
    }

    if (stack != null) {
      debugPrint(stack.toString());
    }

    _writeToFile('''
$message

$error

$stack
''');
  }
}
