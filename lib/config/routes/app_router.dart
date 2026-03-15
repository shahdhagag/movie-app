import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_conatiner.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/ui/onboarding_screen.dart';
import 'package:movie/features/home/presentation/screens/home_screen.dart';
import '../../features/browse/presentation/screen/browes_screen.dart';
import '../../features/home/domain/entities/movie.dart';
import '../../features/home/presentation/screens/genre_movies_screen.dart';
import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/movie_details/presentation/screens/movie_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screen/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';


/// GoRouter Configuration
class AppRouter {

  static final GoRouter router = GoRouter(
     initialLocation: AppRoutes.splash,
   // initialLocation: AppRoutes.main,
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
        builder: (context, state) => OnboardingScreen() ,
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


    ],



  );
}




