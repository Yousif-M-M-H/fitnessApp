class SignInResponseModel {
  final String message;
  final UserModel user;
  final String token;

  SignInResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth;
  final String role;
  final String phone;
  final bool isActive;
  final List<dynamic> workoutPlans;
  final String createdAt;
  final String updatedAt;
  // Optional workout preferences
  final String? goal;
  final String? activityLevel;
  final int? gymDaysPerWeek;
  final String? sessionDuration;
  // Optional nutrition data
  final String? gender;
  final double? height;
  final double? weight;
  final int? dailyCalories;
  final int? proteinIntake;
  final int? carbIntake;
  final int? fatIntake;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.role,
    required this.phone,
    required this.isActive,
    required this.workoutPlans,
    required this.createdAt,
    required this.updatedAt,
    this.goal,
    this.activityLevel,
    this.gymDaysPerWeek,
    this.sessionDuration,
    this.gender,
    this.height,
    this.weight,
    this.dailyCalories,
    this.proteinIntake,
    this.carbIntake,
    this.fatIntake,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String,
      isActive: json['isActive'] as bool,
      workoutPlans: json['workoutPlans'] as List<dynamic>,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      goal: json['goal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      gymDaysPerWeek: json['gymDaysPerWeek'] as int?,
      sessionDuration: json['sessionDuration'] as String?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      dailyCalories: json['dailyCalories'] as int?,
      proteinIntake: json['proteinIntake'] as int?,
      carbIntake: json['carbIntake'] as int?,
      fatIntake: json['fatIntake'] as int?,
    );
  }
}
