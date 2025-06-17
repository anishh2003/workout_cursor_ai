import 'workout_set.dart';

class Workout {
  final String id;
  final String name;
  final List<WorkoutSet> sets;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  const Workout({
    required this.id,
    required this.name,
    required this.sets,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  Workout copyWith({
    String? id,
    String? name,
    List<WorkoutSet>? sets,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets.map((set) => set.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      name: json['name'] as String,
      sets:
          (json['sets'] as List<dynamic>)
              .map(
                (setJson) =>
                    WorkoutSet.fromJson(setJson as Map<String, dynamic>),
              )
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workout && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Workout(id: $id, name: $name, sets: $sets)';
  }
}
