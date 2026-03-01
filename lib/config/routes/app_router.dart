import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/features/home/presentation/screens/home_screen.dart';
import '../../features/browse/presentation/screen/browes_screen.dart';
import '../../features/home/domain/entities/movie.dart';
import '../../features/home/presentation/screens/genre_movies_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/movie_details/presentation/screens/movie_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screen/search_screen.dart';
import 'app_routes.dart';


/// GoRouter Configuration
class AppRouter {

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.main, //  start with main

   // initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [

      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const Placeholder(), // TODO: Replace with SplashScreen
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const Placeholder(), // TODO: Replace with OnboardingScreen
      ),

      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const Placeholder(), // TODO: Replace with LoginScreen
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const Placeholder(), // TODO: Replace with RegisterScreen
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const Placeholder(), // TODO: Replace with ForgotPasswordScreen
      ),

      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.genreMovies,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return GenreMoviesScreen(
            genre: extras['genre'] as String,
            movies: extras['movies'] as List<Movie>,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.movieDetails,
        builder: (context, state) {
          final movieId = state.extra as int;
          return MovieDetailsScreen(movieId: movieId);
        },
      ),
      GoRoute(
        path: AppRoutes.moviesByGenre,
        name: 'moviesByGenre',
        builder: (context, state) {
          final genreId = state.uri.queryParameters['genreId'];
          final genreName = state.uri.queryParameters['genreName'];
          return Placeholder(); // TODO: Replace with MoviesByGenreScreen
        },
      ),
      GoRoute(
        path: AppRoutes.moviesByCategory,
        name: 'moviesByCategory',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          return Placeholder(); // TODO: Replace with MoviesByCategoryScreen
        },
      ),
      GoRoute(
        path: '${AppRoutes.watchMovie}/:id',
        name: 'watchMovie',
        builder: (context, state) {
          final movieId = state.pathParameters['id']!;
          return Placeholder(); // TODO: Replace with WatchMovieScreen
        },
      ),

      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.browse,
        name: 'browse',
        builder: (context, state) => const BrowseScreen(),
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),



      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.updateProfile,
        name: 'updateProfile',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        builder: (context, state) => const Placeholder(), // TODO: Replace with FavoritesScreen
      ),
      GoRoute(
        path: AppRoutes.watchlist,
        name: 'watchlist',
        builder: (context, state) => const Placeholder(), // TODO: Replace with WatchlistScreen
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const Placeholder(), // TODO: Replace with SettingsScreen
      ),

      // ========== OTHER ROUTES ==========
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const Placeholder(), // TODO: Replace with AboutScreen
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: 'privacy',
        builder: (context, state) => const Placeholder(), // TODO: Replace with PrivacyScreen
      ),
      GoRoute(
        path: AppRoutes.terms,
        name: 'terms',
        builder: (context, state) => const Placeholder(), // TODO: Replace with TermsScreen
      ),
    ],

    // Error handler
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),


  );
}

// /// Router Helper Extension
// extension RouterHelper on BuildContext {
//   // Navigation helpers
//   void goToSplash() => go(AppRoutes.splash);
//   void goToOnboarding() => go(AppRoutes.onboarding);
//   void goToLogin() => go(AppRoutes.login);
//   void goToRegister() => go(AppRoutes.register);
//   void goToForgotPassword() => go(AppRoutes.forgotPassword);
//   void goToHome() => go(AppRoutes.home);
//   void goToSearch() => go(AppRoutes.search);
//   void goToProfile() => go(AppRoutes.profile);
//   void goToSettings() => go(AppRoutes.settings);
//   void goToFavorites() => go(AppRoutes.favorites);
//   void goToWatchlist() => go(AppRoutes.watchlist);
//
//   // Navigation with parameters
//   void goToMovieDetails(String movieId) => go('${AppRoutes.movieDetails}/$movieId');
//   void goToWatchMovie(String movieId) => go('${AppRoutes.watchMovie}/$movieId');
//
//   void goToMoviesByGenre({
//     required String genreId,
//     required String genreName,
//   }) {
//     go('${AppRoutes.moviesByGenre}?genreId=$genreId&genreName=$genreName');
//   }
//
//   void goToMoviesByCategory(String category) {
//     go('${AppRoutes.moviesByCategory}?category=$category');
//   }
// }
//


