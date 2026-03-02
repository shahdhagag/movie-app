import 'package:flutter/material.dart';

import '../../../domain/entities/onboarding_entity.dart';
import 'onboarding_bottom_card.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingEntity entity;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool isLast;

  const OnboardingPageItem({
    super.key,
    required this.entity,
    required this.onNext,
    this.onBack,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            entity.image,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: OnboardingBottomCard(
            title: entity.title,
            description: entity.description,

            primaryText: isLast ? "Finish" : "Next",
            onPrimaryPressed: onNext,
            secondaryText: onBack != null ? "Back" : null,
            onSecondaryPressed: onBack,

          ),
        )
      ],
    );
  }
}