import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String initials;
  final double size;

  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.initials,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: accent.withValues(alpha: 0.15),
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null
          ? Text(initials,
              style: TextStyle(
                color: accent,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w600,
              ))
          : null,
    );
  }
}
