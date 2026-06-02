import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/car_entity.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/remove_history_usecase.dart';
import '../../domain/usecases/save_history_usecase.dart';

abstract class HistoryState {
  const HistoryState();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.history);

  final List<CarEntity> history;
}

class HistoryError extends HistoryState {
  const HistoryError(this.message);

  final String message;
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    required GetHistoryUseCase getHistoryUseCase,
    required SaveHistoryUseCase saveHistoryUseCase,
    required RemoveHistoryUseCase removeHistoryUseCase,
  }) : _getHistoryUseCase = getHistoryUseCase,
       _saveHistoryUseCase = saveHistoryUseCase,
       _removeHistoryUseCase = removeHistoryUseCase,
       super(const HistoryLoading());

  final GetHistoryUseCase _getHistoryUseCase;
  final SaveHistoryUseCase _saveHistoryUseCase;
  final RemoveHistoryUseCase _removeHistoryUseCase;

  Future<void> loadHistory() async {
    emit(const HistoryLoading());
    try {
      emit(HistoryLoaded(await _getHistoryUseCase()));
    } catch (error) {
      emit(HistoryError(error.toString()));
    }
  }

  Future<void> saveHistory(CarEntity car) async {
    await _saveHistoryUseCase(car);
    await loadHistory();
  }

  Future<void> removeHistory(int id) async {
    await _removeHistoryUseCase(id);
    await loadHistory();
  }
}
