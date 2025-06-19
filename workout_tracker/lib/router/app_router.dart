import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_tracker/features/workoutList/screen/workout_list_screen.dart';
import 'package:workout_tracker/features/workout/screen/workout_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WorkoutListScreen(),
      routes: [
        GoRoute(
          path: 'workout',
          builder: (context, state) {
            final workout = state.extra as dynamic;
            return WorkoutScreen(workout: workout);
          },
        ),
      ],
    ),
  ],
);
