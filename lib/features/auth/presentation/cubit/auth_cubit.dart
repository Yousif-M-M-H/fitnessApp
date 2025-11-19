import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/sign_up_request_model.dart';
import '../../data/models/sign_in_request_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phone,
  }) async {
    emit(AuthLoading());

    try {
      final request = SignUpRequestModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        dateOfBirth: dateOfBirth.toIso8601String().split('T')[0],
        phone: phone,
      );

      await authRepository.signUp(request);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final request = SignInRequestModel(email: email, password: password);
      final response = await authRepository.signIn(request);

      // Save authentication data including workout and nutrition data
      await AuthService.saveAuthData(
        token: response.token,
        userId: response.user.id,
        email: response.user.email,
        firstName: response.user.firstName,
        lastName: response.user.lastName,
        phoneNumber: response.user.phone,
        dateOfBirth: response.user.dateOfBirth,
        goal: response.user.goal,
        activityLevel: response.user.activityLevel,
        gymDaysPerWeek: response.user.gymDaysPerWeek,
        sessionDuration: response.user.sessionDuration,
        gender: response.user.gender,
        height: response.user.height,
        weight: response.user.weight,
        dailyCalories: response.user.dailyCalories,
        proteinIntake: response.user.proteinIntake,
        carbIntake: response.user.carbIntake,
        fatIntake: response.user.fatIntake,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await AuthService.clearAuthData();
    emit(AuthInitial());
  }

  Future<String?> getToken() async {
    return await AuthService.getToken();
  }

  void resetState() {
    emit(AuthInitial());
  }
}
