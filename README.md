# Flutter Portfolio App

Multi-screen Flutter app with global state management using Provider.

## Structure

lib/
  core/
    routes/app_routes.dart
    theme/app_theme.dart
  state/
    app_state.dart
  presentation/
    pages/
      dashboard/dashboard_page.dart
      activity_one/activity_one_page.dart
      activity_two/activity_two_page.dart
      settings/settings_page.dart
    widgets/
      activity_card.dart
  main.dart

## Features

- Home Dashboard with navigation to two Activity screens and a Settings screen
- StatelessWidget used for the reusable ActivityCard
- StatefulWidget used for local interactions in Activity One (counter) and Activity Two (text input)
- Responsive grid layout using LayoutBuilder, GridView, Row, Column, and Expanded
- Global state via Provider: dark/light theme toggle and profile name, both updating the Dashboard instantly from the Settings screen

## Run

flutter pub get
flutter run
