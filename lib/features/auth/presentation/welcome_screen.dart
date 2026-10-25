import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 3),
              Icon(
                Icons.shield_outlined,
                size: 48,
                color: isLight ? AppColors.lightAccent : AppColors.darkAccent,
              ),
              const SizedBox(height: 24),
              Text(
                'Campus\nReports',
                style: AppTypography.largeTitle(primaryText),
              ),
              const SizedBox(height: 12),
              Text(
                'Report campus issues. Track their resolution.',
                style: AppTypography.body(secondaryText),
              ),
              const Spacer(flex: 4),
              AppleButton(
                label: 'Sign In',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 12),
              AppleButton(
                label: 'Create Account',
                isSecondary: true,
                onPressed: () => context.go('/register'),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
