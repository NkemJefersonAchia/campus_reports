import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/verify_email_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/incidents/presentation/home_screen.dart';
import '../features/incidents/presentation/incident_detail_screen.dart';
import '../features/incidents/presentation/new_report_screen.dart';
import '../features/incidents/presentation/reports_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/staff/presentation/staff_dashboard_screen.dart';
import 'app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final userProfile = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/welcome',
    redirect: (context, state) {
      final location = state.uri.toString();

      final auth = authState.valueOrNull;
      final isLoggedIn = auth != null;
      final isEmailVerified = auth?.emailVerified ?? false;
      final user = userProfile.valueOrNull;
      final isStaff = user?.isStaff ?? false;

      final authRoutes = ['/welcome', '/login', '/register', '/forgot-password'];
      final isOnAuthRoute = authRoutes.contains(location);

      if (!isLoggedIn) {
        return isOnAuthRoute ? null : '/welcome';
      }

      if (!isEmailVerified) {
        return location == '/verify-email' ? null : '/verify-email';
      }

      if (isOnAuthRoute || location == '/verify-email') {
        return isStaff ? '/staff' : '/home';
      }

      if (isStaff && location.startsWith('/home')) {
        return '/staff';
      }
      if (!isStaff && location.startsWith('/staff')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(path: '/verify-email', builder: (_, _) => const VerifyEmailScreen()),

      // Student shell
      ShellRoute(
        builder: (_, _, child) => StudentShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/reports', builder: (_, _) => const ReportsScreen()),
          GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),

      // Staff shell
      ShellRoute(
        builder: (_, _, child) => StaffShell(child: child),
        routes: [
          GoRoute(path: '/staff', builder: (_, _) => const StaffDashboardScreen()),
          GoRoute(path: '/staff/reports', builder: (_, _) => const ReportsScreen()),
          GoRoute(path: '/staff/notifications', builder: (_, _) => const NotificationsScreen()),
          GoRoute(path: '/staff/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),

      // Detail & new report (outside shell, full-screen)
      GoRoute(
        path: '/incident/:id',
        builder: (_, state) => IncidentDetailScreen(
          incidentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/new-report',
        pageBuilder: (_, _) => CustomTransitionPage(
          child: const NewReportScreen(),
          transitionsBuilder: (_, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      ),
    ],
  );
});
