import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  group('WorkoutSet', () {
    final set = WorkoutSet(
      id: 'set1',
      exercise: Exercise.squat,
      weight: 100.0,
      repetitions: 10,
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 2),
      isDeleted: false,
    );

    test('copyWith updates fields', () {
      final updated = set.copyWith(weight: 120.0, isDeleted: true);
      expect(updated.weight, 120.0);
      expect(updated.isDeleted, true);
      expect(updated.id, set.id);
    });

    test('equality and hashCode', () {
      final same = set.copyWith();
      expect(set, same);
      expect(set.hashCode, same.hashCode);
    });

    test('toJson/fromJson roundtrip', () {
      final json = set.toJson();
      final fromJson = WorkoutSet.fromJson(json);
      expect(fromJson, set);
    });

    test('handles negative and zero values', () {
      final zeroSet = set.copyWith(weight: 0, repetitions: 0);
      expect(zeroSet.weight, 0);
      expect(zeroSet.repetitions, 0);
      final negativeSet = set.copyWith(weight: -10, repetitions: -5);
      expect(negativeSet.weight, -10);
      expect(negativeSet.repetitions, -5);
    });

    test('isDeleted flag is respected in serialization', () {
      final deleted = set.copyWith(isDeleted: true);
      final json = deleted.toJson();
      expect(json['isDeleted'], true);
      final fromJson = WorkoutSet.fromJson(json);
      expect(fromJson.isDeleted, true);
    });
  });
}
