import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/services/connectivity_service.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/pending_sync_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_result_remote_use_case.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_scan_local_use_case.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc({
    required this.remoteUseCase,
    required this.localUseCase,
    required this.connectivityService,
  }) : super(const HomeScreenInitial()) {
    on<OnHomeLoadInitial>(_onLoadInitial);
    on<OnHomeSyncPendingScans>(_onSyncPendingScans);
    on<OnHomeRefreshSheets>(_onRefreshSheets);
    on<OnHomeNetworkStatusChanged>(_onNetworkStatusChanged);

    /// Listening to connectivity changes
    _connectivitySubscription = connectivityService
        .onConnectivityChanged()
        .listen((final bool isOnline) {
          add(OnHomeNetworkStatusChanged(isOnline));
        });
  }

  final QrResultRemoteUseCase remoteUseCase;
  final QrScanLocalUseCase localUseCase;
  final ConnectivityService connectivityService;

  late final StreamSubscription<bool> _connectivitySubscription;

  /// Handle initial load: checking for pending syncs and loading sheets
  Future<void> _onLoadInitial(
    final OnHomeLoadInitial event,
    final Emitter<HomeScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final bool isOnline = await connectivityService.hasInternetConnection();

    final Either<Failure, List<PendingSyncEntity>> pendingResult =
        await localUseCase.getPendingSyncScans();

    await pendingResult.fold(
      (final Failure failure) async {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (final List<PendingSyncEntity> syncs) async {
        final int pendingCount = syncs.length;

        emit(
          state.copyWith(
            isLoading: false,
            isOnline: isOnline,
            pendingSyncCount: pendingCount,
          ),
        );

        if (isOnline && pendingCount > 0) {
          add(const OnHomeSyncPendingScans());
        }
      },
    );
  }

  Future<void> _onSyncPendingScans(
    final OnHomeSyncPendingScans event,
    final Emitter<HomeScreenState> emit,
  ) async {
    final bool isOnline = await connectivityService.hasInternetConnection();

    if (!isOnline) {
      emit(
        state.copyWith(
          syncError: 'No internet connection. Scans will sync when online.',
          isOnline: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isSyncing: true, isOnline: true));

    final Either<Failure, List<PendingSyncEntity>> pendingResult =
        await localUseCase.getPendingSyncScans();

    await pendingResult.fold(
      (final Failure failure) async {
        emit(state.copyWith(isSyncing: false, syncError: failure.message));
      },
      (final List<PendingSyncEntity> pendingSyncs) async {
        if (pendingSyncs.isEmpty) {
          emit(
            state.copyWith(
              isSyncing: false,
              pendingSyncCount: 0,
              showSyncSuccess: true,
            ),
          );
          return;
        }

        int syncedCount = 0;
        String? lastError;

        for (int i = 0; i < pendingSyncs.length; i++) {
          final PendingSyncEntity pendingSync = pendingSyncs[i];
          final QrScanEntity scan = pendingSync.scan;
          final String sheetId = pendingSync.sheetId;

          final Either<Failure, Unit> result = await remoteUseCase.saveScan(
            scan,
            sheetId,
          );

          await result.fold(
            (final Failure failure) {
              lastError = failure.message;
            },
            (_) async {
              syncedCount++;
              await localUseCase.removeSyncedScan(i);
            },
          );
        }

        final int remainingCount = pendingSyncs.length - syncedCount;

        emit(
          state.copyWith(
            isSyncing: false,
            pendingSyncCount: remainingCount,
            syncError: lastError,
            showSyncSuccess: remainingCount == 0,
            isOnline: true,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshSheets(
    final OnHomeRefreshSheets event,
    final Emitter<HomeScreenState> emit,
  ) async {
    final bool isOnline = await connectivityService.hasInternetConnection();

    if (!isOnline) {
      emit(
        state.copyWith(
          error: 'No internet connection. Cannot refresh sheets.',
          isOnline: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, isOnline: true));

    final Either<Failure, List<SheetEntity>> result = await remoteUseCase
        .getOwnedSheets();

    await result.fold(
      (final Failure failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (final List<SheetEntity> sheets) async {
        for (final SheetEntity sheet in sheets) {
          await localUseCase.cacheSheet(sheet);
        }

        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> _onNetworkStatusChanged(
    final OnHomeNetworkStatusChanged event,
    final Emitter<HomeScreenState> emit,
  ) async {
    final bool wasOnline = state.isOnline;
    final bool isNowOnline = event.isConnected;

    emit(state.copyWith(isOnline: isNowOnline));

    if (isNowOnline && !wasOnline && state.pendingSyncCount > 0) {
      add(const OnHomeSyncPendingScans());
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
