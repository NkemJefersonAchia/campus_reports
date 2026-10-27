import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/time_helpers.dart';
import 'status_dot.dart';

class IncidentCard extends StatelessWidget {
  final String title;
  final String category;
  final String status;
  final DateTime createdAt;
  final String? thumbnailUrl;
  final VoidCallback? onTap;

  const IncidentCard({
    super.key,
    required this.title,
    required this.category,
    required this.status,
    required this.createdAt,
    this.thumbnailUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('$category · ${relativeTime(createdAt)}',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.secondaryLabel)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusDot(status: status),
          ],
        ),
      ),
    );
  }
}
