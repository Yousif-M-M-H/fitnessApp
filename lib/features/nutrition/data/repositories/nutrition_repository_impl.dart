import '../datasources/nutrition_remote_datasource.dart';
import '../models/nutrition_request_model.dart';
import '../models/nutrition_response_model.dart';

abstract class NutritionRepository {
  Future<NutritionResponseModel> calculateNutrition(
    NutritionRequestModel request,
    String token,
  );
}

class NutritionRepositoryImpl implements NutritionRepository {
  final NutritionRemoteDataSource remoteDataSource;

  NutritionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NutritionResponseModel> calculateNutrition(
    NutritionRequestModel request,
    String token,
  ) async {
    return await remoteDataSource.calculateNutrition(request, token);
  }
}
