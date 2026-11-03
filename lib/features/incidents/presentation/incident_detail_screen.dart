import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/time_helpers.dart';
import '../../../core/widgets/apple_button.dart';
import '../../../core/widgets/status_dot.dart';
import '../data/status_history_model.dart';

class IncidentDetailScreen extends ConsumerStatefulWidget {
  final String incidentId;
  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  ConsumerState<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends ConsumerState<IncidentDetailScreen> {
  String? _newStatus;
  final _noteController = TextEditingController();
  bool _isUpdating = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (_newStatus == null) return;
    setState(() => _isUpdating = true);
    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      final incident = ref.read(incidentDetailProvider(widget.incidentId)).valueOrNull;
      if (user == null || incident == null) return;

      await ref.read(incidentRepositoryProvider).updateIncidentStatus(
        incidentId: widget.incidentId,
        newStatus: _newStatus!,
        staffId: user.uid,
        staffName: user.fullName,
        note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
        reporterId: incident.reporterId,
        incidentTitle: incident.title,
      );
      _noteController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _deleteIncident() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.destructive)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(incidentRepositoryProvider).deleteIncident(widget.incidentId);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    final incidentAsync = ref.watch(incidentDetailProvider(widget.incidentId));
    final historyAsync = ref.watch(statusHistoryProvider(widget.incidentId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;

    return incidentAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator.adaptive())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error loading report: $e')),
      ),
      data: (incident) {
        if (incident == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Report not found.')));
        }

        final isOwner = currentUser?.uid == incident.reporterId;
        final isStaff = currentUser?.isStaff ?? false;
        final canEdit = isOwner && incident.isEditable;
        _newStatus ??= incident.status;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Photo header
              SliverAppBar(
                expandedHeight: incident.photoUrl != null ? 280 : 0,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  if (canEdit)
                    PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                        child: const Icon(Icons.more_horiz, size: 18, color: Colors.white),
                      ),
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.destructive))),
                      ],
                      onSelected: (v) {
                        if (v == 'delete') _deleteIncident();
                      },
                    ),
                ],
                flexibleSpace: incident.photoUrl != null
                    ? FlexibleSpaceBar(
                        background: Hero(
                          tag: 'incident-${incident.id}',
                          child: Image.network(
                            incident.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(color: borderColor),
                          ),
                        ),
                      )
                    : null,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category + status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(incident.category, style: TextStyle(fontSize: 13, color: accent, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(width: 8),
                          if (incident.priority == 'urgent')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.destructive.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text('Urgent', style: TextStyle(fontSize: 13, color: AppColors.destructive, fontWeight: FontWeight.w500)),
                            ),
                          const Spacer(),
                          StatusDot(status: incident.status),
                          const SizedBox(width: 6),
                          Text(incident.status, style: TextStyle(fontSize: 14, color: StatusDot.colorForStatus(incident.status), fontWeight: FontWeight.w500)),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Text(incident.title, style: AppTypography.sectionTitle(primaryText)),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: secondaryText),
                          const SizedBox(width: 4),
                          Text(incident.location, style: TextStyle(fontSize: 15, color: secondaryText)),
                          if (incident.locationDetail != null) ...[
                            Text(' · ${incident.locationDetail}', style: TextStyle(fontSize: 15, color: secondaryText)),
                          ],
                        ],
                      ),

                      const SizedBox(height: 4),
                      Text(
                        'Reported ${TimeHelpers.formatDateTime(incident.createdAt)}',
                        style: TextStyle(fontSize: 13, color: secondaryText),
                      ),
                      if (!incident.isAnonymous || isStaff) ...[
                        const SizedBox(height: 2),
                        Text(
                          'By ${incident.reporterName}',
                          style: TextStyle(fontSize: 13, color: secondaryText),
                        ),
                      ],

                      const SizedBox(height: 20),
                      Text(incident.description, style: AppTypography.body(primaryText)),

                      // Status timeline
                      const SizedBox(height: 32),
                      Text('Status Timeline', style: AppTypography.headline(primaryText)),
                      const SizedBox(height: 16),
                      historyAsync.when(
                        data: (entries) => _StatusTimeline(entries: entries, primaryText: primaryText, secondaryText: secondaryText),
                        loading: () => const CircularProgressIndicator.adaptive(),
                        error: (_, _) => const Text('Could not load history.'),
                      ),

                      // Staff controls
                      if (isStaff) ...[
                        const SizedBox(height: 32),
                        Divider(color: borderColor),
                        const SizedBox(height: 16),
                        Text('Update Status', style: AppTypography.headline(primaryText)),
                        const SizedBox(height: 12),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'Submitted', label: Text('Submitted')),
                            ButtonSegment(value: 'In Progress', label: Text('In Progress')),
                            ButtonSegment(value: 'Resolved', label: Text('Resolved')),
                          ],
                          selected: {_newStatus ?? incident.status},
                          onSelectionChanged: (s) => setState(() => _newStatus = s.first),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _noteController,
                          maxLines: 3,
                          decoration: const InputDecoration(hintText: 'Add a note (optional)'),
                        ),
                        const SizedBox(height: 16),
                        AppleButton(
                          label: 'Update Status',
                          onPressed: _newStatus != incident.status ? _updateStatus : null,
                          isLoading: _isUpdating,
                        ),
                      ],
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final List<StatusHistoryEntry> entries;
  final Color primaryText;
  final Color secondaryText;

  const _StatusTimeline({
    required this.entries,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const Text('No history yet.');
    return Column(
      children: List.generate(entries.length, (i) {
        final entry = entries[i];
        final isLast = i == entries.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: StatusDot.colorForStatus(entry.status),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1,
                          color: StatusDot.colorForStatus(entry.status).withValues(alpha: 0.3),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.status,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
                      ),
                      Text(
                        '${TimeHelpers.formatDateTime(entry.timestamp)} · ${entry.changedByName}',
                        style: TextStyle(fontSize: 13, color: secondaryText),
                      ),
                      if (entry.note != null && entry.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(entry.note!, style: TextStyle(fontSize: 15, color: primaryText)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
