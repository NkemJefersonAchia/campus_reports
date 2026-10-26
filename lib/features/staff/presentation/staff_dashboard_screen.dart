import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_helpers.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_dot.dart';


class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final surfaceColor = isLight ? AppColors.lightSurface : AppColors.darkSurface;

    final user = ref.watch(currentUserProvider).valueOrNull;
    final incidentsAsync = ref.watch(allIncidentsProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Staff Dashboard', style: AppTypography.largeTitle(primaryText)),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome, ${user?.firstName ?? ""}',
                      style: AppTypography.secondary(secondaryText),
                    ),
                  ],
                ),
              ),
            ),

            // Stats
            SliverToBoxAdapter(
              child: incidentsAsync.when(
                data: (incidents) {
                  final submitted = incidents.where((i) => i.status == 'Submitted').length;
                  final inProgress = incidents.where((i) => i.status == 'In Progress').length;
                  final resolved = incidents.where((i) => i.status == 'Resolved').length;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            _Stat(label: 'Open', value: '$submitted', color: AppColors.statusSubmitted, secondaryColor: secondaryText),
                            VerticalDivider(width: 0.5, thickness: 0.5, color: borderColor),
                            _Stat(label: 'In Progress', value: '$inProgress', color: AppColors.statusInProgress, secondaryColor: secondaryText),
                            VerticalDivider(width: 0.5, thickness: 0.5, color: borderColor),
                            _Stat(label: 'Resolved', value: '$resolved', color: AppColors.statusResolved, secondaryColor: secondaryText),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [null, 'Facilities', 'Water', 'Electricity', 'Safety', 'Sanitation', 'Other'].map((cat) {
                      final selected = _categoryFilter == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _categoryFilter = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? (isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText)
                                  : (isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cat ?? 'All',
                              style: TextStyle(
                                fontSize: 14,
                                color: selected
                                    ? (isLight ? Colors.white : Colors.black)
                                    : secondaryText,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Needs attention
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Text('Needs Attention', style: AppTypography.sectionTitle(primaryText)),
              ),
            ),

            incidentsAsync.when(
              data: (incidents) {
                var needsAttention = incidents.where((i) => i.status != 'Resolved').toList();
                if (_categoryFilter != null) {
                  needsAttention = needsAttention.where((i) => i.category == _categoryFilter).toList();
                }
                needsAttention.sort((a, b) {
                  if (a.priority == 'urgent' && b.priority != 'urgent') return -1;
                  if (b.priority == 'urgent' && a.priority != 'urgent') return 1;
                  return a.createdAt.compareTo(b.createdAt);
                });

                if (needsAttention.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: EmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'All clear',
                      subtitle: 'No unresolved incidents.',
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final incident = needsAttention[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            border: Border.all(color: borderColor, width: 0.5),
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(top: Radius.circular(14))
                                : index == needsAttention.length - 1
                                    ? const BorderRadius.vertical(bottom: Radius.circular(14))
                                    : null,
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StatusDot(status: incident.status, size: 10),
                                if (incident.priority == 'urgent') ...[
                                  const SizedBox(height: 4),
                                  const Icon(Icons.priority_high, size: 14, color: AppColors.destructive),
                                ],
                              ],
                            ),
                            title: Text(incident.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryText)),
                            subtitle: Text(
                              '${incident.category} · ${incident.location} · ${TimeHelpers.relativeTime(incident.createdAt)}',
                              style: TextStyle(fontSize: 13, color: secondaryText),
                            ),
                            trailing: Icon(Icons.chevron_right, size: 18, color: secondaryText),
                            onTap: () => context.push('/incident/${incident.id}'),
                          ),
                        ),
                      );
                    },
                    childCount: needsAttention.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (_, _) => const SliverToBoxAdapter(
                child: EmptyState(icon: Icons.error_outline, title: 'Error', subtitle: 'Could not load incidents.'),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color secondaryColor;

  const _Stat({required this.label, required this.value, required this.color, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, color: secondaryColor)),
          ],
        ),
      ),
    );
  }
}
