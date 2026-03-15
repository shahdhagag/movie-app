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
    return Padding(

      padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 20.h),
      child: Row(
        children: [

          // Avatar & Name Column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  width: 118.w,
                  height: 118.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2.w,
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
                              size: 40.sp,
                              color: AppColors.textTertiary,
                            ),
                          ),
                  ),
                ),
                Gap(12.h),
                Text(
                  userProfile.displayName,
                  style: AppStyles.h3.copyWith(fontSize: 22.sp,fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Stats
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(watchListCount.toString(), 'Watch List'),
                _buildStatItem(historyCount.toString(), 'History'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppStyles.h2.copyWith(fontSize: 35.sp,fontWeight: FontWeight.w700),
        ),
        Gap(4.h),
        Text(
          label,
          style: AppStyles.h5.copyWith(
            fontSize: 25.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
