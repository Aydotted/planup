import 'package:flutter/material.dart';
import 'package:planup_fixed_new/features/shifts/presentation/screens/shift_template_screen.dart';
import 'package:provider/provider.dart';

import '../controllers/shift_template_controller.dart';
import '../../domain/entities/shift_template.dart';

class ShiftTemplatesListScreen extends StatelessWidget {
  const ShiftTemplatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShiftTemplateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Templates'),
      ),
      body: controller.templates.isEmpty
          ? const Center(
              child: Text('No templates created yet.'),
            )
          : ListView.builder(
              itemCount: controller.templates.length,
              itemBuilder: (context, index) {
                final ShiftTemplate template =
                    controller.templates[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(
                        template.colourValue,
                      ),
                    ),
                    title: Text(template.name),
                    subtitle: Text(
                      '${template.abbreviation} • '
                      '${template.startHour.toString().padLeft(2, '0')}:'
                      '${template.startMinute.toString().padLeft(2, '0')} - '
                      '${template.endHour.toString().padLeft(2, '0')}:'
                      '${template.endMinute.toString().padLeft(2, '0')}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ShiftTemplateScreen(
                                template: template,
                              ),
                            ),
                          );
                        },
                      ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            controller.duplicateTemplate(
                              template,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await controller.deleteTemplate(
                              template.id,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}