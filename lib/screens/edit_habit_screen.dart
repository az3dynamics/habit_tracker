import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({super.key, required this.habit});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _themeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _themeController = TextEditingController(text: widget.habit.theme);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedHabit = widget.habit.copyWith(
        name: _nameController.text,
        theme: _themeController.text,
      );
      Navigator.of(context).pop(updatedHabit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _themeController,
                decoration: const InputDecoration(labelText: 'Theme'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a theme.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
