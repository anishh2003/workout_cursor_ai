import 'package:flutter/material.dart';
import 'package:workout_tracker/models/exercise.dart';

class ExerciseDropdown extends StatelessWidget {
  const ExerciseDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Exercise value;
  final ValueChanged<Exercise?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Exercise>(
      value: value,
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Exercise',
        border: OutlineInputBorder(),
      ),
      items:
          Exercise.values.map((exercise) {
            return DropdownMenuItem(
              value: exercise,
              child: Text(exercise.displayName),
            );
          }).toList(),
    );
  }
}
