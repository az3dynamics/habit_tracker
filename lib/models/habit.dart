class Habit {
  final String id;
  final String name;
  final String theme;
  final int streak;
  final bool isCompleted;

  Habit({
    required this.id,
    required this.name,
    required this.theme,
    this.streak = 0,
    this.isCompleted = false,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? theme,
    int? streak,
    bool? isCompleted,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      theme: theme ?? this.theme,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'theme': theme,
      'streak': streak,
      'isCompleted': isCompleted,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map, String documentId) {
    return Habit(
      id: documentId,
      name: map['name'] ?? '',
      theme: map['theme'] ?? '',
      streak: map['streak']?.toInt() ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
