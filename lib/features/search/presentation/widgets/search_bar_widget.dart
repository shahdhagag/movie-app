
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_assets.dart';
import '../cubit/search_cubit.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 16.h),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [Color(0xff2C2C2C), Color(0xff3A3A3A)],
          ),
        ),
        child: TextField(
          onChanged: (value) {
            context.read<SearchCubit>().searchMovies(value);
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.white),
            prefixIcon: Padding(
              padding: EdgeInsets.all(11.0),
              child: ImageIcon(
                AssetImage(AppAssets.searchIcon),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}