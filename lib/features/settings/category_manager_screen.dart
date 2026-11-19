import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planup_fixed_new/features/category/presentation/controllers/category_controller.dart';

class CategoryManagerScreen extends StatelessWidget {
  const CategoryManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CategoryController>();
    final categories = controller.categories;

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final category = categories[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(category.color),
              child: Icon(Icons.category, color: Colors.white),
            ),
            title: Text("${category.name} (${category.abbreviation})"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.deleteCategory(category.id),
            ),
          );
        },
      ),
    );
  }
}
