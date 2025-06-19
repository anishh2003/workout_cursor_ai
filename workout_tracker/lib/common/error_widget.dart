import 'package:flutter/material.dart';

class ErrorWidgetCommon extends StatelessWidget {
  const ErrorWidgetCommon({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText.rich(
          TextSpan(
            text: 'Error loading workouts:\n',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.red),
            children: [
              TextSpan(
                text: error,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
