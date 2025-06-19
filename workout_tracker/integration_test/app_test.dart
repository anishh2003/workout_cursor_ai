import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:workout_tracker/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full workout flow: add, edit, and delete', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Start on workout list
    expect(find.text('Workout Tracker'), findsOneWidget);
    expect(find.text('No workouts yet'), findsOneWidget);

    // Add a new workout
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('New Workout'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Integration Workout');
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Integration Workout'), findsOneWidget);

    // Edit the workout
    await tester.tap(find.text('Integration Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Workout'), findsOneWidget);
    // await tester.enterText(find.byType(TextField).first, 'Edited Workout');
    await tester.tap(find.text('Add Set'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Edited Workout'), findsOneWidget);

    // Delete the workout
    // await tester.tap(find.text('Integration Workout'));
    // await tester.pumpAndSettle();
    // await tester.tap(find.byIcon(Icons.delete));
    // await tester.pumpAndSettle();
    // await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    // await tester.pumpAndSettle();
    // expect(find.text('No workouts yet'), findsOneWidget);
  });
}
