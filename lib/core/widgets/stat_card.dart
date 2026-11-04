import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final bg = isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color ?? primaryText,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: secondaryText,
              )),
        ],
      ),
    );
  }
}
