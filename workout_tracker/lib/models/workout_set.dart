import 'exercise.dart';

class WorkoutSet {
  final String id;
  final Exercise exercise;
  final double weight;
  final int repetitions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  const WorkoutSet({
    required this.id,
    required this.exercise,
    required this.weight,
    required this.repetitions,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  WorkoutSet copyWith({
    String? id,
    Exercise? exercise,
    double? weight,
    int? repetitions,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise': exercise.name,
      'weight': weight,
      'repetitions': repetitions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as String,
      exercise: Exercise.values.firstWhere(
        (e) => e.name == json['exercise'],
        orElse: () => Exercise.benchPress,
      ),
      weight: (json['weight'] as num).toDouble(),
      repetitions: json['repetitions'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutSet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'WorkoutSet(id: $id, exercise: $exercise, weight: $weight, repetitions: $repetitions)';
  }
}
