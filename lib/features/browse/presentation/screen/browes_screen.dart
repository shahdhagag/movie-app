import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../../home/presentation/widgets/movie_card.dart';
import '../cubit/browse_cubit.dart';
import '../cubit/browse_state.dart';
import '../widgets/genre_chip.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = {
      "Action": "action",
      "Adventure": "adventure",
      "Animation": "animation",
      "Comedy": "comedy",
      "Crime": "crime",
      "Documentary": "documentary",
      "Drama": "drama",
      "Family": "family",
      "Fantasy": "fantasy",
      "History": "history",
      "Horror": "horror",
      "Music": "music",
      "Mystery": "mystery",
      "Romance": "romance",
      "Sci-Fi": "sci-fi",
      "Thriller": "thriller",
      "War": "war",
      "Western": "western",
    };

    return BlocProvider(
      create: (_) => getIt<BrowseCubit>()..loadMovies(genre: "action"),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              /// GENRES
              BlocBuilder<BrowseCubit, BrowseState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 50.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: genres.entries.map((genre) {
                          return BlocBuilder<BrowseCubit, BrowseState>(
                            buildWhen: (previous, current) =>
                                previous.selectedGenre != current.selectedGenre,
                            builder: (context, state) {
                              return GenreChip(
                                title: genre.key,
                                isSelected: state.selectedGenre == genre.value,
                                onTap: () {
                                  context.read<BrowseCubit>().loadMovies(
                                    genre: genre.value,
                                  );
                                },
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              /// MOVIES GRID
              Expanded(
                child: BlocBuilder<BrowseCubit, BrowseState>(
                  builder: (context, state) {
                    if (state is BrowseError) {
                      return Center(child: Text(state.message));
                    }

                    final isLoading = state is BrowseLoading;

                    final movies = state is BrowseLoaded
                        ? state.movies
                        : List.generate(6, (index) => null);

                    return Skeletonizer(
                      enabled: isLoading,
                      effect: ShimmerEffect(
                        baseColor: Colors.grey[900]!,
                        highlightColor: Colors.grey[800]!,
                        duration: const Duration(milliseconds: 1000),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: movies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: .65,
                            ),
                        itemBuilder: (context, index) {
                          if (state is BrowseLoading) {
                            return const MovieCard(imagePath: "", rating: 0.0);
                          }
                          final movie = movies[index];

                          return MovieCard(
                            imagePath: movie?.coverImage ?? "",
                            rating: movie?.rating ?? 7.0,
                            onTap: movie != null
                                ? () => context.push(
                                    AppRoutes.movieDetails,
                                    extra: movie.id,
                                  )
                                : null, // Disable taps during skeleton state
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
