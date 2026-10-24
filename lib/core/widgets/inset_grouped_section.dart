import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InsetGroupedSection extends StatelessWidget {
  final List<Widget> children;
  final String? header;
  final EdgeInsets margin;

  const InsetGroupedSection({
    super.key,
    required this.children,
    this.header,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                header!.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: borderColor,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
