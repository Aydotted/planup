import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:planup_fixed_new/features/category/domain/entities/category.dart';

import 'presentation/controllers/category_controller.dart';

class CategoryPickerScreen extends StatelessWidget {
  const CategoryPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryController>();
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Pick Category')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(category.color),
                child: Icon(
                  IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: Colors.white,
                ),
              ),
              title: Text(category.name),
              subtitle: Text(category.abbreviation),
              onTap: () {
                Navigator.pop(context, category);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final provider = context.read<CategoryController>();

    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('New Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children:
                        [
                          Colors.blue,
                          Colors.red,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                        ].map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: color,
                              child: selectedColor == color
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();

                    if (name.isEmpty) {
                      return;
                    }

                    final abbreviation = name.length >= 3
                        ? name.substring(0, 3).toUpperCase()
                        : name.toUpperCase();

                    final category = Category(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      color: selectedColor.toARGB32(),
                      iconCodePoint: Icons.label.codePoint,
                      abbreviation: abbreviation,
                    );

                    provider.addCategory(category);

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
