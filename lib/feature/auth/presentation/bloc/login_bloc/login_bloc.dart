import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/auth/domain/use_cases/auth_remote_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authRemoteUseCase}) : super(const LoginInitial()) {
    on<OnGoogleLoginEvent>(_onGoogleLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  final AuthRemoteUseCase authRemoteUseCase;

  Future<void> _onGoogleLoginEvent(
    final OnGoogleLoginEvent event,
    final Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final Either<Failure, UserEntity> result = await authRemoteUseCase
        .signInWithGoogle();

    await result.fold(
      (final Failure failure) async {
        emit(LoginError(message: failure.message));
        emit(const LoginInitial());
      },
      (final UserEntity user) async {
        emit(LoginSuccess(isNewUser: user.isNewUser));
      },
    );
  }

  Future<void> _onLogoutEvent(
    final LogoutEvent event,
    final Emitter<LoginState> emit,
  ) async {
    emit(const LoginInitial());
  }
}
