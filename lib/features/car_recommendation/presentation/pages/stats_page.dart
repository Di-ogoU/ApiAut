import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/stats_cubit.dart';
import '../widgets/class_bar_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StatsError) {
          return Center(child: Text(state.message));
        }

        final counts = (state as StatsLoaded).counts;
        final total = counts.values.fold<int>(0, (sum, item) => sum + item);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Conteo de clases guardadas en historial.'),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total de evaluaciones: $total'),
                    const SizedBox(height: 20),
                    ClassBarChart(counts: counts),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
