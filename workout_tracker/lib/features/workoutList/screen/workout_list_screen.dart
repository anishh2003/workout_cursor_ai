import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';
import 'package:workout_tracker/features/workout/screen/workout_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_tracker/common/error_widget.dart';
import 'package:workout_tracker/common/date_format.dart';
import 'package:workout_tracker/features/workoutList/widgets/workout_list_content.dart';

class WorkoutListScreen extends ConsumerWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: workoutsAsync.when(
        data: (workouts) => WorkoutListContent(workouts: workouts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => ErrorWidgetCommon(error: error.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToWorkoutScreen(context),
        tooltip: 'Add Workout',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToWorkoutScreen(BuildContext context) {
    context.push('/workout');
  }
}
