import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onDismiss;
  const SuccessDialog({super.key, required this.title, required this.message, this.onDismiss});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle, size: 56, color: Colors.green),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryLabel)),
      ]),
      actions: [TextButton(onPressed: onDismiss ?? () => Navigator.pop(context), child: const Text('OK'))],
    );
  }
}
