import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';

import 'package:habit_tracker/screens/add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Habit> _habits = [];

  void _addHabit() async {
    final newHabit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );

    if (newHabit != null) {
      setState(() {
        _habits.add(newHabit);
      });
    }
  }

  void _toggleHabitCompleted(Habit habit) {
    setState(() {
      final habitIndex = _habits.indexOf(habit);
      final isCompleted = !habit.isCompleted;
      int newStreak = habit.streak;
      if (isCompleted) {
        newStreak++;
      } else {
        if (newStreak > 0) {
          newStreak--;
        }
      }
      _habits[habitIndex] = habit.copyWith(
        isCompleted: isCompleted,
        streak: newStreak,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: ListView.builder(

        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${habit.streak}'),
            ),
            title: Text(habit.name),
            subtitle: Text(habit.theme),
            trailing: Checkbox(
              value: habit.isCompleted,
              onChanged: (value) {
                _toggleHabitCompleted(habit);
              },
            ),

          );
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: _addHabit,

        child: const Icon(Icons.add),
      ),
    );
  }
}
