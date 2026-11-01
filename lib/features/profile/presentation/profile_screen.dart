import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/inset_grouped_section.dart';

final _themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final bgSecondary = isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground;

    final user = ref.watch(currentUserProvider).valueOrNull;
    final incidentsAsync = ref.watch(userIncidentsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar
              Semantics(
                label: '${user?.fullName ?? "User"} profile avatar',
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: bgSecondary,
                  child: Text(
                    user?.initials ?? '?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: primaryText),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(user?.fullName ?? '', style: AppTypography.sectionTitle(primaryText)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user?.role.toUpperCase() ?? '',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondaryText, letterSpacing: 0.5),
                ),
              ),
              if (user?.department != null && user!.department!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(user.department!, style: TextStyle(fontSize: 15, color: secondaryText)),
              ],
              const SizedBox(height: 4),
              Text(user?.email ?? '', style: TextStyle(fontSize: 14, color: secondaryText)),

              // Stats
              const SizedBox(height: 24),
              incidentsAsync.when(
                data: (incidents) {
                  final total = incidents.length;
                  final inProgress = incidents.where((i) => i.status == 'In Progress').length;
                  final resolved = incidents.where((i) => i.status == 'Resolved').length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProfileStat(label: 'Total', value: '$total', color: primaryText, secondaryColor: secondaryText),
                        _ProfileStat(label: 'In Progress', value: '$inProgress', color: AppColors.statusInProgress, secondaryColor: secondaryText),
                        _ProfileStat(label: 'Resolved', value: '$resolved', color: AppColors.statusResolved, secondaryColor: secondaryText),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator.adaptive(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 32),

              // Settings
              InsetGroupedSection(
                header: 'Settings',
                children: [
                  ListTile(
                    leading: Icon(Icons.palette_outlined, color: primaryText),
                    title: Text('Appearance', style: TextStyle(color: primaryText)),
                    trailing: DropdownButton<ThemeMode>(
                      value: ref.watch(_themeModeProvider),
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                        DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                      ],
                      onChanged: (mode) {
                        if (mode != null) ref.read(_themeModeProvider.notifier).state = mode;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline, color: primaryText),
                    title: Text('Help & Support', style: TextStyle(color: primaryText)),
                    trailing: Icon(Icons.chevron_right, size: 18, color: secondaryText),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              InsetGroupedSection(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.destructive),
                    title: const Text('Sign Out', style: TextStyle(color: AppColors.destructive)),
                    onTap: () => _confirmSignOut(context, ref),
                  ),
                ],
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authRepositoryProvider).signOut();
            },
            child: const Text('Sign Out', style: TextStyle(color: AppColors.destructive)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color secondaryColor;

  const _ProfileStat({required this.label, required this.value, required this.color, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: secondaryColor)),
      ],
    );
  }
}
