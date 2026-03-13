import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_styles.dart';

class TabIndicator extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TabIndicator({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Icon
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textTertiary,
            size: 24.sp,
          ),
          SizedBox(height: 8.h),
          // Label
          Text(
            label,
            style: AppStyles.h5.copyWith(
              fontSize: 14.sp,
              color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(height: 8.h),
          // Underline indicator
          if (isSelected)
            Container(
              width: 60.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
        ],
      ),
    );
  }
}

