import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/core/utils/app_assets.dart';
import 'package:movie/features/onboarding/presentation/ui/widgets/onboarding_first_page.dart';
import 'package:movie/features/onboarding/presentation/ui/widgets/onboarding_page_item.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../bloc/onboarding_cubit.dart';
import '../bloc/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController controller = PageController();

  final List<OnboardingEntity> pages = const [
    OnboardingEntity(image: "", title: "", description: "", isFirstPage: true),
    OnboardingEntity(
      image: AppAssets.onboarding2,
      title: "Discover Movies",
      description:
          'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',

    ),
    OnboardingEntity(
      image: AppAssets.onboarding3,
      title: "Explore All Genres",
      description:
          'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
    ),
    OnboardingEntity(
      image: AppAssets.onboarding4,
      title: "Create Watchlists",
      description:
          'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',

    ),
    OnboardingEntity(
      image: AppAssets.onboarding5,
      title: "Rate, Review, and Learn",
      description:
          "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",

    ),
    OnboardingEntity(
      image: AppAssets.onboarding6,
      title: "Start Watching Now",
      description: '',

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            body: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                context.read<OnboardingCubit>().changePage(index);
              },
              itemBuilder: (context, index) {
                final page = pages[index];

                if (page.isFirstPage) {
                  return OnboardingFirstPage(
                    onExplore: () {

                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  );
                }

                return OnboardingPageItem(
                  entity: page,
                  isLast: state.isLast(pages.length),
                  onNext: () {
                    if (state.isLast(pages.length)) {
                      context.go('/login');
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  onBack: index > 0
                      ? () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
