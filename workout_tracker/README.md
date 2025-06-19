# Workout Tracker

A cross-platform Flutter app to track your workouts, built with Riverpod, GoRouter, and best practices for maintainability and performance.

## Features
- Add, edit, and delete workouts
- Track sets, exercises, weights, and repetitions
- Persistent local storage
- Responsive UI with Material 3
- Riverpod for state management
- GoRouter for navigation
- Comprehensive unit, widget, and integration tests

## Project Structure
```
lib/
  ├── main.dart
  ├── router/           # App routing (GoRouter)
  ├── theme/            # Theme and style definitions
  ├── common/           # Reusable widgets and helpers
  ├── models/           # Data models (Workout, Exercise, etc.)
  └── features/
      ├── workout/      # Single workout feature (controller, repository, screen, widgets)
      └── workoutList/  # Workout list feature (controller, repository, screen, widgets)
```

## Getting Started
1. **Install dependencies:**
   ```sh
   flutter pub get
   ```
2. **Run the app:**
   ```sh
   flutter run
   ```
3. **Run tests:**
   - Unit & widget tests:
     ```sh
     flutter test
     ```
   - Integration tests:
     ```sh
     flutter test integration_test/app_test.dart
     ```

## Testing
- **Unit tests:** `test/unit/`
- **Widget tests:** `test/widget/`
- **Integration tests:** `integration_test/`

## Coding Standards
- Uses Riverpod's for state management
- Follows best practices for error handling, theming, and file structure
- See `.cursor/rules/project-rules.mdc` for detailed project rules

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## License
[MIT](LICENSE)
