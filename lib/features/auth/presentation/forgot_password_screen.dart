import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/firebase_error_mapper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/apple_button.dart';
import '../../../core/widgets/apple_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendPasswordReset(_emailController.text);
      setState(() {
        _sent = true;
        _message = 'Password reset email sent. Check your inbox.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() => _message = FirebaseErrorMapper.mapAuthError(e));
    } catch (_) {
      setState(() => _message = 'An error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Reset Password', style: AppTypography.largeTitle(primaryText)),
                const SizedBox(height: 12),
                Text(
                  "Enter your email and we'll send you a link to reset your password.",
                  style: AppTypography.body(secondaryText),
                ),
                const SizedBox(height: 32),
                if (_message != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _sent
                          ? (isLight ? AppColors.lightAccent : AppColors.darkAccent).withValues(alpha: 0.1)
                          : AppColors.destructive.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _sent
                            ? (isLight ? AppColors.lightAccent : AppColors.darkAccent)
                            : AppColors.destructive,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                AppleTextField(
                  controller: _emailController,
                  hint: 'Email',
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                AppleButton(
                  label: _sent ? 'Resend Link' : 'Send Reset Link',
                  onPressed: _sendReset,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
