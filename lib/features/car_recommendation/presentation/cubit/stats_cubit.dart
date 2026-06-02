import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_history_usecase.dart';

abstract class StatsState {
  const StatsState();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  const StatsLoaded(this.counts);

  final Map<String, int> counts;
}

class StatsError extends StatsState {
  const StatsError(this.message);

  final String message;
}

class StatsCubit extends Cubit<StatsState> {
  StatsCubit({required GetHistoryUseCase getHistoryUseCase})
    : _getHistoryUseCase = getHistoryUseCase,
      super(const StatsLoading());

  final GetHistoryUseCase _getHistoryUseCase;

  Future<void> loadStats() async {
    emit(const StatsLoading());
    try {
      final history = await _getHistoryUseCase();
      final counts = await compute(
        _countClasses,
        history.map((item) => item.className).toList(),
      );
      emit(StatsLoaded(counts));
    } catch (error) {
      emit(StatsError(error.toString()));
    }
  }
}

Map<String, int> _countClasses(List<String> classNames) {
  const defaults = {'unacc': 0, 'acc': 0, 'good': 0, 'vgood': 0};
  final counts = <String, int>{...defaults};
  for (final className in classNames) {
    counts[className] = (counts[className] ?? 0) + 1;
  }
  return counts;
}
