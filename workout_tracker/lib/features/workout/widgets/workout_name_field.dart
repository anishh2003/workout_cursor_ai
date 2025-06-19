import 'package:flutter/material.dart';

class WorkoutNameField extends StatelessWidget {
  const WorkoutNameField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Workout Name',
        border: OutlineInputBorder(),
        hintText: 'e.g., Upper Body, Leg Day',
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
    );
  }
}
