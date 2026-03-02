import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';


/// GoRouter Configuration
class AppRouter {

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
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
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const Placeholder(), // TODO: Replace with HomeScreen
      ),

      GoRoute(
        path: '${AppRoutes.movieDetails}/:id',
        name: 'movieDetails',
        builder: (context, state) {
          final movieId = state.pathParameters['id']!;
          return Placeholder(); // TODO: Replace with MovieDetailsScreen(movieId: movieId)
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
        builder: (context, state) => const Placeholder(), // TODO: Replace with SearchScreen
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const Placeholder(), // TODO: Replace with ProfileScreen
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const Placeholder(), // TODO: Replace with EditProfileScreen
      ),
      GoRoute(
        path: AppRoutes.updateProfile,
        name: 'updateProfile',
        builder: (context, state) => const Placeholder(), // TODO: Replace with UpdateProfileScreen
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

    // Redirect logic (optional)
    redirect: (context, state) {
      // Add your redirect logic here
      // For example, check if user is logged in, first time user, etc.
      return null; // No redirect
    },
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


