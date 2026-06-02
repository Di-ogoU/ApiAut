import 'package:flutter/material.dart';

import '../../../../core/constants/car_options.dart';

class PrioritySelector extends StatelessWidget {
  const PrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Prioridad',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: priorityOptions
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(priorityLabels[option] ?? option),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
