import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';
import 'package:habit_tracker/screens/edit_habit_screen.dart';
import 'package:habit_tracker/services/database_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _addHabit(DatabaseService dbService) async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );

    if (result != null && result['name'] != null && result['theme'] != null) {
      final newHabit = Habit(id: 'dummy_id', name: result['name']!, theme: result['theme']!);
      await dbService.addHabit(newHabit);
    }
  }

  void _toggleHabitCompleted(Habit habit, DatabaseService dbService) {
    final isCompleted = !habit.isCompleted;
    int newStreak = habit.streak;
    if (isCompleted) {
      newStreak++;
    } else {
      if (newStreak > 0) {
        newStreak--;
      }
    }
    final updatedHabit = habit.copyWith(
      isCompleted: isCompleted,
      streak: newStreak,
    );
    dbService.updateHabit(updatedHabit);
  }

  void _deleteHabit(Habit habit, DatabaseService dbService) {
    dbService.deleteHabit(habit.id);
  }

  void _editHabit(Habit habit, DatabaseService dbService) async {
    final updatedHabit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (context) => EditHabitScreen(habit: habit)),
    );

    if (updatedHabit != null) {
      dbService.updateHabit(updatedHabit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: StreamBuilder<List<Habit>>(
        stream: dbService.getHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No habits yet. Add one!'));
          }

          final habits = snapshot.data!;

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return Dismissible(
                key: ValueKey(habit.id),
                onDismissed: (direction) {
                  _deleteHabit(habit, dbService);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  onTap: () => _editHabit(habit, dbService),
                  leading: CircleAvatar(
                    child: Text('${habit.streak}'),
                  ),
                  title: Text(habit.name),
                  subtitle: Text(habit.theme),
                  trailing: Checkbox(
                    value: habit.isCompleted,
                    onChanged: (value) {
                      _toggleHabitCompleted(habit, dbService);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addHabit(dbService),
        child: const Icon(Icons.add),
      ),
    );
  }
}
