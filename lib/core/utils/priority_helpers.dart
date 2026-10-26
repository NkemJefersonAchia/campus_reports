import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Color priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'urgent':
      return AppColors.destructive;
    case 'high':
      return Colors.orange;
    case 'normal':
      return AppColors.accent;
    default:
      return AppColors.secondaryLabel;
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
    default:
      return 'Low';
  }
}
