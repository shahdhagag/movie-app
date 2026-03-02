import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../home/domain/entities/movie.dart';

class SimilarMoviesSection extends StatelessWidget {
  final List<Movie> suggestions;

  const SimilarMoviesSection({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Similar', style: AppStyles.h5),
          Gap( 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.65,
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final movie = suggestions[index];
              return _SimilarMovieCard(movie: movie);
            },
          ),
        ],
      ),
    );
  }
}

class _SimilarMovieCard extends StatelessWidget {
  final Movie movie;

  const _SimilarMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.movieDetails, extra: movie.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: movie.coverImage,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.grey,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.grey,
                child: const Icon(Icons.movie, color: Colors.white38),
              ),
            ),
            // Rating badge
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                    Gap( 3.w),
                    Icon(Icons.star, color: AppColors.primary, size: 12.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

