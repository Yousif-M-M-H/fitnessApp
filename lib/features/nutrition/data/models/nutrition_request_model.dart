class NutritionRequestModel {
  final double weight;
  final double height;
  final int age;
  final String gender;
  final String activityLevel;
  final String goal;

  NutritionRequestModel({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender.toLowerCase(),
      'activityLevel': activityLevel,
      'goal': goal,
    };
  }
}
