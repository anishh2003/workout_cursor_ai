import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/features/workout/controller/workout_controller.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';

class SaveButton extends ConsumerWidget {
  const SaveButton({
    required this.nameController,
    required this.sets,
    required this.workout,
    required this.isLoading,
    required this.onLoadingChanged,
    super.key,
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
