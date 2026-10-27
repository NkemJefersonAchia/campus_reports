import 'package:flutter/material.dart';

class AdaptiveBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AdaptiveBackButton({super.key, this.onPressed});
  @override
  Widget build(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: onPressed ?? () => Navigator.maybePop(context));
}
