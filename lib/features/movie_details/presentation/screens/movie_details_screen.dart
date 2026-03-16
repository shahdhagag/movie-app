import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
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
import '../widgets/watchlist_feedback_snackbar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _historySaved = false;
  bool _isInWatchList = false;
  bool _isBookmarkLoading = false;

  void _initBookmarkFromProfile(int movieId) {
    try {
      final profileState = getIt<ProfileBloc>().state;
      if (profileState is ProfileLoaded) {
        final exists = profileState.watchList.any((m) => m.movieId == movieId);
        setState(() => _isInWatchList = exists);
      }
    } catch (_) {
    }
  }

  Future<void> _saveToHistory(MovieDetailsLoaded state) async {
    if (_historySaved) return;

    final movie = state.movieDetails;
    final posterPath =
        movie.largeCoverImage ?? movie.mediumCoverImage ?? movie.smallCoverImage ?? '';

    _historySaved = true;

    try {
      getIt<ProfileBloc>().add(AddToHistory(
        movieId: movie.id,
        title: movie.title,
        posterPath: posterPath,
      ));
    } catch (_) {
      _historySaved = false;
    }
  }

  Future<void> _fallbackLoadWatchListStatus(int movieId) async {
    try {
      final result = await getIt.call<Function>();
    } catch (_) {
    }
  }

  Future<void> _toggleWatchList(MovieDetailsLoaded state) async {
    if (_isBookmarkLoading) return;

    setState(() => _isBookmarkLoading = true);

    final movie = state.movieDetails;
    final posterPath =
        movie.largeCoverImage ?? movie.mediumCoverImage ?? movie.smallCoverImage ?? '';

    final willAdd = !_isInWatchList;
    setState(() => _isInWatchList = willAdd);

    try {
      if (willAdd) {
        getIt<ProfileBloc>().add(AddToWatchList(
          movieId: movie.id,
          title: movie.title,
          posterPath: posterPath,
        ));
      } else {
        getIt<ProfileBloc>().add(RemoveFromWatchList(movieId: movie.id));
      }
    } catch (_) {
      setState(() => _isInWatchList = !willAdd);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update watchlist right now'), backgroundColor: Colors.red),
      );
    }

    showWatchListFeedbackSnackBar(context, isAdded: willAdd);

    if (mounted) setState(() => _isBookmarkLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieDetailsBloc>()..add(LoadMovieDetails(movieId: widget.movieId)),
      child: BlocListener<ProfileBloc, ProfileState>(
        bloc: getIt<ProfileBloc>(),
        listener: (context, pState) {
          if (pState is ActionError) {
            if (pState.action == 'add_to_watchlist') {
              setState(() => _isInWatchList = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(pState.message), backgroundColor: AppColors.red),
              );
            } else if (pState.action == 'remove_from_watchlist') {
              setState(() => _isInWatchList = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(pState.message), backgroundColor: AppColors.red),
              );
            } else if (pState.action == 'add_to_history') {
              _historySaved = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(pState.message), backgroundColor: AppColors.red),
              );
            }
          } else if (pState is MovieAddedToWatchList) {
            setState(() => _isInWatchList = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to Watchlist'), backgroundColor: Colors.green),
            );
          } else if (pState is MovieRemovedFromWatchList) {
            setState(() => _isInWatchList = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from Watchlist'), backgroundColor: Colors.orange),
            );
          } else if (pState is MovieAddedToHistory) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to History'), backgroundColor: Colors.green),
            );
          }
        },
        child: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
          listener: (context, state) {
            if (state is MovieDetailsLoaded) {
              _initBookmarkFromProfile(state.movieDetails.id);

              _saveToHistory(state);
            }
          },
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              );
            }

            if (state is MovieDetailsError) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: AppColors.red, size: 60.sp),
                      Gap(16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
                        ),
                      ),
                      Gap(16.h),
                      ElevatedButton(
                        onPressed: () => context.read<MovieDetailsBloc>().add(LoadMovieDetails(movieId: widget.movieId)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is MovieDetailsLoaded) {
              final movie = state.movieDetails;
              final suggestions = state.suggestions;

              return Scaffold(
                backgroundColor: AppColors.background,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          MovieDetailsHeader(
                            backgroundImage: movie.backgroundImageOriginal ?? movie.backgroundImage ?? movie.largeCoverImage,
                            ytTrailerCode: movie.ytTrailerCode,
                            isBookmarked: _isInWatchList,
                            isBookmarkLoading: _isBookmarkLoading,
                            onBookmarkPressed: () => _toggleWatchList(state),
                            onPlayPressed: () {},
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

                          Positioned(
                            bottom: 16.h,
                            left: 16.w,
                            right: 16.w,
                            child: MovieInfoSection(title: movie.title, year: movie.year, runtime: movie.runtime),
                          ),
                        ],
                      ),

                      Gap(16.h),

                      WatchButton(onPressed: () {}),

                      Gap(16.h),

                      MovieStatsRow(likeCount: movie.likeCount, runtime: movie.runtime, rating: movie.rating),

                      Gap(24.h),

                      ScreenShotsSection(
                        screenshot1: movie.largeScreenshotImage1 ?? movie.mediumScreenshotImage1,
                        screenshot2: movie.largeScreenshotImage2 ?? movie.mediumScreenshotImage2,
                        screenshot3: movie.largeScreenshotImage3 ?? movie.mediumScreenshotImage3,
                      ),

                      Gap(24.h),

                      SimilarMoviesSection(suggestions: suggestions),

                      Gap(24.h),

                      SummarySection(summary: movie.summary, descriptionFull: movie.descriptionFull),

                      Gap(24.h),

                      CastSection(cast: movie.cast),

                      Gap(24.h),

                      GenresSection(genres: movie.genres),

                      Gap(40.h),
                    ],
                  ),
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