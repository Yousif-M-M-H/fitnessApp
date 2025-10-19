part of 'nutrition_cubit.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionSuccess extends NutritionState {
  final NutritionData data;

  const NutritionSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object> get props => [message];
}
