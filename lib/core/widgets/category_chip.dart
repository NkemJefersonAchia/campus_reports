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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.tertiaryBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(categoryIcon(category),
                size: 16,
                color: isSelected ? Colors.white : AppColors.secondaryLabel),
            const SizedBox(width: 6),
            Text(category,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.label,
                )),
          ],
        ),
      ),
    );
  }
}
