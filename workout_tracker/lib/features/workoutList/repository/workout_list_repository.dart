import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_tracker/models/workout.dart';

final workoutListRepositoryProvider = Provider<WorkoutListRepository>((ref) {
  return WorkoutListRepository();
});

class WorkoutListRepository {
  static const String _storageKey = 'workouts';

  Future<List<Workout>> getAllWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList(_storageKey) ?? [];

      final workouts = <Workout>[];
      for (final json in workoutsJson) {
        try {
          final workout = Workout.fromJson(jsonDecode(json));
          if (!workout.isDeleted) {
            workouts.add(workout);
          }
        } catch (e) {
          // Skip invalid JSON entries
          print('Error parsing workout: $e');
        }
      }

      // Sort by creation date, newest first
      workouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return workouts;
    } catch (e) {
      print('Error loading workouts: $e');
      return [];
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

  Future<void> deleteWorkout(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final workoutsJson = prefs.getStringList(_storageKey) ?? [];

      // Find and mark the workout as deleted
      final updatedWorkoutsJson =
          workoutsJson.map((json) {
            try {
              final workout = Workout.fromJson(jsonDecode(json));
              if (workout.id == id) {
                return jsonEncode(workout.copyWith(isDeleted: true).toJson());
              }
              return json;
            } catch (e) {
              return json;
            }
          }).toList();

      await prefs.setStringList(_storageKey, updatedWorkoutsJson);
      print('Workout deleted successfully: $id');
    } catch (e) {
      print('Error deleting workout: $e');
      throw Exception('Failed to delete workout: $e');
    }
  }

  Future<void> clearAllWorkouts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      print('All workouts cleared successfully');
    } catch (e) {
      print('Error clearing workouts: $e');
      throw Exception('Failed to clear workouts: $e');
    }
  }
}
