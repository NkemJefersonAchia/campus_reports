# Technical Decisions & Challenges

## Key Technical Decisions

### 1. Riverpod for State Management
**Choice**: Riverpod with `StreamProvider` over BLoC or Provider.
**Justification**: Riverpod's `StreamProvider` maps naturally to Firestore's real-time snapshots. Changes in Firestore propagate immediately to all screens without manual refresh logic. Compared to BLoC, Riverpod requires less boilerplate (no event/state classes per feature). Compared to vanilla Provider, Riverpod offers compile-time safety and automatic disposal.

### 2. go_router for Navigation
**Choice**: go_router with declarative redirect guards.
**Justification**: The app has complex routing requirements — authenticated vs. unauthenticated, email-verified vs. unverified, student shell vs. staff shell. go_router's `redirect` callback centralizes this logic in one place rather than scattering navigation guards across screens. ShellRoute cleanly separates the tab bar from detail screens.

### 3. Apple-Inspired Design (Not Material Defaults)
**Choice**: Custom theme with colors, typography, and components matching apple.com.
**Justification**: The assignment rubric values UI/UX polish and originality. A generic Material app with default purple theming would score lower. The Apple-style approach (monochrome, spacious, hairline borders, frosted glass tab bar) creates a professional, distinctive look while remaining accessible.

### 4. Feature-First Folder Structure
**Choice**: Organize by feature (`features/auth/`, `features/incidents/`) with `data/` and `presentation/` subfolders.
**Justification**: Keeps related files together, making navigation intuitive. Each feature is self-contained — you can understand the incidents feature without looking at auth code. Scales well as the app grows.

### 5. Firestore Security Rules as Primary Access Control
**Choice**: Enforce role-based access in Firestore rules, not just in the Flutter UI.
**Justification**: Client-side checks are easily bypassed. The security rules ensure that even if someone modifies the app or calls the API directly, students cannot update incident statuses and users cannot escalate their own role. UI-level checks provide UX (hiding buttons) while rules provide actual security.

### 6. In-App Notifications via Firestore (Not FCM)
**Choice**: Write notification documents to Firestore on status change, read them with a stream.
**Justification**: FCM requires additional setup (service workers, platform certificates, server-side triggers). Firestore notifications are simpler, work immediately, and integrate with the existing real-time architecture. They also persist and can be marked as read. FCM could be added later for push notifications.

## Challenges Encountered

### 1. Email Verification Flow
**Challenge**: Firebase Auth's `emailVerified` flag doesn't update in real-time — the user must call `reload()` on their User object. The auth state stream doesn't re-emit after verification.
**Solution**: Added an "I've Verified" button that calls `reloadUser()` and invalidates the auth state provider, forcing a re-check.

### 2. Role-Based Route Guards with Async User Data
**Challenge**: The router's `redirect` function runs synchronously, but the user's role comes from Firestore (async). On first load, the user profile may not be available yet.
**Solution**: The `currentUserProvider` streams the Firestore user document. go_router watches auth state and user profile providers. When user data arrives, the router recalculates and redirects to the correct shell.

### 3. Real-Time Updates Across Screens
**Challenge**: When staff updates an incident status, the change must appear on the Home stats, Reports list, Incident Detail, and trigger a notification — all without manual refresh.
**Solution**: All screens read from Riverpod `StreamProvider`s backed by Firestore snapshot streams. The `updateIncidentStatus` method uses a Firestore batch to atomically update the incident, add a status history entry, and create a notification in one operation.

### 4. Image Upload Size and Compression
**Challenge**: Users could upload very large images from their camera, causing slow uploads and high storage costs.
**Solution**: Used `image_picker`'s `maxWidth`, `maxHeight`, and `imageQuality` parameters to compress images on capture. Added a client-side 5 MB check before upload. Storage rules also enforce the 5 MB limit server-side.

## Lessons Learned

1. **Firestore streams + Riverpod are a natural fit** — real-time sync with minimal code
2. **Security rules are essential** — never rely solely on client-side checks
3. **Design decisions matter for UX** — consistent color, spacing, and interaction patterns make a huge difference
4. **Batch writes are important** — updating multiple collections atomically prevents inconsistent state
5. **Feature-first organization** makes the codebase navigable even as it grows
