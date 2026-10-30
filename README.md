# Campus Reports

A Flutter mobile application for reporting and managing campus incidents at African Leadership University (ALU).

## Features

- **Incident Reporting**: Students can report campus issues (broken facilities, water shortages, electricity outages, safety concerns)
- **Role-Based Access**: Separate dashboards for students and staff
- **Real-Time Updates**: Live status tracking using Firebase Cloud Firestore
- **Photo Evidence**: Attach photos to incident reports via camera or gallery
- **Notifications**: In-app notifications when incident status changes
- **Anonymous Reporting**: Option to submit reports anonymously

## Tech Stack

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Auth, Cloud Firestore, Storage)
- **State Management**: Riverpod
- **Routing**: go_router with auth guards
- **Architecture**: Feature-first clean architecture

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase using FlutterFire CLI
4. Run `flutter run --no-enable-impeller`

## Project Structure

```
lib/
├── core/           # Theme, constants, utilities, shared widgets
├── features/       # Feature modules (auth, incidents, notifications, profile, staff)
├── routing/        # GoRouter configuration and shell widgets
└── main.dart       # App entry point
```

## License

This project is part of the ALU Mobile Application Development course.

## Testing

Run tests with:
\`\`\`bash
flutter test
\`\`\`

Current test coverage includes:
- Validators (email domain, password strength, field bounds)
- Status and priority helpers (colors, labels, icons)
- String and DateTime extensions
- Incident filter and report stats models
