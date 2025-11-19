import 'package:shared_preferences/shared_preferences.dart';

/// Centralized authentication service
/// Handles token management and authentication state
class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';
  static const String _userPhoneNumberKey = 'user_phone_number';
  static const String _userDateOfBirthKey = 'user_date_of_birth';
  static const String _hasWorkoutPlanKey = 'has_workout_plan';
  static const String _workoutGoalKey = 'workout_goal';
  static const String _activityLevelKey = 'activity_level';
  static const String _gymDaysPerWeekKey = 'gym_days_per_week';
  static const String _sessionDurationKey = 'session_duration';
  // Nutrition keys
  static const String _hasNutritionPlanKey = 'has_nutrition_plan';
  static const String _genderKey = 'gender';
  static const String _heightKey = 'height';
  static const String _weightKey = 'weight';
  static const String _dailyCaloriesKey = 'daily_calories';
  static const String _proteinIntakeKey = 'protein_intake';
  static const String _carbIntakeKey = 'carb_intake';
  static const String _fatIntakeKey = 'fat_intake';

  /// Check if user is authenticated (has valid token)
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Save user authentication data
  static Future<void> saveAuthData({
    required String token,
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? dateOfBirth,
    String? goal,
    String? activityLevel,
    int? gymDaysPerWeek,
    String? sessionDuration,
    String? gender,
    double? height,
    double? weight,
    int? dailyCalories,
    int? proteinIntake,
    int? carbIntake,
    int? fatIntake,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userFirstNameKey, firstName);
    await prefs.setString(_userLastNameKey, lastName);
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      await prefs.setString(_userPhoneNumberKey, phoneNumber);
    }
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      await prefs.setString(_userDateOfBirthKey, dateOfBirth);
    }

    // Save workout preferences if available
    if (goal != null && goal.isNotEmpty) {
      await prefs.setString(_workoutGoalKey, goal);
      await prefs.setBool(_hasWorkoutPlanKey, true);
    }
    if (activityLevel != null && activityLevel.isNotEmpty) {
      await prefs.setString(_activityLevelKey, activityLevel);
    }
    if (gymDaysPerWeek != null) {
      await prefs.setInt(_gymDaysPerWeekKey, gymDaysPerWeek);
    }
    if (sessionDuration != null && sessionDuration.isNotEmpty) {
      await prefs.setString(_sessionDurationKey, sessionDuration);
    }

    // Save nutrition data if available
    if (dailyCalories != null && dailyCalories > 0) {
      await prefs.setInt(_dailyCaloriesKey, dailyCalories);
      await prefs.setBool(_hasNutritionPlanKey, true);
    }
    if (gender != null && gender.isNotEmpty) {
      await prefs.setString(_genderKey, gender);
    }
    if (height != null) {
      await prefs.setDouble(_heightKey, height);
    }
    if (weight != null) {
      await prefs.setDouble(_weightKey, weight);
    }
    if (proteinIntake != null) {
      await prefs.setInt(_proteinIntakeKey, proteinIntake);
    }
    if (carbIntake != null) {
      await prefs.setInt(_carbIntakeKey, carbIntake);
    }
    if (fatIntake != null) {
      await prefs.setInt(_fatIntakeKey, fatIntake);
    }
  }

  /// Clear all authentication data (logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Get user data
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'email': prefs.getString(_userEmailKey),
      'firstName': prefs.getString(_userFirstNameKey),
      'lastName': prefs.getString(_userLastNameKey),
      'phoneNumber': prefs.getString(_userPhoneNumberKey),
      'dateOfBirth': prefs.getString(_userDateOfBirthKey),
    };
  }

  /// Check if user has completed workout customization
  static Future<bool> hasWorkoutPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasWorkoutPlanKey) ?? false;
  }

  /// Get workout preferences
  static Future<Map<String, dynamic>> getWorkoutPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'goal': prefs.getString(_workoutGoalKey),
      'activityLevel': prefs.getString(_activityLevelKey),
      'gymDaysPerWeek': prefs.getInt(_gymDaysPerWeekKey),
      'sessionDuration': prefs.getString(_sessionDurationKey),
    };
  }

  /// Mark that user has completed workout customization
  static Future<void> markWorkoutPlanCompleted({
    required int gymDaysPerWeek,
    required String activityLevel,
    required String sessionDuration,
    String? goal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasWorkoutPlanKey, true);
    await prefs.setInt(_gymDaysPerWeekKey, gymDaysPerWeek);
    await prefs.setString(_activityLevelKey, activityLevel);
    await prefs.setString(_sessionDurationKey, sessionDuration);
    if (goal != null && goal.isNotEmpty) {
      await prefs.setString(_workoutGoalKey, goal);
    }
  }

  /// Check if user has nutrition plan
  static Future<bool> hasNutritionPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasNutritionPlanKey) ?? false;
  }

  /// Get nutrition data
  static Future<Map<String, dynamic>> getNutritionData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'gender': prefs.getString(_genderKey),
      'height': prefs.getDouble(_heightKey),
      'weight': prefs.getDouble(_weightKey),
      'dailyCalories': prefs.getInt(_dailyCaloriesKey),
      'proteinIntake': prefs.getInt(_proteinIntakeKey),
      'carbIntake': prefs.getInt(_carbIntakeKey),
      'fatIntake': prefs.getInt(_fatIntakeKey),
    };
  }

  /// Mark that user has completed nutrition calculation
  static Future<void> markNutritionPlanCompleted({
    required int dailyCalories,
    required int proteinIntake,
    required int carbIntake,
    required int fatIntake,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasNutritionPlanKey, true);
    await prefs.setInt(_dailyCaloriesKey, dailyCalories);
    await prefs.setInt(_proteinIntakeKey, proteinIntake);
    await prefs.setInt(_carbIntakeKey, carbIntake);
    await prefs.setInt(_fatIntakeKey, fatIntake);
  }
}
