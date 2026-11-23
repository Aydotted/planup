import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ErrorLoggingService {
  static Future<void> logError(Object error, StackTrace? stackTrace) async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      final file = File('${dir.path}/error_log.txt');

      final timestamp = DateTime.now();

      await file.writeAsString('''

[$timestamp]

ERROR:
$error

STACKTRACE:
${stackTrace ?? 'No stacktrace'}

----------------------------------------

''', mode: FileMode.append);
    } catch (_) {
      // Never crash while logging
    }
  }
}
