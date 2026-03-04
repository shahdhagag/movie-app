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
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 120.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(50.h),

                        Center(
                          child: Image.asset(
                            AppAssets.availableNowLogo,
                            width: 300.w,
                            height: 100.h,
                          ),
                        ),
                        Gap(30.h),

                        /// Featured Movies Carousel
                        CarouselSlider.builder(
                          key: const ValueKey('featured_carousel'),
                          itemCount: featuredMovies.length,
                          options: CarouselOptions(
                            height: 380.h,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            viewportFraction: 0.5,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
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
                              width: 250.w,
                              height: 350.h,
                            );
                          },
                        ),

                        Gap(20.h),

                        Center(
                          child: Image.asset(
                            AppAssets.watchNowLogo,
                            width: 320.w,
                            height: 140.h,
                          ),
                        ),

                        Gap(16.h),

                        /// ACTION SECTION
                        _buildGenreSection(
                          context: context,
                          title: 'Action',
                          allGenreMovies: actionMovies,
                        ),

                        Gap(24.h),

                        /// ADVENTURE SECTION
                        _buildGenreSection(
                          context: context,
                          title: 'Adventure',
                          allGenreMovies: adventureMovies,
                        ),

                        Gap(24.h),

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

  Widget _buildGenreSection({
    required BuildContext context,
    required String title,
    required List<Movie> allGenreMovies,
  }) {
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
        Gap(12.h),
        SizedBox(
          height: 220.h,
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
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: previewMovies.length,
            separatorBuilder: (context, index) => Gap(12.w),
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
                width: 160.w,
                height: 230.h,
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
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  "See More",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(4.w),
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