class Habit {
  final String name;
  final String theme;
  final int streak;
  final bool isCompleted;

  Habit({
    required this.name,
    required this.theme,
    this.streak = 0,
    this.isCompleted = false,
  });

  Habit copyWith({
    String? name,
    String? theme,
    int? streak,
    bool? isCompleted,
  }) {
    return Habit(
      name: name ?? this.name,
      theme: theme ?? this.theme,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
