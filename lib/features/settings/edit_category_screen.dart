import 'package:flutter/material.dart';

import '../../features/category/domain/entities/category.dart';

class EditCategoryScreen extends StatefulWidget {
  final Category? category;

  const EditCategoryScreen({super.key, this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _abbreviationController;

  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.category?.name ?? '');

    _abbreviationController = TextEditingController(
      text: widget.category?.abbreviation ?? '',
    );

    _selectedColor = Color(widget.category?.color ?? Colors.blue.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _abbreviationController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    final name = _nameController.text.trim();
    final abbreviation = _abbreviationController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    if (abbreviation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an abbreviation')),
      );
      return;
    }

    final category = Category(
      id:
          widget.category?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      abbreviation: abbreviation,
      color: _selectedColor.value,
      iconCodePoint: widget.category?.iconCodePoint ?? Icons.folder.codePoint,
    );

    Navigator.pop(context, category);
  }

  @override
  Widget build(BuildContext context) {
    const colours = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _abbreviationController,
              decoration: const InputDecoration(
                labelText: 'Abbreviation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Colour', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: colours.map((colour) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colour;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: colour,
                    child: _selectedColor == colour
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveCategory,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
