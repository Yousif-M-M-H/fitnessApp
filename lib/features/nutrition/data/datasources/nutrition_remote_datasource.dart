import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/nutrition_request_model.dart';
import '../models/nutrition_response_model.dart';

abstract class NutritionRemoteDataSource {
  Future<NutritionResponseModel> calculateNutrition(
    NutritionRequestModel request,
    String token,
  );
}

class NutritionRemoteDataSourceImpl implements NutritionRemoteDataSource {
  final DioClient dioClient;

  NutritionRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NutritionResponseModel> calculateNutrition(
    NutritionRequestModel request,
    String token,
  ) async {
    final response = await dioClient.post(
      ApiConstants.nutritionCalculateEndpoint,
      data: request.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    return NutritionResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
