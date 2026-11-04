import 'package:flutter/material.dart';
import '../utils/category_icons.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final bg = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? accent : bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CategoryIcons.forCategory(category),
                size: 16,
                color: isSelected ? Colors.white : secondaryText),
            const SizedBox(width: 6),
            Text(category,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : primaryText,
                )),
          ],
        ),
      ),
    );
  }
}
