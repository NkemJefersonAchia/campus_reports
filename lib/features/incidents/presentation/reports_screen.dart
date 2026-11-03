import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_helpers.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_dot.dart';
import '../data/incident_model.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _tabIndex = 0; // 0 = Mine, 1 = Everyone
  String _searchQuery = '';
  String? _statusFilter;
  String? _categoryFilter;

  List<IncidentModel> _filter(List<IncidentModel> incidents) {
    var result = incidents;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((i) =>
        i.title.toLowerCase().contains(q) ||
        i.description.toLowerCase().contains(q) ||
        i.location.toLowerCase().contains(q)
      ).toList();
    }
    if (_statusFilter != null) {
      result = result.where((i) => i.status == _statusFilter).toList();
    }
    if (_categoryFilter != null) {
      result = result.where((i) => i.category == _categoryFilter).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final surfaceColor = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final myIncidents = ref.watch(userIncidentsProvider);
    final allIncidents = ref.watch(allIncidentsProvider);
    final incidents = _tabIndex == 0 ? myIncidents : allIncidents;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Reports', style: AppTypography.largeTitle(primaryText)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: accent, size: 28),
                      onPressed: () => context.push('/new-report'),
                    ),
                  ],
                ),
              ),
            ),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search reports',
                    prefixIcon: Icon(Icons.search, color: secondaryText),
                  ),
                ),
              ),
            ),

            // Tabs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    _PillTab(label: 'Mine', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
                    const SizedBox(width: 8),
                    _PillTab(label: 'Everyone', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.tune, size: 22, color: secondaryText),
                      onPressed: () => _showFilterSheet(context, isLight),
                    ),
                  ],
                ),
              ),
            ),

            // Active filters
            if (_statusFilter != null || _categoryFilter != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    children: [
                      if (_statusFilter != null)
                        _FilterChip(
                          label: _statusFilter!,
                          onRemove: () => setState(() => _statusFilter = null),
                        ),
                      if (_categoryFilter != null) ...[
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: _categoryFilter!,
                          onRemove: () => setState(() => _categoryFilter = null),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // List
            incidents.when(
              data: (list) {
                final filtered = _filter(list);
                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.search_off,
                      title: 'No reports found',
                      subtitle: 'Try adjusting your filters or search.',
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final incident = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          margin: EdgeInsets.only(top: index == 0 ? 16 : 0),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            border: Border(
                              left: BorderSide(color: borderColor, width: 0.5),
                              right: BorderSide(color: borderColor, width: 0.5),
                              top: BorderSide(color: borderColor, width: 0.5),
                              bottom: index == filtered.length - 1
                                  ? BorderSide(color: borderColor, width: 0.5)
                                  : BorderSide.none,
                            ),
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(top: Radius.circular(14))
                                : index == filtered.length - 1
                                    ? const BorderRadius.vertical(bottom: Radius.circular(14))
                                    : null,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                leading: incident.photoUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          incident.photoUrl!,
                                          width: 48, height: 48, fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => _placeholder(borderColor, secondaryText),
                                        ),
                                      )
                                    : _placeholder(borderColor, secondaryText),
                                title: Text(
                                  incident.title,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryText),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${incident.location} · ${TimeHelpers.relativeTime(incident.createdAt)}',
                                  style: TextStyle(fontSize: 13, color: secondaryText),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    StatusDot(status: incident.status),
                                    const SizedBox(width: 4),
                                    Icon(Icons.chevron_right, size: 18, color: secondaryText),
                                  ],
                                ),
                                onTap: () => context.push('/incident/${incident.id}'),
                              ),
                              if (index < filtered.length - 1)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
              error: (_, _) => const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Error loading reports',
                  subtitle: 'Please try again later.',
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(Color borderColor, Color iconColor) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.image_outlined, color: iconColor, size: 24),
    );
  }

  void _showFilterSheet(BuildContext context, bool isLight) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isLight ? AppColors.lightSurface : AppColors.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                      color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('FILTER BY STATUS', style: AppTypography.overline(isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: ['Submitted', 'In Progress', 'Resolved'].map((s) {
                    return ChoiceChip(
                      label: Text(s),
                      selected: _statusFilter == s,
                      onSelected: (selected) {
                        setState(() => _statusFilter = selected ? s : null);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text('FILTER BY CATEGORY', style: AppTypography.overline(isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: ['Facilities', 'Water', 'Electricity', 'Safety', 'Sanitation', 'Other'].map((c) {
                    return ChoiceChip(
                      label: Text(c),
                      selected: _categoryFilter == c,
                      onSelected: (selected) {
                        setState(() => _categoryFilter = selected ? c : null);
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                if (_statusFilter != null || _categoryFilter != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _statusFilter = null;
                        _categoryFilter = null;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Clear All Filters'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText)
              : (isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: selected
                ? (isLight ? Colors.white : Colors.black)
                : (isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isLight ? AppColors.lightAccent : AppColors.darkAccent).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: isLight ? AppColors.lightAccent : AppColors.darkAccent)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: isLight ? AppColors.lightAccent : AppColors.darkAccent),
          ),
        ],
      ),
    );
  }
}
