import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/workout_plan_model.dart';

class WorkoutService {
  final DioClient _dioClient;

  WorkoutService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<WorkoutPlanModel> customizeWorkoutPlan({
    required int gymDaysPerWeek,
    required String fitnessLevel,
    required String gender,
    required String sessionDuration,
    String? goal,
  }) async {
    try {
      final response = await _dioClient.post(
        '/workouts/customize',
        data: {
          'gymDaysPerWeek': gymDaysPerWeek,
          'fitnessLevel': fitnessLevel,
          'gender': gender,
          'sessionDuration': sessionDuration,
          if (goal != null && goal.isNotEmpty) 'goal': goal,
        },
      );

      if (response.statusCode == 200) {
        return WorkoutPlanModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to customize workout plan');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to customize workout plan',
        );
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
