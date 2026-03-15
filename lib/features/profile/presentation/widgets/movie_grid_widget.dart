import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/movie_item.dart';

class MovieGridWidget extends StatelessWidget {
  final List<MovieItem> movies;
  final void Function(MovieItem)? onMovieTap;

  const MovieGridWidget({
    Key? key,
    required this.movies,
    this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 80.sp,
              color: AppColors.textTertiary,
            ),
            Gap(16.h),
            Text(
              'No movies yet',
              style: AppStyles.h4.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.6,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => onMovieTap?.call(movie),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey[900],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Movie Poster
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/emptyStates/place_holder.jpg',
                    image: movie.posterPath,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        Container(
                      color: AppColors.grey,
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

