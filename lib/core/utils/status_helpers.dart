import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

String statusDisplayName(String status) {
  switch (status) {
    case 'Submitted':
      return 'Submitted';
    case 'In Progress':
      return 'In Progress';
    case 'Resolved':
      return 'Resolved';
    case 'Rejected':
      return 'Rejected';
    default:
      return status;
  }
}

Color statusColor(String status) {
  switch (status) {
    case 'Submitted':
      return Colors.orange;
    case 'In Progress':
      return AppColors.accent;
    case 'Resolved':
      return Colors.green;
    case 'Rejected':
      return AppColors.secondaryLabel;
    default:
      return AppColors.secondaryLabel;
  }
}
