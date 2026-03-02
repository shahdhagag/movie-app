import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentIndex: 0));

  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}