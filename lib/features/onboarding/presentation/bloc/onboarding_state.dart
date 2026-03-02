class OnboardingState {
  final int currentIndex;

  const OnboardingState({
    required this.currentIndex,
  });

  bool isLast(int length) => currentIndex == length - 1;

  OnboardingState copyWith({
    int? currentIndex,
  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}