import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorites_cubit.dart';
import '../widgets/car_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FavoritesError) {
          return Center(child: Text(state.message));
        }

        final favorites = (state as FavoritesLoaded).favorites;
        if (favorites.isEmpty) {
          return const Center(
            child: Text('Todavía no hay favoritos guardados.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final car = favorites[index];
            return CarCard(
              car: car,
              onDelete: car.id == null
                  ? null
                  : () =>
                        context.read<FavoritesCubit>().removeFavorite(car.id!),
              deleteLabel: 'Quitar favorito',
            );
          },
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemCount: favorites.length,
        );
      },
    );
  }
}
