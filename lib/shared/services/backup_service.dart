import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String exportedJson = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final json = ''; // ToDO: restore backup
                setState(() => exportedJson = json);
              },
              child: const Text('Export Backup'),
            ),

            const SizedBox(height: 16),

            if (exportedJson.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Backup JSON',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: SingleChildScrollView(
                        child: SelectableText(exportedJson),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: exportedJson));
                      },
                      child: const Text('Copy Backup'),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final controller = TextEditingController();

                if (!mounted) return;
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Paste Backup JSON'),
                    content: TextField(
                      controller: controller,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //Todo: implement backup restore
                          Navigator.pop(context);
                        },

                        child: const Text('Restore'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Restore Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
