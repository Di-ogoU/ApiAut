import 'package:flutter/material.dart';

import '../../../../core/utils/class_label_mapper.dart';
import '../../domain/entities/car_entity.dart';

class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    this.onSaveHistory,
    this.onSaveFavorite,
    this.onDelete,
    this.deleteLabel = 'Eliminar',
  });

  final CarEntity car;
  final VoidCallback? onSaveHistory;
  final VoidCallback? onSaveFavorite;
  final VoidCallback? onDelete;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classLabel(car.className),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Badge(label: 'Compra', value: car.buying),
                _Badge(label: 'Mant.', value: car.maint),
                _Badge(label: 'Puertas', value: car.doors),
                _Badge(label: 'Capacidad', value: car.persons),
                _Badge(label: 'Maletero', value: car.lugBoot),
                _Badge(label: 'Seguridad', value: car.safety),
              ],
            ),
            if (car.createdAt != null) ...[
              const SizedBox(height: 12),
              Text('Guardado: ${car.createdAt!.toLocal()}'),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (onSaveHistory != null)
                  FilledButton.tonal(
                    onPressed: onSaveHistory,
                    child: const Text('Guardar historial'),
                  ),
                if (onSaveFavorite != null)
                  FilledButton(
                    onPressed: onSaveFavorite,
                    child: const Text('Guardar favorito'),
                  ),
                if (onDelete != null)
                  OutlinedButton(onPressed: onDelete, child: Text(deleteLabel)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$label: $value'),
    );
  }
}
