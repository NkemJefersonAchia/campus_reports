import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import 'shimmer_loading.dart';

class PhotoPreview extends StatelessWidget {
  final String url;
  final double height;
  final double borderRadius;

  const PhotoPreview({
    super.key,
    required this.url,
    this.height = 200,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, _) => ShimmerLoading(height: height),
        errorWidget: (_, _, _) => Container(
          height: height,
          color: AppColors.tertiaryBackground,
          child: const Center(child: Icon(Icons.broken_image_outlined)),
        ),
      ),
    );
  }
}
