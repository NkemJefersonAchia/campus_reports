# Campus Reports

A mobile application for reporting and managing campus infrastructure incidents at African Leadership University. Built with Flutter and Firebase.

## What It Does

Students use the app to report campus issues like broken facilities, water shortages, electricity outages, and safety concerns. Staff members review those reports, update their status, and notify students when things get resolved. Every report goes through a lifecycle: Submitted, In Progress, Resolved, or Rejected.

## Features

- Student registration restricted to ALU email domains with email verification
- Incident reporting with category, location, priority, description, and optional photo
- Anonymous reporting option
- Real-time status updates powered by Firestore streams
- In-app notifications when a report's status changes
- Role-based dashboards (student view and staff view)
- Light and dark mode support
- Pull-to-refresh and search/filter on report lists

## Tech Stack

- Flutter (Dart) for the cross-platform UI
- Firebase Auth for registration and login
- Cloud Firestore for real-time data storage
- Firebase Storage for photo uploads
- Riverpod for state management
- go_router for declarative navigation with auth and role guards

## Architecture

The app follows a feature-first clean architecture with four layers:

1. Presentation - screens, widgets, navigation
2. State Management - Riverpod providers that expose Firestore streams
3. Data - repository classes and Dart model classes
4. Backend - Firebase Auth, Firestore, and Storage

## Project Structure

```
lib/
  core/
    constants/       app-wide constants
    providers/       cross-cutting Riverpod providers
    theme/           colors, typography, spacing
    utils/           validators, helpers, extensions
    widgets/         22 reusable UI components
  features/
    auth/            user model, auth repository, login/register screens
    incidents/       incident model, incident repository, report screens
    notifications/   notification model and repository
    profile/         profile screen
    staff/           staff dashboard screen
  routing/           GoRouter config with ShellRoutes for student and staff
  main.dart          app entry point
  firebase_options.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Set up a Firebase project and add your own `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)
4. Run `flutter run --no-enable-impeller` (Impeller may cause a black screen on some emulators)

## Security

Access control is enforced at two levels:

- Client side: GoRouter redirects based on auth state, email verification, and user role
- Server side: Firestore security rules validate every read and write, enforce role checks, and restrict field modifications

The Firestore rules are in `firestore.rules` and the Storage rules are in `storage.rules`.

## Testing

Run tests with `flutter test`. The test suite covers:

- Email domain validation, password strength, and field bounds
- Status and priority helper functions
- String and date extensions
- Incident filter logic and report statistics
- User, incident, and notification model serialization
- Image picker helper validation
- Widget tests for login, register, and report forms

## Course

Mobile Application Development, African Leadership University, November 2026.
