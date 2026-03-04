import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_colors.dart';
import '../bloc/movie_details_bloc.dart';
import '../bloc/movie_details_event.dart';
import '../bloc/movie_details_state.dart';
import '../widgets/cast_section.dart';
import '../widgets/genres_section.dart';
import '../widgets/movie_details_header.dart';
import '../widgets/movie_info_section.dart';
import '../widgets/movie_stats_row.dart';
import '../widgets/screenshots_section.dart';
import '../widgets/similar_movies_section.dart';
import '../widgets/summary_section.dart';
import '../widgets/watch_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieDetailsBloc>()
        ..add(LoadMovieDetails(movieId: movieId)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is MovieDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.red, size: 60.sp),
                    Gap( 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Gap( 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<MovieDetailsBloc>()
                            .add(LoadMovieDetails(movieId: movieId));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is MovieDetailsLoaded) {
              final movie = state.movieDetails;
              final suggestions = state.suggestions;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Background image (header)
                        MovieDetailsHeader(
                          backgroundImage: movie.backgroundImageOriginal ??
                              movie.backgroundImage ??
                              movie.largeCoverImage,
                          ytTrailerCode: movie.ytTrailerCode,
                          onPlayPressed: () {
                            // TODO: Open trailer
                          },
                        ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 150.h,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.background.withValues(alpha: 0.7),
                                  AppColors.background,
                                ],
                                stops: const [0.0, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Movie info (title, year, runtime) positioned

                        Positioned(
                          bottom: 16.h,
                          left: 16.w,
                          right: 16.w,
                          child: MovieInfoSection(
                            title: movie.title,
                            year: movie.year,
                            runtime: movie.runtime,
                          ),
                        ),
                      ],
                    ),

                    Gap( 16.h),


                    WatchButton(
                      onPressed: () {
                        // TODO: Navigate to watch/download
                      },
                    ),

                    Gap(16.h),



                    MovieStatsRow(
                      likeCount: movie.likeCount,
                      runtime: movie.runtime,
                      rating: movie.rating,
                    ),

                    Gap( 24.h),

                    ScreenShotsSection(
                      screenshot1: movie.largeScreenshotImage1 ??
                          movie.mediumScreenshotImage1,
                      screenshot2: movie.largeScreenshotImage2 ??
                          movie.mediumScreenshotImage2,
                      screenshot3: movie.largeScreenshotImage3 ??
                          movie.mediumScreenshotImage3,
                    ),

                    Gap( 24.h),

                    SimilarMoviesSection(suggestions: suggestions),

                    Gap( 24.h),

                    SummarySection(
                      summary: movie.summary,
                      descriptionFull: movie.descriptionFull,
                    ),

                    Gap( 24.h),

                    CastSection(cast: movie.cast),

                    Gap( 24.h),

                    GenresSection(genres: movie.genres),

                    Gap( 40.h),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}