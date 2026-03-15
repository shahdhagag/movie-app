import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

void showWatchListFeedbackSnackBar(
  BuildContext context, {
  required bool isAdded,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        duration: const Duration(seconds: 2),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.grey,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isAdded ? AppColors.primary : AppColors.textTertiary,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                isAdded
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_remove_outlined,
                size: 20.sp,
                color: isAdded ? AppColors.primary : AppColors.textPrimary,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  isAdded ? 'Added to watchlist' : 'Removed from watchlist',
                  style: AppStyles.h6.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
