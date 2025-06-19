import 'package:flutter/material.dart';

class RepetitionsField extends StatelessWidget {
  const RepetitionsField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Repetitions',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChanged: (text) {
        final repetitions = int.tryParse(text) ?? 0;
        onChanged(repetitions);
      },
      controller: TextEditingController(text: value.toString()),
    );
  }
}
