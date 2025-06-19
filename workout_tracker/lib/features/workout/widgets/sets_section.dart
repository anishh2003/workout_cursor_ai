import 'package:flutter/material.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/features/workout/widgets/set_card.dart';

class SetsSection extends StatelessWidget {
  const SetsSection({
    required this.sets,
    required this.onSetsChanged,
    super.key,
  });

  final List<WorkoutSet> sets;
  final ValueChanged<List<WorkoutSet>> onSetsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sets : ', style: Theme.of(context).textTheme.titleMedium),
            ElevatedButton.icon(
              onPressed: () => _addSet(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Set'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (sets.isEmpty)
          const Center(
            child: Column(
              children: [
                Icon(Icons.fitness_center, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No sets added yet', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sets.length,
            itemBuilder: (context, index) {
              return SetCard(
                set: sets[index],
                onSetChanged: (updatedSet) {
                  final newSets = List<WorkoutSet>.from(sets);
                  newSets[index] = updatedSet;
                  onSetsChanged(newSets);
                },
                onDelete: () {
                  final newSets = List<WorkoutSet>.from(sets);
                  newSets.removeAt(index);
                  onSetsChanged(newSets);
                },
              );
            },
          ),
      ],
    );
  }

  void _addSet(BuildContext context) {
    final newSet = WorkoutSet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exercise: Exercise.benchPress,
      weight: 0,
      repetitions: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    onSetsChanged([...sets, newSet]);
  }
}
