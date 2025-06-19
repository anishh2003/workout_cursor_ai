import 'package:flutter/material.dart';

class WeightField extends StatelessWidget {
  const WeightField({required this.value, required this.onChanged, super.key});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Weight (kg)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        final weight = double.tryParse(text) ?? 0;
        onChanged(weight);
      },
      controller: TextEditingController(text: value.toString()),
    );
  }
}
