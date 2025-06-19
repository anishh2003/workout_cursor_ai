import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';
import 'package:workout_tracker/features/workoutList/widgets/workout_card.dart';

class WorkoutListContent extends ConsumerWidget {
  const WorkoutListContent({required this.workouts, super.key});

  final List<Workout> workouts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (workouts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No workouts yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first workout',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(workoutListControllerProvider.notifier).refreshWorkouts();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return WorkoutCard(workout: workout);
        },
      ),
    );
  }
}
