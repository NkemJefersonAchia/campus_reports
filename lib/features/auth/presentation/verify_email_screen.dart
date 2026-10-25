import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_button.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _resending = false;
  bool _checking = false;
  String? _message;

  Future<void> _resendEmail() async {
    setState(() {
      _resending = true;
      _message = null;
    });
    try {
      await ref.read(authRepositoryProvider).resendVerificationEmail();
      setState(() => _message = 'Verification email sent.');
    } catch (_) {
      setState(() => _message = 'Could not send email. Try again later.');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _checkVerification() async {
    setState(() {
      _checking = true;
      _message = null;
    });
    try {
      await ref.read(authRepositoryProvider).reloadUser();
      ref.invalidate(authStateProvider);
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null && !user.emailVerified) {
        setState(() => _message = 'Email not yet verified. Check your inbox.');
      }
    } catch (_) {
      setState(() => _message = 'Could not check. Try again.');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Icon(Icons.mark_email_unread_outlined, size: 56, color: accent),
              const SizedBox(height: 24),
              Text('Check your inbox', style: AppTypography.largeTitle(primaryText)),
              const SizedBox(height: 12),
              Text(
                'We sent a verification link to your email. Tap the link to activate your account.',
                style: AppTypography.body(secondaryText),
              ),
              if (_message != null) ...[
                const SizedBox(height: 16),
                Text(_message!, style: AppTypography.secondary(accent)),
              ],
              const Spacer(flex: 3),
              AppleButton(
                label: "I've Verified",
                onPressed: _checkVerification,
                isLoading: _checking,
              ),
              const SizedBox(height: 12),
              AppleButton(
                label: 'Resend Email',
                isSecondary: true,
                onPressed: _resendEmail,
                isLoading: _resending,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.destructive, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
