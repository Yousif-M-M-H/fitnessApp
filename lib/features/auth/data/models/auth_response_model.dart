class AuthResponseModel {
  final String message;
  final UserModel user;

  AuthResponseModel({
    required this.message,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
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
    );
  }
}
