import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_assets.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? imagePath;

  const EmptyStateWidget({
    super.key,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        imagePath ?? AppAssets.emptyStateSearchList,
        width: 150.w,
        height: 150.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
