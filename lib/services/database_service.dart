import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/models/habit.dart';

class DatabaseService {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  DatabaseService({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = firebaseAuth ?? FirebaseAuth.instance;

  User? get _currentUser => _auth.currentUser;

  // Get a stream of habits for the current user
  Stream<List<Habit>> getHabits() {
    if (_currentUser == null) {
      return Stream.value([]);
    }
    return _db
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('habits')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Habit.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add a new habit
  Future<void> addHabit(Habit habit) {
    if (_currentUser == null) {
      throw Exception("User not logged in");
    }
    return _db
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('habits')
        .add(habit.toMap());
  }

  // Update an existing habit
  Future<void> updateHabit(Habit habit) {
    if (_currentUser == null) {
      throw Exception("User not logged in");
    }
    return _db
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId) {
    if (_currentUser == null) {
      throw Exception("User not logged in");
    }
    return _db
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
}
