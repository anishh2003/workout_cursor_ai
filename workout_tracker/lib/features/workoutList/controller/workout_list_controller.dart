import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/features/workoutList/repository/workout_list_repository.dart';

final workoutListControllerProvider =
    AsyncNotifierProvider<WorkoutListController, List<Workout>>(
      WorkoutListController.new,
    );

class WorkoutListController extends AsyncNotifier<List<Workout>> {
  @override
  Future<List<Workout>> build() async {
    final repository = ref.read(workoutListRepositoryProvider);
    return repository.getAllWorkouts();
  }

  Future<void> deleteWorkout(String id) async {
    final repository = ref.read(workoutListRepositoryProvider);
    await repository.deleteWorkout(id);
    ref.invalidateSelf();
  }

  Future<void> refreshWorkouts() async {
    ref.invalidateSelf();
  }
}
