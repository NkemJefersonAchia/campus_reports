import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppleButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDestructive;
  final bool isSecondary;

  const AppleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDestructive = false,
    this.isSecondary = false,
  });

  @override
  State<AppleButton> createState() => _AppleButtonState();
}

class _AppleButtonState extends State<AppleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    Color bgColor;
    Color textColor;
    if (widget.isDestructive) {
      bgColor = AppColors.destructive;
      textColor = Colors.white;
    } else if (widget.isSecondary) {
      bgColor = isLight ? AppColors.lightSecondaryBackground : AppColors.darkSecondaryBackground;
      textColor = accent;
    } else {
      bgColor = accent;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _scale = 0.97) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _scale = 1.0) : null,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: textColor,
              disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
              disabledForegroundColor: textColor.withValues(alpha: 0.5),
              elevation: 0,
              shape: const StadiumBorder(),
              textStyle: AppTypography.buttonText,
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: textColor,
                    ),
                  )
                : Text(widget.label),
          ),
        ),
      ),
    );
  }
}
