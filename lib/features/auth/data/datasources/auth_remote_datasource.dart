import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/sign_up_request_model.dart';
import '../models/sign_in_request_model.dart';
import '../models/auth_response_model.dart';
import '../models/sign_in_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signUp(SignUpRequestModel request);
  Future<SignInResponseModel> signIn(SignInRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponseModel> signUp(SignUpRequestModel request) async {
    final response = await dioClient.post(
      ApiConstants.registerEndpoint,
      data: request.toJson(),
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<SignInResponseModel> signIn(SignInRequestModel request) async {
    final response = await dioClient.post(
      ApiConstants.loginEndpoint,
      data: request.toJson(),
    );

    return SignInResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
