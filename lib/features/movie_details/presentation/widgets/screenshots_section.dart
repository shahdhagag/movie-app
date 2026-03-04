import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class ScreenShotsSection extends StatelessWidget {
  final String? screenshot1;
  final String? screenshot2;
  final String? screenshot3;

  const ScreenShotsSection({
    super.key,
    this.screenshot1,
    this.screenshot2,
    this.screenshot3,
  });

  @override
  Widget build(BuildContext context) {
    final screenshots = [screenshot1, screenshot2, screenshot3]
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toList();

    if (screenshots.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen Shots', style: AppStyles.h5),
          SizedBox(height: 12.h),
          ...screenshots.map(
            (url) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 180.h,
                    color: AppColors.grey,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 180.h,
                    color: AppColors.grey,
                    child: const Icon(Icons.broken_image, color: Colors.white38),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

