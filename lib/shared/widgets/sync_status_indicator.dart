import 'package:flutter/material.dart';

class SyncStatusIndicator extends StatelessWidget {
  final bool syncing;

  const SyncStatusIndicator({required this.syncing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        syncing
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.cloud_done, color: Colors.green),
        SizedBox(width: 8),
        Text(syncing ? 'Syncing...' : 'Synced'),
      ],
    );
  }
}
