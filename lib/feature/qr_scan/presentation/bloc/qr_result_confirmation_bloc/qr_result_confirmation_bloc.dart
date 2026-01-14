import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_result_remote_use_case.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/usecase/qr_scan_local_use_case.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/qr_scan_model.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/sheet_model.dart';

part 'qr_result_confirmation_event.dart';
part 'qr_result_confirmation_state.dart';

class QrResultConfirmationBloc
    extends Bloc<QrResultConfirmationEvent, QrResultConfirmationState> {
  QrResultConfirmationBloc({
    required this.remoteUseCase,
    required this.localUseCase,
  }) : super(const QrResultConfirmationInitial()) {
    on<OnConfirmationLoadSheets>(_onLoadSheets);
    on<OnConfirmationSheetSelected>(_onSheetSelected);
    on<OnConfirmationCreateSheet>(_onCreateSheet);
    on<OnConfirmationSheetNameChanged>(_onSheetNameChanged);
    on<OnConfirmationModeToggled>(_onModeToggled);
    on<OnConfirmationSaveScan>(_onSaveScan);
  }

  final QrResultRemoteUseCase remoteUseCase;
  final QrScanLocalUseCase localUseCase;

  /// Load sheets: try remote first, fallback to local
  Future<void> _onLoadSheets(
      final OnConfirmationLoadSheets event,
      final Emitter<QrResultConfirmationState> emit,
      ) async {
    emit(state.copyWith(isLoadingSheets: true));

    // Try to fetch from remote
    final Either<Failure, List<SheetEntity>> remoteResult =
    await remoteUseCase.getOwnedSheets();

    await remoteResult.fold(
          (failure) async {
        // Remote failed, try local cache
        final Either<Failure, List<SheetEntity>> localResult =
        await localUseCase.getLocalSheets();

        localResult.fold(
              (localFailure) {
            emit(
              state.copyWith(
                isLoadingSheets: false,
                sheetsLoadError:
                'Failed to load sheets: ${failure.message}',
              ),
            );
          },
              (sheets) {
            emit(
              state.copyWith(
                isLoadingSheets: false,
                sheets: sheets,
                selectedSheetId: sheets.isNotEmpty ? sheets.first.id : null,
                isCachedData: true,
              ),
            );
          },
        );
      },
          (sheets) async {
        // Remote succeeded, cache locally and emit
        for (final sheet in sheets) {
          await localUseCase.cacheSheet(sheet);
        }

        emit(
          state.copyWith(
            isLoadingSheets: false,
            sheets: sheets,
            selectedSheetId: sheets.isNotEmpty ? sheets.first.id : null,
            isCachedData: false,
          ),
        );
      },
    );
  }

  void _onSheetSelected(
      final OnConfirmationSheetSelected event,
      final Emitter<QrResultConfirmationState> emit,
      ) {
    emit(state.copyWith(selectedSheetId: event.sheetId));
  }

  void _onSheetNameChanged(
      final OnConfirmationSheetNameChanged event,
      final Emitter<QrResultConfirmationState> emit,
      ) {
    emit(state.copyWith(newSheetName: event.sheetName));
  }

  void _onModeToggled(
      final OnConfirmationModeToggled event,
      final Emitter<QrResultConfirmationState> emit,
      ) {
    emit(
      state.copyWith(isCreatingNewSheet: event.isCreating, newSheetName: ''),
    );
  }

  /// Create sheet: try remote first, fallback to local-only
  Future<void> _onCreateSheet(
      final OnConfirmationCreateSheet event,
      final Emitter<QrResultConfirmationState> emit,
      ) async {
    final String trimmedName = state.newSheetName.trim();
    final bool isEmpty = trimmedName.isEmpty;

    if (isEmpty) {
      emit(state.copyWith(sheetCreationError: 'Sheet name cannot be empty'));
      return;
    }

    emit(state.copyWith(isCreatingSheet: true));

    // Try to create on remote first
    final Either<Failure, String> createResult =
    await remoteUseCase.createSheet(trimmedName);

    await createResult.fold(
          (failure) async {
        // Remote creation failed - inform user but allow offline creation
        emit(
          state.copyWith(
            isCreatingSheet: false,
            sheetCreationError:
            'Sheet created locally. Will sync when online.',
          ),
        );

        // Create locally with temporary ID
        final String tempId = 'local_${DateTime.now().millisecondsSinceEpoch}';
        final sheet = SheetEntity(
          id: tempId,
          title: trimmedName,
          createdTime: DateTime.now().toIso8601String(),
          modifiedTime: DateTime.now().toIso8601String(),
        );

        await localUseCase.cacheSheet(sheet);

        // Reload sheets
        final Either<Failure, List<SheetEntity>> loadResult =
        await localUseCase.getLocalSheets();

        loadResult.fold(
              (localFailure) {
            emit(
              state.copyWith(
                sheetsLoadError: localFailure.message,
                isCreatingNewSheet: false,
                newSheetName: '',
              ),
            );
          },
              (sheets) {
            emit(
              state.copyWith(
                sheets: sheets,
                selectedSheetId: tempId,
                isCreatingNewSheet: false,
                newSheetName: '',
                isCachedData: true,
              ),
            );
          },
        );
      },
          (sheetId) async {
        // Remote creation succeeded
        emit(state.copyWith(isCreatingSheet: false));

        // Reload sheets from remote
        final Either<Failure, List<SheetEntity>> loadResult =
        await remoteUseCase.getOwnedSheets();

        loadResult.fold(
              (failure) {
            emit(
              state.copyWith(
                sheetsLoadError: failure.message,
                isCreatingNewSheet: false,
                newSheetName: '',
              ),
            );
          },
              (sheets) async {
            // Cache locally
            for (final sheet in sheets) {
              await localUseCase.cacheSheet(sheet);
            }

            emit(
              state.copyWith(
                sheets: sheets,
                selectedSheetId: sheetId,
                isCreatingNewSheet: false,
                newSheetName: '',
                isCachedData: false,
              ),
            );
          },
        );
      },
    );
  }

  /// Save scan: try remote first, fallback to local cache
  Future<void> _onSaveScan(
      final OnConfirmationSaveScan event,
      final Emitter<QrResultConfirmationState> emit,
      ) async {
    emit(state.copyWith(isSavingScan: true));

    final QrScanModel scanModel = QrScanModel.fromEntity(event.scanEntity);

    // Try to save remotely
    final Either<Failure, Unit> remoteResult = await remoteUseCase.saveScan(
      event.scanEntity,
      event.sheetTitle,
    );

    await remoteResult.fold(
          (failure) async {
        // Remote save failed - save locally instead
        final Either<Failure, Unit> localResult = await localUseCase
            .cacheQrScan(scanModel, event.sheetTitle);

        localResult.fold(
              (localFailure) {
            emit(
              state.copyWith(
                isSavingScan: false,
                scanSaveError: 'Failed to save: ${localFailure.message}',
              ),
            );
          },
              (_) {
            emit(
              state.copyWith(
                isSavingScan: false,
                isScanSaved: true,
                scanSaveError:
                'Saved locally. Will sync when connection is restored.',
              ),
            );
          },
        );
      },
          (_) async {
        // Remote save succeeded, also cache locally
        await localUseCase.cacheQrScan(scanModel, event.sheetTitle);

        emit(
          state.copyWith(
            isSavingScan: false,
            isScanSaved: true,
          ),
        );
      },
    );
  }
}