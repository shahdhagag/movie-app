import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';

class GenreMoviesScreen extends StatelessWidget {
  final String genre;
  final List<Movie> movies;

  const GenreMoviesScreen({
    super.key,
    required this.genre,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '$genre Movies',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: movies.isEmpty
          ? Center(
        child: Text(
          'No $genre movies found',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
          ),
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.65,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              imagePath: movie.coverImage,
              rating: movie.rating,
              onTap: () {
                context.push(
                  AppRoutes.movieDetails,
                  extra: movie.id,
                );
              },
              width: 160.w,
              height: 240.h,
            );
          },
        ),
      ),
    );
  }
}