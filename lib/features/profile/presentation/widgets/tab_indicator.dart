import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            // Icon
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              size: 28.sp,
            ),
            SizedBox(height: 8.h),
            // Label
            Text(
              label,
              style: AppStyles.h5.copyWith(
                fontSize: 16.sp,
                color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            // Underline indicator
            Container(
              width: double.infinity,
              height: 2.h,
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
