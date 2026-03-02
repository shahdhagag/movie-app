import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class MovieInfoSection extends StatelessWidget {
  final String title;
  final int year;
  final int runtime;

  const MovieInfoSection({
    super.key,
    required this.title,
    required this.year,
    required this.runtime,
  });

  String get _formattedRuntime {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
    if (hours > 0) return '${hours}h';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.h3,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Gap( 8.h),
          Text(
            [
              year.toString(),
              if (_formattedRuntime.isNotEmpty) _formattedRuntime,
            ].join('  •  '),
            textAlign: TextAlign.center,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
