import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_helpers.dart';
import '../../../core/widgets/empty_state.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final surfaceColor = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    final notificationsAsync = ref.watch(notificationsProvider);
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                child: Row(
                  children: [
                    Text('Notifications', style: AppTypography.largeTitle(primaryText)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (currentUser != null) {
                          ref.read(notificationRepositoryProvider).markAllAsRead(currentUser.uid);
                        }
                      },
                      child: Text('Mark All Read', style: TextStyle(fontSize: 15, color: accent)),
                    ),
                  ],
                ),
              ),
            ),
            notificationsAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.notifications_none,
                      title: 'No notifications',
                      subtitle: "You'll be notified when your reports are updated.",
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notif = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            border: Border.all(color: borderColor, width: 0.5),
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(top: Radius.circular(14))
                                : index == notifications.length - 1
                                    ? const BorderRadius.vertical(bottom: Radius.circular(14))
                                    : null,
                          ),
                          child: Dismissible(
                            key: ValueKey(notif.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: AppColors.destructive,
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              ref.read(notificationRepositoryProvider).deleteNotification(notif.id);
                            },
                            child: ListTile(
                              leading: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: notif.isRead ? Colors.transparent : accent,
                                ),
                              ),
                              title: Text(
                                notif.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notif.isRead ? FontWeight.w400 : FontWeight.w600,
                                  color: primaryText,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notif.body, style: TextStyle(fontSize: 14, color: secondaryText)),
                                  const SizedBox(height: 2),
                                  Text(
                                    TimeHelpers.relativeTime(notif.createdAt),
                                    style: AppTypography.footnote(secondaryText),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (!notif.isRead) {
                                  ref.read(notificationRepositoryProvider).markAsRead(notif.id);
                                }
                                context.push('/incident/${notif.incidentId}');
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: notifications.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (_, _) => const SliverFillRemaining(
                child: EmptyState(icon: Icons.error_outline, title: 'Error', subtitle: 'Could not load notifications.'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
