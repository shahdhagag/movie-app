import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

class MovieDetailsHeader extends StatelessWidget {
  final String? backgroundImage;
  final String? ytTrailerCode;
  final VoidCallback? onBackPressed;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback? onPlayPressed;

  const MovieDetailsHeader({
    super.key,
    this.backgroundImage,
    this.ytTrailerCode,
    this.onBackPressed,
    this.onBookmarkPressed,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (backgroundImage != null && backgroundImage!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: backgroundImage!,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.grey,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.grey,
                child: Icon(Icons.movie, size: 60.sp, color: Colors.white38),
              ),
            )
          else
            Container(
              color: AppColors.grey,
              child: Icon(Icons.movie, size: 60.sp, color: Colors.white38),
            ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: GestureDetector(
              onTap: onBackPressed ?? () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),

          // Bookmark button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 16.w,
            child: GestureDetector(
              onTap: onBookmarkPressed,
              child: Icon(
                Icons.bookmark_border,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),

          // Play button
          Center(
            child: GestureDetector(
              onTap: onPlayPressed,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  AppAssets.playIcon,
                  width: 80.w,
                  height: 80.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

