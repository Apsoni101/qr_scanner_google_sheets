part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => <Object>[];
}

final class OnGoogleLoginEvent extends LoginEvent {
  const OnGoogleLoginEvent();

  @override
  List<Object?> get props => <Object>[];
}

final class LogoutEvent extends LoginEvent {
  const LogoutEvent();
}