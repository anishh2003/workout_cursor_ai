import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/features/workoutList/repository/workout_list_repository.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WorkoutListRepository', () {
    late WorkoutListRepository repository;
    late Workout workout;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = WorkoutListRepository();
      workout = Workout(
        id: '1',
        name: 'Test',
        sets: [
          WorkoutSet(
            id: 'set1',
            exercise: Exercise.squat,
            weight: 100.0,
            repetitions: 10,
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime(2023, 1, 2),
          ),
        ],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 2),
      );
    });

    test('add and getAllWorkouts', () async {
      await repository.saveWorkout(workout);
      final workouts = await repository.getAllWorkouts();
      expect(workouts.length, 1);
      expect(workouts.first, workout);
    });

    test('deleteWorkout marks as deleted', () async {
      await repository.saveWorkout(workout);
      await repository.deleteWorkout(workout.id);
      final workouts = await repository.getAllWorkouts();
      expect(workouts, isEmpty);
    });

    test('clearAllWorkouts removes all', () async {
      await repository.saveWorkout(workout);
      await repository.clearAllWorkouts();
      final workouts = await repository.getAllWorkouts();
      expect(workouts, isEmpty);
    });

    test('getAllWorkouts skips deleted', () async {
      final deleted = workout.copyWith(isDeleted: true);
      await repository.saveWorkout(deleted);
      final workouts = await repository.getAllWorkouts();
      expect(workouts, isEmpty);
    });

    test('handles corrupted data gracefully', () async {
      SharedPreferences.setMockInitialValues({
        'workouts': ['not a json'],
      });
      final workouts = await repository.getAllWorkouts();
      expect(workouts, isEmpty);
    });
  });
}
