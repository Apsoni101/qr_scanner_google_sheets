import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/auth/domain/use_cases/auth_local_usecase.dart';
import 'package:qr_scanner_practice/feature/auth/domain/use_cases/auth_remote_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.authRemoteUseCase,
    required this.authLocalUseCase,
  }) : super(const LoginInitial()) {
    on<OnGoogleLoginEvent>(_onGoogleLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  final AuthRemoteUseCase authRemoteUseCase;
  final AuthLocalUseCase authLocalUseCase;

  // -------------------- Google Login --------------------

  Future<void> _onGoogleLoginEvent(
      OnGoogleLoginEvent event,
      Emitter<LoginState> emit,
      ) async {
    debugPrint('🚀 Google Login Started');

    emit(const LoginLoading());
    debugPrint('⏳ State -> LoginLoading');

    final Either<Failure, UserEntity> result =
    await authRemoteUseCase.signInWithGoogle();

    debugPrint('📦 Google Login API response received');

    await result.fold(
          (failure) async {
        debugPrint('❌ Login Failed');
        debugPrint('💥 Failure message: ${failure.message}');

        emit(LoginError(message: failure.message));
        debugPrint('⚠️ State -> LoginError');

        emit(const LoginInitial());
        debugPrint('🔄 State -> LoginInitial (reset)');
      },
          (user) async {
        debugPrint('✅ Login Success');
        debugPrint('👤 User ID: ${user.uid}');
        debugPrint('🆕 Is New User: ${user.isNewUser}');

        await authLocalUseCase.saveUserCredentials(user);
        debugPrint('💾 User saved locally');

        emit(LoginSuccess(isNewUser: user.isNewUser));
        debugPrint('🎉 State -> LoginSuccess');
      },
    );
  }

  // -------------------- Logout --------------------

  Future<void> _onLogoutEvent(
      LogoutEvent event,
      Emitter<LoginState> emit,
      ) async {
    debugPrint('🚪 Logout triggered');

    emit(const LoginInitial());
    debugPrint('🔄 State -> LoginInitial');
  }
}
