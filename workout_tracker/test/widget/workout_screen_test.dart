import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/features/workout/screen/workout_screen.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';

void main() {
  testWidgets('WorkoutScreen displays new workout title and save button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WorkoutScreen())),
    );
    expect(find.text('New Workout'), findsOneWidget);
    expect(find.text('Save Workout'), findsOneWidget);
  });

  testWidgets('WorkoutScreen displays edit workout title', (tester) async {
    final workout = Workout(
      id: '1',
      name: 'Edit Me',
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
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: WorkoutScreen(workout: workout))),
    );
    expect(find.text('Edit Workout'), findsOneWidget);
    expect(find.text('Update Workout'), findsOneWidget);
  });

  // You can add more tests for loading/error states if you mock the providers.
}
