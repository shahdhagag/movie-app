import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:movie/core/utils/app_assets.dart';
import 'package:movie/core/utils/app_styles.dart';
import 'onboarding_bottom_card.dart';

class OnboardingFirstPage extends StatelessWidget {
  final VoidCallback onExplore;

  const OnboardingFirstPage({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppAssets.onboarding1, fit: BoxFit.cover),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Find Your Next Favorite Movie Here',
                    style: AppStyles.h1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(10.h),

                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Get access to a huge library of movies to suit all tastes. You will surely like it.',
                      style: AppStyles.h1copy,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Gap(10.h),

                Padding(
                  padding : EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onExplore,
                      child: Text('Explore Now', style: AppStyles.textButton),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
