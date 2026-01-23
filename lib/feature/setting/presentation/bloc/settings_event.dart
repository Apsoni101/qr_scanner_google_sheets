part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class GetCurrentUserEvent extends SettingsEvent {
  const GetCurrentUserEvent();
}

final class SignOutEvent extends SettingsEvent {
  const SignOutEvent();
}