import 'package:flutter/material.dart';

import '../../../../core/constants/car_options.dart';

class CarFilterForm extends StatelessWidget {
  const CarFilterForm({
    super.key,
    required this.values,
    required this.onChanged,
  });

  final Map<String, String?> values;
  final void Function(String key, String? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DropdownField(
          label: 'buying',
          value: values['buying'],
          options: buyingOptions,
          onChanged: (value) => onChanged('buying', value),
        ),
        _DropdownField(
          label: 'maint',
          value: values['maint'],
          options: maintOptions,
          onChanged: (value) => onChanged('maint', value),
        ),
        _DropdownField(
          label: 'doors',
          value: values['doors'],
          options: doorsOptions,
          onChanged: (value) => onChanged('doors', value),
        ),
        _DropdownField(
          label: 'persons',
          value: values['persons'],
          options: personsOptions,
          onChanged: (value) => onChanged('persons', value),
        ),
        _DropdownField(
          label: 'lug_boot',
          value: values['lug_boot'],
          options: lugBootOptions,
          onChanged: (value) => onChanged('lug_boot', value),
        ),
        _DropdownField(
          label: 'safety',
          value: values['safety'],
          options: safetyOptions,
          onChanged: (value) => onChanged('safety', value),
        ),
        _DropdownField(
          label: 'class',
          value: values['class_name'],
          options: classOptions,
          onChanged: (value) => onChanged('class_name', value),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        items: [
          const DropdownMenuItem<String>(value: null, child: Text('Todos')),
          ...options.map(
            (option) =>
                DropdownMenuItem<String>(value: option, child: Text(option)),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
