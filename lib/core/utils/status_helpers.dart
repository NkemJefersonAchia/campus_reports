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
      return AppColors.statusSubmitted;
    case 'In Progress':
      return AppColors.statusInProgress;
    case 'Resolved':
      return AppColors.statusResolved;
    case 'Rejected':
      return AppColors.statusRejected;
    default:
      return AppColors.statusRejected;
  }
}

IconData statusIcon(String status) {
  switch (status) {
    case 'Submitted':
      return Icons.schedule_rounded;
    case 'In Progress':
      return Icons.autorenew_rounded;
    case 'Resolved':
      return Icons.check_circle_outline_rounded;
    case 'Rejected':
      return Icons.cancel_outlined;
    default:
      return Icons.help_outline_rounded;
  }
}
