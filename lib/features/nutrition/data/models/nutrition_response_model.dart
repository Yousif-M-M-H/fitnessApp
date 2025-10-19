class NutritionResponseModel {
  final String message;
  final NutritionData data;

  NutritionResponseModel({required this.message, required this.data});

  factory NutritionResponseModel.fromJson(Map<String, dynamic> json) {
    return NutritionResponseModel(
      message: json['message'] as String,
      data: NutritionData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class NutritionData {
  final int dailyCalories;
  final int proteinIntake;
  final int carbIntake;
  final int fatIntake;
  final int bmr;
  final int tdee;

  NutritionData({
    required this.dailyCalories,
    required this.proteinIntake,
    required this.carbIntake,
    required this.fatIntake,
    required this.bmr,
    required this.tdee,
  });

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      dailyCalories: json['dailyCalories'] as int,
      proteinIntake: json['proteinIntake'] as int,
      carbIntake: json['carbIntake'] as int,
      fatIntake: json['fatIntake'] as int,
      bmr: json['bmr'] as int,
      tdee: json['tdee'] as int,
    );
  }
}
