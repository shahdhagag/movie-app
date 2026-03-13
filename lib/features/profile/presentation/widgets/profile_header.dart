import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;
  final int watchListCount;
  final int historyCount;

  const ProfileHeader({
    Key? key,
    required this.userProfile,
    required this.watchListCount,
    required this.historyCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 3.w,
            ),
          ),
          child: ClipOval(
            child: userProfile.photoUrl != null && userProfile.photoUrl!.isNotEmpty
                ? Image.asset(
                    userProfile.photoUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.grey,
                    child: Icon(
                      Icons.person,
                      size: 60.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
        Gap(16.h),

        // Name
        Text(
          userProfile.displayName,
          style: AppStyles.h3,
          textAlign: TextAlign.center,
        ),
        Gap(8.h),

        // Email
        Text(
          userProfile.email,
          style: AppStyles.h4.copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
        Gap(16.h),

        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  watchListCount.toString(),
                  style: AppStyles.h2,
                ),
                Text(
                  'Watch List',
                  style: AppStyles.h5.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            Gap(60.w),
            Column(
              children: [
                Text(
                  historyCount.toString(),
                  style: AppStyles.h2,
                ),
                Text(
                  'History',
                  style: AppStyles.h5.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

