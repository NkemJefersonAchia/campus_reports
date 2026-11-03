# Testing Summary

## Testing Strategy

### Unit Tests
- **Model serialization**: Verify `fromFirestore` and `toMap` round-trip correctly for `UserModel`, `IncidentModel`, `StatusHistoryEntry`, and `NotificationModel`
- **Validators**: Test all validation functions (`email`, `password`, `confirmPassword`, `fullName`, `incidentTitle`, `incidentDescription`) with valid, invalid, and edge-case inputs
- **Time helpers**: Test `greeting()` for morning/afternoon/evening, `relativeTime()` for various durations

### Widget Tests
- **Login/Register forms**: Validate that error messages appear for invalid input, buttons are disabled during loading
- **New Report form**: Category selection, required field validation, character counter behavior
- **Status timeline**: Renders correct number of entries with proper colors

### Integration Tests
- **Auth flow**: Register → verify email → login → redirect to correct shell
- **Report lifecycle**: Create incident → appears in list → detail view → staff updates status → notification created
- **Role-based routing**: Students redirected away from staff routes and vice versa

### Manual Testing Checklist
- [ ] Register with ALU email, verify email
- [ ] Login/logout persistence
- [ ] Submit incident with photo
- [ ] Browse and filter reports
- [ ] Staff updates incident status
- [ ] Notifications appear on status change
- [ ] Dark mode renders correctly
- [ ] Offline mode shows cached data
- [ ] Pull-to-refresh works on reports list

## Test Accounts for Demo

1. **Student**: Register via the app with an `@alustudent.com` email
2. **Staff**: Change the student's role to `"staff"` in Firestore Console (`users/{uid}.role`)

## Day 2 Updates

### New Unit Tests Added
- `status_helpers_test.dart` — Tests for status display names
- `priority_helpers_test.dart` — Tests for priority labels and case handling

### New Utilities Added
- LoadingIndicator, ErrorDisplay widgets
- Confirmation dialog and snackbar helpers
- Priority and status helper functions
- Connectivity check utility
- Barrel export files for cleaner imports

## Day 3 Updates

### New Unit Tests Added
- `string_extensions_test.dart` — Tests for capitalize, initials, truncate
- `date_extensions_test.dart` — Tests for isToday, fullDate formatting

### New UI Components
- UserAvatar, CategoryChip, StatCard, ShimmerLoading
- IncidentCard, SearchBarWidget, SectionHeader
- PhotoPreview, CountBadge

### Design System Additions
- AppSpacing constants for consistent layout
- AppShadows for card/elevation styling
- Theme module barrel export

## Day 4 Updates

### New Unit Tests
- `incident_filter_test.dart` — Filter copyWith, clear, hasActiveFilters
- `report_stats_test.dart` — Stats aggregation from incident list
- `image_picker_helper_test.dart` — Image size and quality constants

### New Features
- ImagePickerHelper, LocationSearchDelegate, PhotoSourceSheet
- FilterSheet, SuccessDialog, FadeInItem, RefreshableList
- FormFieldLabel, ToggleOption, AdaptiveBackButton
- IncidentFilter model, ReportStats model, ThemeMode provider
- Bottom sheet helper, responsive breakpoints

## Day 8 Updates (Oct 30)

- Added `validators_test.dart` with email domain, password strength, name bounds, and title length tests
- Updated `priority_helpers_test.dart` to cover low priority and icon mapping
- Updated `status_helpers_test.dart` to verify named color constants and status icons
- Updated `string_extensions_test.dart` with wordCount and isValidUrl tests
- Updated `date_extensions_test.dart` with isYesterday, isThisWeek, smartDate tests

## Day 10 Updates (Nov 1)

### New Unit Tests
- `incident_model_test.dart` — Tests for resolutionTime, isOverdue, copyWith, toJson, toString
- `user_model_test.dart` — Tests for initials, displayName, copyWith, toJson, toString
- `notification_model_test.dart` — Tests for isRecent, toJson, toMap serialization

### Model Enhancements
- Added `resolutionTime`, `isOverdue`, `toJson`, `toString` to IncidentModel
- Added `displayName`, `toJson`, `toString` to UserModel
- Added `isRecent`, `toJson`, `toString` to NotificationModel
- Added `hasNote`, `toJson`, `toString` to StatusHistoryEntry
- Added `fromModels` factory, `resolutionRate`, `open` to ReportStats
- Added priority filter, `sortBy`, `activeFilterCount` to IncidentFilter

### Feature Additions
- Network / IT incident category with wifi icon
- `deleteNotification` and `deleteAllRead` in NotificationRepository
- Client-side `searchIncidents` in IncidentRepository
- Firestore error mapper for database exceptions

### Security & Accessibility
- `isValidStatusTransition` Firestore security rule
- Semantics labels on home screen interactive elements
- Semantics label on profile screen avatar

### Design System
- Priority color constants (urgent/high/normal/low)
- Semantic colors (success/warning/info)
- `overline` and `footnote` text styles in AppTypography

## Day 11 Updates (Nov 3)

### New Unit Tests
- Expanded `report_stats_test.dart` with `fromModels` factory, `open` getter, `resolutionRate` percentage, zero-total guard, and empty-list edge case

### Enhancements
- `memberSince` label displayed on profile screen
- `overline` style applied to filter sheet section headers
- `footnote` style applied to notification timestamps
- Staff dashboard refactored to use `ReportStats.fromModels`
- `searchIncidents` Riverpod provider added for reactive search
- Swipe-to-delete on notification items via `Dismissible`
- `cardHover` and `modal` shadow presets in AppShadows
- Expanded AppBreakpoints with `isTablet`, `isDesktop`, `contentMaxWidth`
- Layout dimension constants (bottomNavHeight, touchTarget, avatarRadius)
- `statusNote` validator
- `waitForConnection` retry helper
- Rejected status option in staff incident controls
- Firestore rule: allow notification deletes for owner, restrict update to `isRead`
- Semantics labels on bottom navigation tabs
