import '../../domain/entities/car_entity.dart';

enum CarViewStatus { initial, loading, loaded, evaluated, error }

class CarState {
  const CarState({
    this.status = CarViewStatus.initial,
    this.filteredCars = const [],
    this.recommendations = const [],
    this.evaluatedCar,
    this.message,
    this.activePriority = 'safe',
  });

  final CarViewStatus status;
  final List<CarEntity> filteredCars;
  final List<CarEntity> recommendations;
  final CarEntity? evaluatedCar;
  final String? message;
  final String activePriority;

  CarState copyWith({
    CarViewStatus? status,
    List<CarEntity>? filteredCars,
    List<CarEntity>? recommendations,
    CarEntity? evaluatedCar,
    bool clearEvaluatedCar = false,
    String? message,
    bool clearMessage = false,
    String? activePriority,
  }) {
    return CarState(
      status: status ?? this.status,
      filteredCars: filteredCars ?? this.filteredCars,
      recommendations: recommendations ?? this.recommendations,
      evaluatedCar: clearEvaluatedCar
          ? null
          : (evaluatedCar ?? this.evaluatedCar),
      message: clearMessage ? null : (message ?? this.message),
      activePriority: activePriority ?? this.activePriority,
    );
  }
}
