import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/car_cubit.dart';
import '../cubit/car_state.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/history_cubit.dart';
import '../cubit/stats_cubit.dart';
import '../widgets/car_card.dart';
import '../widgets/car_filter_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String?> _filters = {
    'buying': null,
    'maint': null,
    'doors': null,
    'persons': null,
    'lug_boot': null,
    'safety': null,
    'class_name': null,
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarCubit, CarState>(
      listener: (context, state) {
        if (state.status == CarViewStatus.error && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final carCubit = context.read<CarCubit>();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Filtra combinaciones o evalúa una configuración exacta.',
            ),
            const SizedBox(height: 16),
            CarFilterForm(
              values: _filters,
              onChanged: (key, value) => setState(() => _filters[key] = value),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: () => carCubit.getCars(
                    _activeFilters(includeClass: true)
                      ..putIfAbsent('limit', () => '20'),
                  ),
                  child: const Text('Buscar autos'),
                ),
                FilledButton.tonal(
                  onPressed: _canEvaluate()
                      ? () => carCubit.evaluateCar(
                          _activeFilters(includeClass: false),
                        )
                      : null,
                  child: const Text('Evaluar combinación'),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (final key in _filters.keys) {
                        _filters[key] = null;
                      }
                    });
                    carCubit.clearResults();
                  },
                  child: const Text('Limpiar filtros'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (state.status == CarViewStatus.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (state.evaluatedCar != null) ...[
              const Text(
                'Resultado de evaluación',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CarCard(
                car: state.evaluatedCar!,
                onSaveHistory: () async {
                  final historyCubit = context.read<HistoryCubit>();
                  final statsCubit = context.read<StatsCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  await historyCubit.saveHistory(state.evaluatedCar!);
                  await statsCubit.loadStats();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Guardado en historial')),
                  );
                },
                onSaveFavorite: () async {
                  final favoritesCubit = context.read<FavoritesCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  await favoritesCubit.saveFavorite(state.evaluatedCar!);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Guardado en favoritos')),
                  );
                },
              ),
            ],
            if (state.filteredCars.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Resultados (${state.filteredCars.length})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...state.filteredCars.map(
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
              ),
            ] else if (state.status == CarViewStatus.loaded) ...[
              const SizedBox(height: 20),
              const Text('No se encontraron resultados'),
            ],
          ],
        );
      },
    );
  }

  Map<String, String> _activeFilters({required bool includeClass}) {
    final result = <String, String>{};
    _filters.forEach((key, value) {
      if (value == null) {
        return;
      }
      if (!includeClass && key == 'class_name') {
        return;
      }
      result[key] = value;
    });
    return result;
  }

  bool _canEvaluate() {
    return _filters['buying'] != null &&
        _filters['maint'] != null &&
        _filters['doors'] != null &&
        _filters['persons'] != null &&
        _filters['lug_boot'] != null &&
        _filters['safety'] != null;
  }
}
