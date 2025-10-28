class ExerciseModel {
  final String name;
  final String sets;
  final String reps;
  final bool isTimeBased;
  final int? timeInSeconds;

  ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    this.isTimeBased = false,
    this.timeInSeconds,
  });

  /// Parse exercise string from backend
  /// Examples:
  /// - "Bodyweight Squats - 3x12" -> name: "Bodyweight Squats", sets: "3", reps: "12"
  /// - "Plank - 3x30sec" -> name: "Plank", sets: "3", reps: "30sec", isTimeBased: true
  factory ExerciseModel.fromString(String exerciseString) {
    final parts = exerciseString.split(' - ');
    if (parts.length != 2) {
      return ExerciseModel(
        name: exerciseString,
        sets: '0',
        reps: '0',
      );
    }

    final name = parts[0].trim();
    final setsReps = parts[1].trim();

    // Split by 'x' to get sets and reps
    final setsRepsParts = setsReps.split('x');
    if (setsRepsParts.length != 2) {
      return ExerciseModel(
        name: name,
        sets: '0',
        reps: '0',
      );
    }

    final sets = setsRepsParts[0].trim();
    final reps = setsRepsParts[1].trim();

    // Check if it's time-based (contains 'sec' or 'min')
    final isTimeBased = reps.contains('sec') || reps.contains('min');
    int? timeInSeconds;

    if (isTimeBased) {
      if (reps.contains('sec')) {
        final secondsStr = reps.replaceAll('sec', '').trim();
        timeInSeconds = int.tryParse(secondsStr);
      } else if (reps.contains('min')) {
        final minutesStr = reps.replaceAll('min', '').trim();
        final minutes = int.tryParse(minutesStr);
        if (minutes != null) {
          timeInSeconds = minutes * 60;
        }
      }
    }

    return ExerciseModel(
      name: name,
      sets: sets,
      reps: reps,
      isTimeBased: isTimeBased,
      timeInSeconds: timeInSeconds,
    );
  }

  String get displayReps => reps;
  String get displaySets => sets;
}
