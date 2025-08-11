class Habit {
  final String name;
  final String theme;
  final int streak;

  Habit({
    required this.name,
    required this.theme,
    this.streak = 0,
  });
}
