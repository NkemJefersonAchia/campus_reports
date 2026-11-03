import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/providers.dart';
import '../core/theme/app_colors.dart';

class StudentShell extends ConsumerWidget {
  final Widget child;
  const StudentShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final unread = ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isLight ? Colors.white : Colors.black).withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                  color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TabItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                      isActive: _currentIndex(context) == 0,
                      onTap: () => context.go('/home'),
                    ),
                    _TabItem(
                      icon: Icons.description_outlined,
                      activeIcon: Icons.description,
                      label: 'Reports',
                      isActive: _currentIndex(context) == 1,
                      onTap: () => context.go('/reports'),
                    ),
                    _TabItem(
                      icon: Icons.notifications_none,
                      activeIcon: Icons.notifications,
                      label: 'Notifications',
                      isActive: _currentIndex(context) == 2,
                      onTap: () => context.go('/notifications'),
                      badge: unread,
                    ),
                    _TabItem(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                      isActive: _currentIndex(context) == 3,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/reports')) return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}

class StaffShell extends ConsumerWidget {
  final Widget child;
  const StaffShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final unread = ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isLight ? Colors.white : Colors.black).withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                  color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TabItem(
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard,
                      label: 'Dashboard',
                      isActive: _currentIndex(context) == 0,
                      onTap: () => context.go('/staff'),
                    ),
                    _TabItem(
                      icon: Icons.description_outlined,
                      activeIcon: Icons.description,
                      label: 'Reports',
                      isActive: _currentIndex(context) == 1,
                      onTap: () => context.go('/staff/reports'),
                    ),
                    _TabItem(
                      icon: Icons.notifications_none,
                      activeIcon: Icons.notifications,
                      label: 'Notifications',
                      isActive: _currentIndex(context) == 2,
                      onTap: () => context.go('/staff/notifications'),
                      badge: unread,
                    ),
                    _TabItem(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                      isActive: _currentIndex(context) == 3,
                      onTap: () => context.go('/staff/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/staff/reports')) return 1;
    if (location.startsWith('/staff/notifications')) return 2;
    if (location.startsWith('/staff/profile')) return 3;
    return 0;
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badge;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final activeColor = isLight ? AppColors.lightAccent : AppColors.darkAccent;
    final inactiveColor = isLight ? AppColors.lightTertiaryText : AppColors.darkTertiaryText;
    final color = isActive ? activeColor : inactiveColor;

    return Semantics(
      label: '$label tab${badge > 0 ? ", $badge unread" : ""}',
      button: true,
      selected: isActive,
      child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 64,
        height: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isActive ? activeIcon : icon, size: 24, color: color),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.destructive,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badge > 9 ? '9+' : '$badge',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    ),
    );
  }
}
