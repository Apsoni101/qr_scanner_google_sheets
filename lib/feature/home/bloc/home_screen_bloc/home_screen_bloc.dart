import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_result_remote_use_case.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_scan_local_use_case.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc({
    required this.remoteUseCase,
    required this.localUseCase,
  }) : super(const HomeScreenInitial()) {
    on<OnHomeLoadInitial>(_onLoadInitial);
    on<OnHomeSyncPendingScans>(_onSyncPendingScans);
    on<OnHomeRefreshSheets>(_onRefreshSheets);
    on<OnHomeNetworkStatusChanged>(_onNetworkStatusChanged);
  }

  final QrResultRemoteUseCase remoteUseCase;
  final QrScanLocalUseCase localUseCase;

  // Handle initial load: check for pending syncs and load sheets
  Future<void> _onLoadInitial(
      final OnHomeLoadInitial event,
      final Emitter<HomeScreenState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Get pending syncs count
      final Either<Failure, List<QrScanEntity>> pendingResult =
      await localUseCase.getPendingSyncScans();

      int pendingCount = 0;
      pendingResult.fold(
            (_) => pendingCount = 0,
            (scans) => pendingCount = scans.length,
      );

      // If online, sync immediately
      if (state.isOnline && pendingCount > 0) {
        emit(state.copyWith(
          isLoading: false,
          pendingSyncCount: pendingCount,
        ));
        // Trigger sync
        add(const OnHomeSyncPendingScans());
      } else {
        emit(state.copyWith(
          isLoading: false,
          pendingSyncCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to initialize: ${e.toString()}',
      ));
    }
  }

  // Sync pending scans with remote
  Future<void> _onSyncPendingScans(
      final OnHomeSyncPendingScans event,
      final Emitter<HomeScreenState> emit,
      ) async {
    if (!state.isOnline) {
      emit(state.copyWith(
        syncError: 'No internet connection. Scans will sync when online.',
      ));
      return;
    }

    emit(state.copyWith(isSyncing: true, syncError: null));

    try {
      // Get all pending scans
      final Either<Failure, List<QrScanEntity>> pendingResult =
      await localUseCase.getPendingSyncScans();

      await pendingResult.fold(
            (failure) async {
          emit(state.copyWith(
            isSyncing: false,
            syncError: failure.message,
          ));
        },
            (pendingScans) async {
          if (pendingScans.isEmpty) {
            emit(state.copyWith(
              isSyncing: false,
              pendingSyncCount: 0,
              showSyncSuccess: true,
            ));
            return;
          }

          int syncedCount = 0;
          String? lastError;

          // Sync each pending scan
          for (int i = 0; i < pendingScans.length; i++) {
            final scan = pendingScans[i];
            // Assuming sheetId is stored in scan or we use a default
            // You may need to modify this based on your data structure
            final result = await remoteUseCase.saveScan(
              scan,
              'default_sheet_id', // Replace with actual sheet ID
            );

            result.fold(
                  (failure) {
                lastError = failure.message;
              },
                  (_) async {
                syncedCount++;
                // Remove synced item from local pending
                await localUseCase.removeSyncedScan('default_sheet_id', 0);
              },
            );
          }

          final remainingCount = pendingScans.length - syncedCount;

          emit(state.copyWith(
            isSyncing: false,
            pendingSyncCount: remainingCount,
            syncError: lastError,
            showSyncSuccess: remainingCount == 0,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isSyncing: false,
        syncError: 'Sync failed: ${e.toString()}',
      ));
    }
  }

  // Refresh sheets from remote
  Future<void> _onRefreshSheets(
      final OnHomeRefreshSheets event,
      final Emitter<HomeScreenState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final result = await remoteUseCase.getOwnedSheets();

      result.fold(
            (failure) {
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        },
            (sheets) async {
          // Cache sheets locally
          for (final sheet in sheets) {
            await localUseCase.cacheSheet(sheet);
          }

          emit(state.copyWith(isLoading: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to refresh: ${e.toString()}',
      ));
    }
  }

  // Handle network status changes
  Future<void> _onNetworkStatusChanged(
      final OnHomeNetworkStatusChanged event,
      final Emitter<HomeScreenState> emit,
      ) async {
    emit(state.copyWith(isOnline: event.isConnected));

    // If connection is restored, trigger sync
    if (event.isConnected && state.pendingSyncCount > 0) {
      add(const OnHomeSyncPendingScans());
    }
  }
}