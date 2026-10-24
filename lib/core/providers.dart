import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_model.dart';
import '../features/incidents/data/incident_model.dart';
import '../features/incidents/data/incident_repository.dart';
import '../features/notifications/data/notification_model.dart';
import '../features/notifications/data/notification_repository.dart';

// ── Repositories ──
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final incidentRepositoryProvider = Provider<IncidentRepository>(
  (ref) => IncidentRepository(),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(),
);

// ── Auth state ──
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// ── Current user profile ──
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(authRepositoryProvider).userStream(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// ── All incidents ──
final allIncidentsProvider = StreamProvider<List<IncidentModel>>(
  (ref) => ref.watch(incidentRepositoryProvider).allIncidentsStream(),
);

// ── User incidents ──
final userIncidentsProvider = StreamProvider<List<IncidentModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(incidentRepositoryProvider).userIncidentsStream(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// ── Single incident ──
final incidentDetailProvider =
    StreamProvider.family<IncidentModel?, String>((ref, id) {
  return ref.watch(incidentRepositoryProvider).incidentStream(id);
});

// ── Status history ──
final statusHistoryProvider =
    StreamProvider.family((ref, String incidentId) {
  return ref.watch(incidentRepositoryProvider).statusHistoryStream(incidentId);
});

// ── Notifications ──
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(notificationRepositoryProvider).notificationsStream(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(0);
      return ref.watch(notificationRepositoryProvider).unreadCountStream(user.uid);
    },
    loading: () => Stream.value(0),
    error: (_, _) => Stream.value(0),
  );
});
