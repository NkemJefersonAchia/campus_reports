import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.tertiaryBackground,
      highlightColor: AppColors.secondaryBackground,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.tertiaryBackground,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
