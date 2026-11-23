import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../shared/services/error_logger.dart';

class CrashLogScreen extends StatefulWidget {
  const CrashLogScreen({super.key});

  @override
  State<CrashLogScreen> createState() => _CrashLogScreenState();
}

class _CrashLogScreenState extends State<CrashLogScreen> {
  String _logText = 'Loading crash log...';

  @override
  void initState() {
    super.initState();
    _loadCrashLog();
  }

  Future<void> _loadCrashLog() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/error_log.txt');

      if (await file.exists()) {
        final text = await file.readAsString();
        setState(() => _logText = text.isEmpty ? 'Log file is empty.' : text);
      } else {
        setState(() => _logText = 'No crash log file found.');
      }
    } catch (e) {
      setState(() => _logText = 'Failed to load crash log.');
    }
  }

  Future<void> _clearCrashLog() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/error_log.txt');

      if (await file.exists()) {
        await file.writeAsString('');
      }

      setState(() => _logText = 'Crash log cleared.');
    } catch (e) {
      setState(() => _logText = 'Failed to clear crash log.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crash Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: _logText));

              if (!mounted) return;

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Crash log copied')));
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCrashLog),
          IconButton(icon: const Icon(Icons.delete), onPressed: _clearCrashLog),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(_logText, style: const TextStyle(fontSize: 14))],
        ),
        //child: Text(_logText, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
