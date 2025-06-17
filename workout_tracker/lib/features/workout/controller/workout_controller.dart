import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/features/workout/repository/workout_repository.dart';

final workoutControllerProvider =
    AsyncNotifierProvider<WorkoutController, void>(WorkoutController.new);

class WorkoutController extends AsyncNotifier<void> {
  final _uuid = const Uuid();

  @override
  Future<void> build() async {
    // This controller doesn't maintain state, it just provides methods
  }

  Future<void> addWorkout(String name, List<WorkoutSet> sets) async {
    final repository = ref.read(workoutRepositoryProvider);
    final now = DateTime.now();
    final workout = Workout(
      id: _uuid.v4(),
      name: name,
      sets: sets,
      createdAt: now,
      updatedAt: now,
    );
    await repository.saveWorkout(workout);
  }

  Future<void> updateWorkout(Workout workout) async {
    final repository = ref.read(workoutRepositoryProvider);
    final updatedWorkout = workout.copyWith(updatedAt: DateTime.now());
    await repository.saveWorkout(updatedWorkout);
  }

  WorkoutSet createWorkoutSet({
    required Exercise exercise,
    required double weight,
    required int repetitions,
  }) {
    final now = DateTime.now();
    return WorkoutSet(
      id: _uuid.v4(),
      exercise: exercise,
      weight: weight,
      repetitions: repetitions,
      createdAt: now,
      updatedAt: now,
    );
  }
}

final workoutByIdProvider = FutureProvider.family<Workout?, String>((
  ref,
  id,
) async {
  final repository = ref.read(workoutRepositoryProvider);
  return repository.getWorkoutById(id);
});
