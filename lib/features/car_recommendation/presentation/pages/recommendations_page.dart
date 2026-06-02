import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/car_options.dart';
import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/history_cubit.dart';
import '../cubit/stats_cubit.dart';
import '../widgets/car_card.dart';
import '../widgets/priority_selector.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  String _priority = priorityOptions.first;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCubit, CarState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PrioritySelector(
              value: _priority,
              onChanged: (value) =>
                  setState(() => _priority = value ?? priorityOptions.first),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  context.read<CarCubit>().getRecommendations(_priority),
              child: const Text('Obtener recomendaciones'),
            ),
            const SizedBox(height: 20),
            if (state.status == CarViewStatus.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (state.recommendations.isNotEmpty)
              ...state.recommendations.map(
                (car) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CarCard(
                    car: car,
                    onSaveHistory: () async {
                      final historyCubit = context.read<HistoryCubit>();
                      final statsCubit = context.read<StatsCubit>();
                      await historyCubit.saveHistory(car);
                      await statsCubit.loadStats();
                    },
                    onSaveFavorite: () =>
                        context.read<FavoritesCubit>().saveFavorite(car),
                  ),
                ),
              )
            else if (state.status == CarViewStatus.loaded)
              const Text('No se encontraron resultados'),
          ],
        );
      },
    );
  }
}
