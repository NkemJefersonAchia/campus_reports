import 'package:flutter/material.dart';

class AppleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AppleTextField({
    super.key,
    this.controller,
    required this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      enabled: enabled,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        counterText: '',
      ),
    );
  }
}
