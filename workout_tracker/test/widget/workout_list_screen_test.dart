import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/features/workoutList/screen/workout_list_screen.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/models/workout_set.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/features/workoutList/controller/workout_list_controller.dart';

class LoadingWorkoutListController extends WorkoutListController {
  @override
  Future<List<Workout>> build() async {
    return Future.delayed(const Duration(days: 1));
  }
}

class ErrorWorkoutListController extends WorkoutListController {
  @override
  Future<List<Workout>> build() async {
    throw Exception('error');
  }
}

class DataWorkoutListController extends WorkoutListController {
  final List<Workout> data;
  DataWorkoutListController(this.data);
  @override
  Future<List<Workout>> build() async => data;
}

void main() {
  testWidgets('WorkoutListScreen displays title and empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListControllerProvider.overrideWith(
            () => DataWorkoutListController([]),
          ),
        ],
        child: const MaterialApp(home: WorkoutListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Workout Tracker'), findsOneWidget);
    expect(find.text('No workouts yet'), findsOneWidget);
  });

  testWidgets('WorkoutListScreen shows loading indicator', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListControllerProvider.overrideWith(
            LoadingWorkoutListController.new,
          ),
        ],
        child: const MaterialApp(home: WorkoutListScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('WorkoutListScreen shows error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListControllerProvider.overrideWith(
            ErrorWorkoutListController.new,
          ),
        ],
        child: const MaterialApp(home: WorkoutListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Error loading workouts'), findsOneWidget);
  });

  testWidgets('WorkoutListScreen shows a list of workouts', (tester) async {
    final workouts = [
      Workout(
        id: '1',
        name: 'Test Workout',
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
      ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutListControllerProvider.overrideWith(
            () => DataWorkoutListController(workouts),
          ),
        ],
        child: const MaterialApp(home: WorkoutListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Test Workout'), findsOneWidget);
  });
}
