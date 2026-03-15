import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_conatiner.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/ui/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/browse/presentation/screen/browes_screen.dart';
import '../../features/home/domain/entities/movie.dart';
import '../../features/home/presentation/screens/genre_movies_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/movie_details/presentation/screens/movie_details_screen.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screen/search_screen.dart';
import '../../features/splash/splash_screen.dart';
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
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
      ),

      /// Main App Flow
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
        builder: (context, state) {
          final bloc = state.extra as ProfileBloc?;
          return BlocProvider<ProfileBloc>.value(
            value: bloc ?? getIt<ProfileBloc>(),
            child: const EditProfileScreen(),
          );
        },
      ),

      // ========== Placeholder Routes for Future Implementation ==========
      GoRoute(
        path: AppRoutes.moviesByGenre,
        name: 'moviesByGenre',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.moviesByCategory,
        name: 'moviesByCategory',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: '${AppRoutes.watchMovie}/:id',
        name: 'watchMovie',
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
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.watchlist,
        name: 'watchlist',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        name: 'privacy',
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        name: 'terms',
        builder: (context, state) => const Placeholder(),
      ),
    ],

    // Error handler
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
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
