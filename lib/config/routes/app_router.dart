import 'dart:async';
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
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screen/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../services/auth_service.dart';
import 'app_routes.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    }, onError: (_) {
      notifyListeners();
    });
  }

  StreamSubscription<dynamic>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static final AuthService _authService = getIt<AuthService>();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(path: AppRoutes.splash, name: 'splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, name: 'onboarding', builder: (c, s) => OnboardingScreen()),
      GoRoute(path: AppRoutes.login, name: 'login', builder: (context, state) => BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>(), child: const LoginScreen())),
      GoRoute(path: AppRoutes.register, name: 'register', builder: (context, state) => BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>(), child: const RegisterScreen())),
      GoRoute(path: AppRoutes.forgotPassword, name: 'forgotPassword', builder: (context, state) => BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>(), child: const ForgotPasswordScreen())),
      GoRoute(path: AppRoutes.main, name: 'main', builder: (c, s) => const MainScreen()),
      GoRoute(path: AppRoutes.home, name: 'home', builder: (c, s) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.genreMovies,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return GenreMoviesScreen(genre: extras['genre'] as String, movies: extras['movies'] as List<Movie>);
        },
      ),
      GoRoute(
        path: AppRoutes.movieDetails,
        builder: (context, state) {
          final extra = state.extra;
          final movieId = extra is int ? extra : int.tryParse(state.uri.queryParameters['id'] ?? '');
          if (movieId == null || movieId <= 0) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text('Unable to open this movie right now.', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => GoRouter.of(context).pop(), child: const Text('Go Back')),
                    ],
                  ),
                ),
              ),
            );
          }
          return MovieDetailsScreen(movieId: movieId);
        },
      ),
      GoRoute(path: AppRoutes.search, name: 'search', builder: (c, s) => const SearchScreen()),
      GoRoute(path: AppRoutes.browse, name: 'browse', builder: (c, s) => const BrowseScreen()),
      GoRoute(path: AppRoutes.profile, name: 'profile', builder: (context, state) => BlocProvider<ProfileBloc>.value(value: getIt<ProfileBloc>(), child: const ProfileScreen())),
      GoRoute(path: AppRoutes.editProfile, name: 'editProfile', builder: (context, state) => BlocProvider<ProfileBloc>.value(value: getIt<ProfileBloc>(), child: const EditProfileScreen())),
    ],

    redirect: (context, state) {
      final loggedIn = _authService.isLoggedIn;
      final publicPaths = <String>{AppRoutes.splash, AppRoutes.onboarding, AppRoutes.login, AppRoutes.register, AppRoutes.forgotPassword};
      final goingToLogin = state.matchedLocation == AppRoutes.login;
      final goingToPublic = publicPaths.contains(state.matchedLocation);

      if (!loggedIn && !goingToPublic) return AppRoutes.login;
      if (loggedIn && goingToLogin) return AppRoutes.main;
      return null;
    },

    refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
  );
}