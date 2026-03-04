import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/cast.dart';

class CastSection extends StatelessWidget {
  final List<Cast> cast;

  const CastSection({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cast', style: AppStyles.h5),
          SizedBox(height: 12.h),
          ...cast.map((actor) => _CastTile(actor: actor)),
        ],
      ),
    );
  }
}

class _CastTile extends StatelessWidget {
  final Cast actor;

  const _CastTile({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.grey,

        ),
        child: Row(
          children: [
            // Actor image
            ClipOval(
              child: actor.urlSmallImage != null && actor.urlSmallImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: actor.urlSmallImage!,
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 50.w,
                        height: 50.w,
                        color: AppColors.grey,
                        child: Icon(Icons.person, color: Colors.white38, size: 24.sp),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 50.w,
                        height: 50.w,
                        color: AppColors.grey,
                        child: Icon(Icons.person, color: Colors.white38, size: 24.sp),
                      ),
                    )
                  : Container(
                      width: 50.w,
                      height: 50.w,
                      color: AppColors.grey,
                      child: Icon(Icons.person, color: Colors.white38, size: 24.sp),
                    ),
            ),
            SizedBox(width: 12.w),
            // Actor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name : ${actor.name}',
                    style: AppStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (actor.characterName.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Character : ${actor.characterName}',
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

