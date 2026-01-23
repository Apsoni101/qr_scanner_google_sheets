import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/setting/domain/usecase/settings_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.settingsUseCase}) : super(const SettingsLoading()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<SignOutEvent>(_onSignOut);
  }

  final SettingsUseCase settingsUseCase;

  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event,
      Emitter<SettingsState> emit,
      ) async {
    emit(const SettingsLoading());

    final result = await settingsUseCase.getCurrentUser();

    result.fold(
          (failure) => emit(SettingsError(message: failure.message)),
          (user) => emit(CurrentUserLoaded(user: user)),
    );
  }

  Future<void> _onSignOut(
      SignOutEvent event,
      Emitter<SettingsState> emit,
      ) async {
    emit(const SettingsLoading());

    final result = await settingsUseCase.signOut();

    result.fold(
          (failure) => emit(SettingsError(message: failure.message)),
          (_) => emit(const SignOutSuccess()),
    );
  }
}