import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class MovieStatsRow extends StatelessWidget {
  final int likeCount;
  final int runtime;
  final double rating;

  const MovieStatsRow({
    super.key,
    required this.likeCount,
    required this.runtime,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(AppAssets.favouritesIcon, likeCount.toString()),
          _buildStat(AppAssets.clockIcon, '$runtime min'),
          _buildStat(AppAssets.starIcon, rating.toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _buildStat(String iconPath, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 20.sp,
            height: 20.sp,
          ),
          Gap( 6.w),
          Text(
            value,
            style: AppStyles.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}