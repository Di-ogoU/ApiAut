import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorites_cubit.dart';
import '../cubit/history_cubit.dart';
import '../cubit/stats_cubit.dart';
import '../widgets/car_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HistoryError) {
          return Center(child: Text(state.message));
        }

        final history = (state as HistoryLoaded).history;
        if (history.isEmpty) {
          return const Center(
            child: Text('Todavía no hay evaluaciones guardadas.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final car = history[index];
            return CarCard(
              car: car,
              onSaveFavorite: () =>
                  context.read<FavoritesCubit>().saveFavorite(car),
              onDelete: car.id == null
                  ? null
                  : () async {
                      final historyCubit = context.read<HistoryCubit>();
                      final statsCubit = context.read<StatsCubit>();
                      await historyCubit.removeHistory(car.id!);
                      await statsCubit.loadStats();
                    },
            );
          },
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemCount: history.length,
        );
      },
    );
  }
}
