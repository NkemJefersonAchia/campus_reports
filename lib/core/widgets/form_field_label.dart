import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FormFieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const FormFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: secondaryText,
                )),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(fontSize: 14, color: AppColors.destructive)),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
