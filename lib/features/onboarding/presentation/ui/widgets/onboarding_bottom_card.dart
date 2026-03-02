import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:movie/core/utils/app_colors.dart';
import 'package:movie/core/utils/app_styles.dart';

class OnboardingBottomCard extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;


  const OnboardingBottomCard({
    super.key,
    required this.title,
    required this.description,
    required this.primaryText,
    required this.onPrimaryPressed,
    this.secondaryText,
    this.onSecondaryPressed,
    // this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      ),
      child: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(title, style: AppStyles.h3, textAlign: TextAlign.center),
            Gap(9.h),

            Text(description, textAlign: TextAlign.center, style: AppStyles.h4),
            Gap(7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPrimaryPressed,
                  child: Text(primaryText, style: AppStyles.textButton),
                ),
              ),
            ),
            Gap(7.h),
            if (secondaryText != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.background,

                      side: BorderSide(color: AppColors.primary, width: 2),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    onPressed: onSecondaryPressed,
                    child: Text(
                      secondaryText!,
                      style: AppStyles.outlineButtonText,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
