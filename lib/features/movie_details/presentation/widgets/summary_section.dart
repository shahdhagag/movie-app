import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class SummarySection extends StatelessWidget {
  final String? summary;
  final String? descriptionFull;

  const SummarySection({
    super.key,
    this.summary,
    this.descriptionFull,
  });

  @override
  Widget build(BuildContext context) {
    final text = descriptionFull ?? summary;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: AppStyles.h5),
          Gap( 10.h),
          Text(
            text,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

