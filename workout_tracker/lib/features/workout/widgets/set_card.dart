import 'package:flutter/material.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/features/workout/widgets/exercise_dropdown.dart';
import 'package:workout_tracker/features/workout/widgets/weight_field.dart';
import 'package:workout_tracker/features/workout/widgets/repetitions_field.dart';

class SetCard extends StatelessWidget {
  const SetCard({
    required this.set,
    required this.onSetChanged,
    required this.onDelete,
    super.key,
  });

  final WorkoutSet set;
  final ValueChanged<WorkoutSet> onSetChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ExerciseDropdown(
                    value: set.exercise,
                    onChanged: (exercise) {
                      if (exercise != null) {
                        onSetChanged(set.copyWith(exercise: exercise));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Set',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: WeightField(
                    value: set.weight,
                    onChanged: (weight) {
                      onSetChanged(set.copyWith(weight: weight));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RepetitionsField(
                    value: set.repetitions,
                    onChanged: (repetitions) {
                      onSetChanged(set.copyWith(repetitions: repetitions));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
