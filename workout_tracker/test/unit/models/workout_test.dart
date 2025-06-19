import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  group('Workout', () {
    final workout = Workout(
      id: '1',
      name: 'Test',
      sets: [
        WorkoutSet(
          id: 'set1',
          exercise: Exercise.benchPress,
          weight: 10,
          repetitions: 5,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      ],
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
    );

    test('copyWith returns a new instance with updated values', () {
      final updated = workout.copyWith(name: 'Updated');
      expect(updated.name, 'Updated');
      expect(updated.id, workout.id);
    });

    test('equality works as expected', () {
      final same = workout.copyWith();
      expect(workout, same);
    });

    test('toJson/fromJson roundtrip', () {
      final json = workout.toJson();
      final fromJson = Workout.fromJson(json);
      expect(fromJson, workout);
    });
  });
}
