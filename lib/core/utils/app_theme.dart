import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static final ThemeData DarkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(AppStyles.movieTitle),

        backgroundColor: MaterialStateProperty.all(AppColors.primary),
        // fixedSize: MaterialStateProperty.all(const Size(350, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.w,vertical: 30.h)),
      ),
    ),
  );
}