import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusDot extends StatelessWidget {
  final String status;
  final double size;

  const StatusDot({super.key, required this.status, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorForStatus(status),
      ),
    );
  }

  static Color colorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return AppColors.statusSubmitted;
      case 'in progress':
        return AppColors.statusInProgress;
      case 'resolved':
        return AppColors.statusResolved;
      case 'rejected':
        return AppColors.statusRejected;
      default:
        return AppColors.statusSubmitted;
    }
  }
}
