import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../home/presentation/widgets/movie_card.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/Search_error_widget.dart';
import '../widgets/search_bar_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),

      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [

                  /// SEARCH BAR
                  SearchBarWidget(),


                  /// RESULTS
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        /// LOADING
                        if (state is SearchLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        /// SUCCESS
                        if (state is SearchSuccess) {
                          if (state.movies.isEmpty) {
                            return _emptyState();
                          }

                          return GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.65,
                            ),
                            itemCount: state.movies.length,
                            itemBuilder: (context, index) {
                              final movie = state.movies[index];

                              return MovieCard(
                                imagePath: movie.image,
                                rating: movie.rating,
                                width: 160.w,
                                height: 240.h,
                                onTap: () {
                                  context.push(
                                    AppRoutes.movieDetails,
                                    extra: movie.id,
                                  );
                                },
                              );
                            },
                          );
                        }

                        /// ERROR
                        if (state is SearchError) {
                          SearchErrorWidget(message: state.message,
                            onRetry: () => context.read<SearchCubit>().searchMovies(""),
                          );
                        }

                        /// INITIAL
                        return _emptyState();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Image.asset(AppAssets.emptyStateSearchList, width: 125.w),
    );
  }
}
