import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final request = SignInRequestModel(
        email: email,
        password: password,
      );

      await authRepository.signIn(request);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}
