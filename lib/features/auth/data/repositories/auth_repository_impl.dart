import '../datasources/auth_remote_datasource.dart';
import '../models/sign_up_request_model.dart';
import '../models/sign_in_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/sign_in_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> signUp(SignUpRequestModel request);
  Future<SignInResponseModel> signIn(SignInRequestModel request);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseModel> signUp(SignUpRequestModel request) async {
    return await remoteDataSource.signUp(request);
  }

  @override
  Future<SignInResponseModel> signIn(SignInRequestModel request) async {
    return await remoteDataSource.signIn(request);
  }
}
