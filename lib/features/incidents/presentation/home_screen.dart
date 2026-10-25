import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_helpers.dart';
import '../../../core/widgets/status_dot.dart';
import '../../../core/widgets/empty_state.dart';
import '../data/incident_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final bgSecondary = isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground;
    final surfaceColor = isLight ? AppColors.lightSurface : AppColors.darkSurface;

    final userAsync = ref.watch(currentUserProvider);
    final incidentsAsync = ref.watch(userIncidentsProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    final user = userAsync.valueOrNull;
    final firstName = user?.firstName ?? '';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        TimeHelpers.greeting(firstName),
                        style: AppTypography.largeTitle(primaryText),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications_none, size: 26, color: primaryText),
                          onPressed: () => context.go('/notifications'),
                        ),
                        if ((unreadCount.valueOrNull ?? 0) > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: AppColors.destructive,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.go('/profile'),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: bgSecondary,
                        child: Text(
                          user?.initials ?? '?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // New Report CTA
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: GestureDetector(
                  onTap: () => context.push('/new-report'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'New Report',
                          style: AppTypography.body(Colors.white).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: incidentsAsync.when(
                data: (incidents) => _StatsRow(
                  incidents: incidents,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  borderColor: borderColor,
                  surfaceColor: surfaceColor,
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // Recent Reports header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  children: [
                    Text('Recent Reports', style: AppTypography.sectionTitle(primaryText)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go('/reports'),
                      child: Text('See All', style: TextStyle(fontSize: 15, color: accent)),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Reports list
            incidentsAsync.when(
              data: (incidents) {
                if (incidents.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                      icon: Icons.description_outlined,
                      title: 'No reports yet',
                      subtitle: 'Submit your first incident report.',
                    ),
                  );
                }
                final recent = incidents.take(5).toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReportRow(
                      incident: recent[index],
                      borderColor: borderColor,
                      surfaceColor: surfaceColor,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      isLast: index == recent.length - 1,
                    ),
                    childCount: recent.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Something went wrong',
                  subtitle: 'Could not load reports.',
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<IncidentModel> incidents;
  final Color primaryText;
  final Color secondaryText;
  final Color borderColor;
  final Color surfaceColor;

  const _StatsRow({
    required this.incidents,
    required this.primaryText,
    required this.secondaryText,
    required this.borderColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final total = incidents.length;
    final submitted = incidents.where((i) => i.status == 'Submitted').length;
    final inProgress = incidents.where((i) => i.status == 'In Progress').length;
    final resolved = incidents.where((i) => i.status == 'Resolved').length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _StatItem(label: 'Total', value: '$total', color: primaryText, secondaryColor: secondaryText),
              VerticalDivider(width: 0.5, thickness: 0.5, color: borderColor),
              _StatItem(label: 'Submitted', value: '$submitted', color: AppColors.statusSubmitted, secondaryColor: secondaryText),
              VerticalDivider(width: 0.5, thickness: 0.5, color: borderColor),
              _StatItem(label: 'In Progress', value: '$inProgress', color: AppColors.statusInProgress, secondaryColor: secondaryText),
              VerticalDivider(width: 0.5, thickness: 0.5, color: borderColor),
              _StatItem(label: 'Resolved', value: '$resolved', color: AppColors.statusResolved, secondaryColor: secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color secondaryColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final IncidentModel incident;
  final Color borderColor;
  final Color surfaceColor;
  final Color primaryText;
  final Color secondaryText;
  final bool isLast;

  const _ReportRow({
    required this.incident,
    required this.borderColor,
    required this.surfaceColor,
    required this.primaryText,
    required this.secondaryText,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: isLast
              ? const BorderRadius.vertical(bottom: Radius.circular(14))
              : null,
          border: Border(
            left: BorderSide(color: borderColor, width: 0.5),
            right: BorderSide(color: borderColor, width: 0.5),
            bottom: BorderSide(color: borderColor, width: 0.5),
            top: BorderSide(color: borderColor, width: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: incident.photoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    incident.photoUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _placeholderIcon(),
                  ),
                )
              : _placeholderIcon(),
          title: Text(
            incident.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Text(
                incident.location,
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),
              const SizedBox(width: 8),
              Text(
                TimeHelpers.relativeTime(incident.createdAt),
                style: TextStyle(fontSize: 13, color: secondaryText),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusDot(status: incident.status),
              const SizedBox(width: 6),
              Text(
                incident.status,
                style: TextStyle(fontSize: 13, color: StatusDot.colorForStatus(incident.status)),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 18, color: secondaryText),
            ],
          ),
          onTap: () => context.push('/incident/${incident.id}'),
        ),
      ),
    );
  }

  Widget _placeholderIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image_outlined, color: secondaryText, size: 24),
    );
  }
}
