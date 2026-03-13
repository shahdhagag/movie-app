import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  const FetchUserProfile();
}

class FetchWatchList extends ProfileEvent {
  const FetchWatchList();
}

class FetchHistory extends ProfileEvent {
  const FetchHistory();
}

class SwitchTabEvent extends ProfileEvent {
  final int tabIndex;

  const SwitchTabEvent(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}

class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}

