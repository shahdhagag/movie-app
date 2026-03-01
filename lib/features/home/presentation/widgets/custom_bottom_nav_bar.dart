import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      AppAssets.homeIcon,
      AppAssets.searchIcon,
      AppAssets.exploreIcon,
      AppAssets.profileIcon,
    ];

    return Container(
      height: 60.h,
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(8.w),
              child: Image.asset(
                items[index],
                width: 22.w,
                height: 22.h,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          );
        }),
      ),
    );
  }
}