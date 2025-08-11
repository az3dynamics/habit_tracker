import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _habitName = '';
  String _habitTheme = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Add logic to save the new habit
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _habitName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Theme'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a theme.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _habitTheme = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
