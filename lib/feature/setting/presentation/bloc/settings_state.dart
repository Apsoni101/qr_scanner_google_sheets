part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class CurrentUserLoaded extends SettingsState {
  const CurrentUserLoaded({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class SignOutSuccess extends SettingsState {
  const SignOutSuccess();
}

final class SettingsError extends SettingsState {
  const SettingsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}