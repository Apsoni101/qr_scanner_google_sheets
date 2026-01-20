part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object>[];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.isNewUser});

  final bool isNewUser;

  @override
  List<Object?> get props => <Object?>[isNewUser];
}

final class LoginError extends LoginState {
  const LoginError({required this.message});

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
