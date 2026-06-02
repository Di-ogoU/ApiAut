import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/car_entity.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import '../../domain/usecases/save_favorite_usecase.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(this.favorites);

  final List<CarEntity> favorites;
}

class FavoritesError extends FavoritesState {
  const FavoritesError(this.message);

  final String message;
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required GetFavoritesUseCase getFavoritesUseCase,
    required SaveFavoriteUseCase saveFavoriteUseCase,
    required RemoveFavoriteUseCase removeFavoriteUseCase,
  }) : _getFavoritesUseCase = getFavoritesUseCase,
       _saveFavoriteUseCase = saveFavoriteUseCase,
       _removeFavoriteUseCase = removeFavoriteUseCase,
       super(const FavoritesLoading());

  final GetFavoritesUseCase _getFavoritesUseCase;
  final SaveFavoriteUseCase _saveFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      emit(FavoritesLoaded(await _getFavoritesUseCase()));
    } catch (error) {
      emit(FavoritesError(error.toString()));
    }
  }

  Future<void> saveFavorite(CarEntity car) async {
    await _saveFavoriteUseCase(car);
    await loadFavorites();
  }

  Future<void> removeFavorite(int id) async {
    await _removeFavoriteUseCase(id);
    await loadFavorites();
  }
}
