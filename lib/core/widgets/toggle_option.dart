import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ToggleOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleOption({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
