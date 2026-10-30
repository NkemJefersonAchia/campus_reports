import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Color priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'urgent':
      return AppColors.destructive;
    case 'high':
      return Colors.orange;
    case 'normal':
      return AppColors.statusInProgress;
    case 'low':
      return AppColors.statusResolved;
    default:
      return AppColors.statusRejected;
  }
}

String priorityLabel(String priority) {
  switch (priority.toLowerCase()) {
    case 'urgent':
      return 'Urgent';
    case 'high':
      return 'High Priority';
    case 'normal':
      return 'Normal';
    case 'low':
      return 'Low Priority';
    default:
      return 'Unknown';
  }
}

IconData priorityIcon(String priority) {
  switch (priority.toLowerCase()) {
    case 'urgent':
      return Icons.error_rounded;
    case 'high':
      return Icons.warning_amber_rounded;
    case 'normal':
      return Icons.info_outline_rounded;
    case 'low':
      return Icons.arrow_downward_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}
