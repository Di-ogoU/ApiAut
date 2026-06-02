import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/evaluate_car_usecase.dart';
import '../../domain/usecases/get_cars_usecase.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  CarCubit({
    required GetCarsUseCase getCarsUseCase,
    required EvaluateCarUseCase evaluateCarUseCase,
    required GetRecommendationsUseCase getRecommendationsUseCase,
  }) : _getCarsUseCase = getCarsUseCase,
       _evaluateCarUseCase = evaluateCarUseCase,
       _getRecommendationsUseCase = getRecommendationsUseCase,
       super(const CarState());

  final GetCarsUseCase _getCarsUseCase;
  final EvaluateCarUseCase _evaluateCarUseCase;
  final GetRecommendationsUseCase _getRecommendationsUseCase;

  Future<void> getCars(Map<String, String> filters) async {
    emit(state.copyWith(status: CarViewStatus.loading, clearMessage: true));
    try {
      final cars = await _getCarsUseCase(filters);
      emit(
        state.copyWith(
          status: CarViewStatus.loaded,
          filteredCars: cars,
          clearEvaluatedCar: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(status: CarViewStatus.error, message: error.toString()),
      );
    }
  }

  Future<void> evaluateCar(Map<String, String> payload) async {
    emit(state.copyWith(status: CarViewStatus.loading, clearMessage: true));
    try {
      final car = await _evaluateCarUseCase(payload);
      emit(state.copyWith(status: CarViewStatus.evaluated, evaluatedCar: car));
    } catch (error) {
      emit(
        state.copyWith(status: CarViewStatus.error, message: error.toString()),
      );
    }
  }

  Future<void> getRecommendations(String priority, {int limit = 10}) async {
    emit(
      state.copyWith(
        status: CarViewStatus.loading,
        activePriority: priority,
        clearMessage: true,
      ),
    );
    try {
      final cars = await _getRecommendationsUseCase(priority, limit: limit);
      emit(
        state.copyWith(
          status: CarViewStatus.loaded,
          recommendations: cars,
          activePriority: priority,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(status: CarViewStatus.error, message: error.toString()),
      );
    }
  }

  void clearResults() {
    emit(const CarState());
  }
}
