import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/category_controller.dart';

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
                child: const Icon(Icons.category, color: Colors.white),
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
    );
  }
}
