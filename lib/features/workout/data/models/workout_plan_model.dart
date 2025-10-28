class WorkoutPlanModel {
  final WorkoutSummary summary;
  final List<DayWorkout> weeklyPlan;
  final WorkoutRecommendations recommendations;
  final List<String> generalTips;

  WorkoutPlanModel({
    required this.summary,
    required this.weeklyPlan,
    required this.recommendations,
    required this.generalTips,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    return WorkoutPlanModel(
      summary: WorkoutSummary.fromJson(json['summary']),
      weeklyPlan: (json['weeklyPlan'] as List)
          .map((day) => DayWorkout.fromJson(day))
          .toList(),
      recommendations:
          WorkoutRecommendations.fromJson(json['recommendations']),
      generalTips: List<String>.from(json['generalTips'] ?? []),
    );
  }
}

class WorkoutSummary {
  final int gymDaysPerWeek;
  final String fitnessLevel;
  final String gender;
  final String sessionDuration;
  final String? goal;
  final String workoutSplit;

  WorkoutSummary({
    required this.gymDaysPerWeek,
    required this.fitnessLevel,
    required this.gender,
    required this.sessionDuration,
    this.goal,
    required this.workoutSplit,
  });

  factory WorkoutSummary.fromJson(Map<String, dynamic> json) {
    return WorkoutSummary(
      gymDaysPerWeek: json['gymDaysPerWeek'],
      fitnessLevel: json['fitnessLevel'],
      gender: json['gender'],
      sessionDuration: json['sessionDuration'],
      goal: json['goal'],
      workoutSplit: json['workoutSplit'],
    );
  }
}

class DayWorkout {
  final int day;
  final String type;
  final String duration;
  final List<String> exercises;

  DayWorkout({
    required this.day,
    required this.type,
    required this.duration,
    required this.exercises,
  });

  factory DayWorkout.fromJson(Map<String, dynamic> json) {
    return DayWorkout(
      day: json['day'],
      type: json['type'],
      duration: json['duration'],
      exercises: List<String>.from(json['exercises']),
    );
  }
}

class WorkoutRecommendations {
  final String cardio;
  final String restDays;
  final List<String> nutrition;
  final String progression;

  WorkoutRecommendations({
    required this.cardio,
    required this.restDays,
    required this.nutrition,
    required this.progression,
  });

  factory WorkoutRecommendations.fromJson(Map<String, dynamic> json) {
    return WorkoutRecommendations(
      cardio: json['cardio'] ?? '',
      restDays: json['restDays'] ?? '',
      nutrition: List<String>.from(json['nutrition'] ?? []),
      progression: json['progression'] ?? '',
    );
  }
}
