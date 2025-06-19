import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/features/workout/controller/workout_controller.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';
import 'package:workout_tracker/features/workout/widgets/workout_name_field.dart';
import 'package:workout_tracker/features/workout/widgets/sets_section.dart';
import 'package:workout_tracker/features/workout/widgets/save_button.dart';

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
            WorkoutNameField(controller: nameController),
            const SizedBox(height: 24),
            SetsSection(
              sets: sets,
              onSetsChanged: (newSets) => setState(() => sets = newSets),
            ),
            const Spacer(),
            SaveButton(
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
