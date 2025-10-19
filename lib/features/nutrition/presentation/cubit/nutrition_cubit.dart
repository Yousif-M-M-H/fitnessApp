import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../data/models/nutrition_request_model.dart';
import '../../data/models/nutrition_response_model.dart';

part 'nutrition_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  final NutritionRepository nutritionRepository;

  NutritionCubit({required this.nutritionRepository})
    : super(NutritionInitial());

  Future<void> calculateNutrition({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
    required String token,
  }) async {
    emit(NutritionLoading());

    try {
      final request = NutritionRequestModel(
        weight: weight,
        height: height,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
      );

      final response = await nutritionRepository.calculateNutrition(
        request,
        token,
      );

      emit(NutritionSuccess(response.data));
    } catch (e) {
      emit(NutritionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void resetState() {
    emit(NutritionInitial());
  }
}
