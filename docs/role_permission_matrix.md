# Role & Permission Matrix

## User Roles

| Role | How Created | Landing Screen |
|------|------------|----------------|
| **Student** | Self-registration with ALU email | Home (student dashboard) |
| **Staff** | Manual role update in Firestore console | Staff Dashboard |

## Permission Matrix

| Action | Student | Staff |
|--------|---------|-------|
| Register/Login | Yes | Yes |
| View all incidents | Yes (public) | Yes |
| Create incident report | Yes | Yes |
| Edit own report (while Submitted) | Yes | Yes |
| Delete own report (while Submitted) | Yes | Yes |
| Update incident status | No | Yes |
| Add staff notes to incidents | No | Yes |
| View reporter identity (anonymous reports) | No | Yes |
| View staff dashboard | No | Yes |
| View own notifications | Yes | Yes |
| View own profile | Yes | Yes |

## Access Control Implementation

### UI Layer
- Route guards via `go_router` redirect: students cannot access `/staff/*` routes, staff cannot access `/home` (redirected to `/staff`)
- Staff-only UI sections (status update controls) are conditionally rendered based on `user.isStaff`
- Edit/delete actions are hidden unless the user owns the report and status is "Submitted"

### Backend Layer (Firestore Security Rules)
- All reads require `request.auth != null` and `email_verified == true`
- Incident creation requires `reporterId == auth.uid` and `status == "Submitted"`
- Status updates require the `isStaff()` helper function which reads the user's Firestore role
- Users cannot modify their own `role` field
- Storage uploads are scoped to `incidents/{userId}/` path with 5 MB and image-type restrictions
