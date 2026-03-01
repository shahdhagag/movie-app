import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/core/utils/app_assets.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/movie.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(const LoadMovies()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.red, size: 60.sp),
                  Gap(16.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            final movies = state.movies;
            final featuredMovies = movies.take(20).toList();
            final actionMovies = state.actionMovies;
            final adventureMovies = state.adventureMovies;
            final animationMovies = state.animationMovies;


            return Stack(
              children: [
                /// Full-screen background image
                Positioned.fill(
                  child: Image.asset(
                    AppAssets.backgroundImage,
                    fit: BoxFit.fill,
                  ),
                ),

                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.6),
                          AppColors.background.withValues(alpha: 0.8),
                          AppColors.background.withValues(alpha: 0.95),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                /// Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 100.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),

                        Center(
                          child: Image.asset(
                            AppAssets.availableNowLogo,
                            width: 250.w,
                            height: 93.h,
                          ),
                        ),
                        Gap(20.h),

                        /// Featured Movies Carousel
                        CarouselSlider.builder(
                          itemCount: featuredMovies.length,
                          options: CarouselOptions(
                            height: 300.h,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.25,
                            viewportFraction: 0.55,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.easeInOut,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final movie = featuredMovies[index];
                            return MovieCard(
                              imagePath: movie.coverImage,
                              rating: movie.rating,
                              onTap: () {
                                context.push(
                                  AppRoutes.movieDetails,
                                  extra: movie.id,
                                );
                              },
                              width: 200,
                              height: 300,
                            );
                          },
                        ),

                        Center(
                          child: Image.asset(
                            AppAssets.watchNowLogo,
                            width: 320.w,
                            height: 140.h,
                          ),
                        ),

                        /// ACTION SECTION
                        _buildGenreSection(
                          context: context,
                          title: 'Action',
                          allGenreMovies: actionMovies,
                        ),

                        Gap(16.h),

                        /// ADVENTURE SECTION
                        _buildGenreSection(
                          context: context,
                          title: 'Adventure',
                          allGenreMovies: adventureMovies,
                        ),

                        Gap(16.h),

                        /// ANIMATION SECTION
                        _buildGenreSection(
                          context: context,
                          title: 'Animation',
                          allGenreMovies: animationMovies,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  ///  header + horizontal movie list
  Widget _buildGenreSection({
    required BuildContext context,
    required String title,
    required List<Movie> allGenreMovies,
  }) {
    // Show up to 10 in the horizontal preview list
    final previewMovies = allGenreMovies.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: title,
          onSeeMore: () {
            context.push(
              AppRoutes.genreMovies,
              extra: {
                'genre': title,
                'movies': allGenreMovies,
              },
            );
          },
        ),
        SizedBox(
          height: 180.h,
          child: previewMovies.isEmpty
              ? Center(
            child: Text(
              'No $title movies available',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: previewMovies.length,
            itemBuilder: (context, index) {
              final movie = previewMovies[index];
              return MovieCard(
                imagePath: movie.coverImage,
                rating: movie.rating,
                onTap: () {
                  context.push(
                    AppRoutes.movieDetails,
                    extra: movie.id,
                  );
                },
                width: 120,
                height: 180,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeMore,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: onSeeMore,
            child: Row(
              children: [
                Text(
                  "See More",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}