import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  group('Exercise', () {
    test('displayName returns correct string', () {
      expect(Exercise.barbellRow.displayName, 'Barbell Row');
      expect(Exercise.benchPress.displayName, 'Bench Press');
      expect(Exercise.shoulderPress.displayName, 'Shoulder Press');
      expect(Exercise.deadlift.displayName, 'Deadlift');
      expect(Exercise.squat.displayName, 'Squat');
    });

    test('Exercise.values contains all exercises', () {
      expect(Exercise.values.length, 5);
    });
  });
}
