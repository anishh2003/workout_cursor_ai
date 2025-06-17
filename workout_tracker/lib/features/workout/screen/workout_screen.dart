import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/features/workout/controller/workout_controller.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key, this.workout});

  final Workout? workout;

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  late TextEditingController nameController;
  late List<WorkoutSet> sets;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.workout?.name ?? '');
    sets = widget.workout?.sets.toList() ?? [];
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'New Workout' : 'Edit Workout'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.workout != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _WorkoutNameField(controller: nameController),
            const SizedBox(height: 24),
            _SetsSection(
              sets: sets,
              onSetsChanged: (newSets) => setState(() => sets = newSets),
            ),
            const Spacer(),
            _SaveButton(
              nameController: nameController,
              sets: sets,
              workout: widget.workout,
              isLoading: isLoading,
              onLoadingChanged:
                  (loading) => setState(() => isLoading = loading),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    if (widget.workout == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Workout'),
            content: Text(
              'Are you sure you want to delete "${widget.workout!.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(workoutListControllerProvider.notifier)
                      .deleteWorkout(widget.workout!.id);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class _WorkoutNameField extends StatelessWidget {
  const _WorkoutNameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Workout Name',
        border: OutlineInputBorder(),
        hintText: 'e.g., Upper Body, Leg Day',
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
    );
  }
}

class _SetsSection extends StatelessWidget {
  const _SetsSection({required this.sets, required this.onSetsChanged});

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
            Text(
              'Sets (${sets.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
              return _SetCard(
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

class _SetCard extends StatelessWidget {
  const _SetCard({
    required this.set,
    required this.onSetChanged,
    required this.onDelete,
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
                  child: _ExerciseDropdown(
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
                  child: _WeightField(
                    value: set.weight,
                    onChanged: (weight) {
                      onSetChanged(set.copyWith(weight: weight));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _RepetitionsField(
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

class _ExerciseDropdown extends StatelessWidget {
  const _ExerciseDropdown({required this.value, required this.onChanged});

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

class _WeightField extends StatelessWidget {
  const _WeightField({required this.value, required this.onChanged});

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

class _RepetitionsField extends StatelessWidget {
  const _RepetitionsField({required this.value, required this.onChanged});

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

class _SaveButton extends ConsumerWidget {
  const _SaveButton({
    required this.nameController,
    required this.sets,
    required this.workout,
    required this.isLoading,
    required this.onLoadingChanged,
  });

  final TextEditingController nameController;
  final List<WorkoutSet> sets;
  final Workout? workout;
  final bool isLoading;
  final ValueChanged<bool> onLoadingChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValid = nameController.text.trim().isNotEmpty && sets.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isValid && !isLoading ? () => _saveWorkout(context, ref) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(workout == null ? 'Save Workout' : 'Update Workout'),
      ),
    );
  }

  Future<void> _saveWorkout(BuildContext context, WidgetRef ref) async {
    final name = nameController.text.trim();
    if (name.isEmpty || sets.isEmpty) return;

    onLoadingChanged(true);

    try {
      if (workout == null) {
        await ref
            .read(workoutControllerProvider.notifier)
            .addWorkout(name, sets);
      } else {
        final updatedWorkout = workout!.copyWith(name: name, sets: sets);
        await ref
            .read(workoutControllerProvider.notifier)
            .updateWorkout(updatedWorkout);
      }

      // Invalidate the workout list to refresh it
      ref.invalidate(workoutListControllerProvider);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving workout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      onLoadingChanged(false);
    }
  }
}
