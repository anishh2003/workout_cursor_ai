import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/workout.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository();
});

class WorkoutRepository {
  static const String _storageKey = 'workouts';

  Future<Workout?> getWorkoutById(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList(_storageKey) ?? [];

      for (final json in workoutsJson) {
        try {
          final workout = Workout.fromJson(jsonDecode(json));
          if (workout.id == id && !workout.isDeleted) {
            return workout;
          }
        } catch (e) {
          // Skip invalid JSON entries
          continue;
        }
      }
      return null;
    } catch (e) {
      print('Error getting workout: $e');
      return null;
    }
  }

  Future<void> saveWorkout(Workout workout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList(_storageKey) ?? [];

      // Remove existing workout if it exists
      workoutsJson.removeWhere((json) {
        try {
          final existingWorkout = Workout.fromJson(jsonDecode(json));
          return existingWorkout.id == workout.id;
        } catch (e) {
          return false;
        }
      });

      // Add new workout
      workoutsJson.add(jsonEncode(workout.toJson()));

      await prefs.setStringList(_storageKey, workoutsJson);
      print('Workout saved successfully: ${workout.name}');
    } catch (e) {
      print('Error saving workout: $e');
      throw Exception('Failed to save workout: $e');
    }
  }
}
