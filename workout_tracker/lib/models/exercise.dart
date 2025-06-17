enum Exercise { barbellRow, benchPress, shoulderPress, deadlift, squat }

extension ExerciseExtension on Exercise {
  String get displayName {
    switch (this) {
      case Exercise.barbellRow:
        return 'Barbell Row';
      case Exercise.benchPress:
        return 'Bench Press';
      case Exercise.shoulderPress:
        return 'Shoulder Press';
      case Exercise.deadlift:
        return 'Deadlift';
      case Exercise.squat:
        return 'Squat';
    }
  }
}
