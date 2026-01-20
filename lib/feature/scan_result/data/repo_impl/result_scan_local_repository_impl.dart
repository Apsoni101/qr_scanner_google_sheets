import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/scan_result/data/data_source/scan_result_local_data_source.dart';
import 'package:qr_scanner_practice/feature/scan_result/data/model/pending_sync_model.dart';
import 'package:qr_scanner_practice/feature/scan_result/data/model/scan_result_model.dart';
import 'package:qr_scanner_practice/feature/scan_result/data/model/sheet_model.dart';
import 'package:qr_scanner_practice/feature/scan_result/domain/entity/pending_sync_entity.dart';
import 'package:qr_scanner_practice/feature/scan_result/domain/entity/result_scan_entity.dart';
import 'package:qr_scanner_practice/feature/scan_result/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/scan_result/domain/repo/result_scan_local_repository.dart';

class ResultScanLocalRepositoryImpl implements ResultScanLocalRepository {
  const ResultScanLocalRepositoryImpl({required this.localDataSource});

  final ScanResultLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<SheetEntity>>> getLocalSheets() =>
      localDataSource.getLocalSheets();

  @override
  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet) =>
      localDataSource.saveSheetLocally(SheetModel.fromEntity(sheet));

  @override
  Future<Either<Failure, Unit>> cacheResultScan(
    final ResultScanEntity scan,
    final String sheetId,
    final String sheetTitle,
  ) => localDataSource.saveResultScanLocally(
    ScanResultModel.fromEntity(scan),
    sheetId,
    sheetTitle,
  );

  @override
  Future<Either<Failure, List<ResultScanEntity>>> getCachedScans(
    final String sheetId,
  ) => localDataSource.getLocalResultScans(sheetId);

  @override
  Future<Either<Failure, List<PendingSyncEntity>>> getPendingSyncScans() async {
    final Either<Failure, List<PendingSyncModel>> result = await localDataSource
        .getPendingSyncs();

    return result.fold(
      Left.new,
      (final List<PendingSyncModel> models) =>
          Right<Failure, List<PendingSyncEntity>>(
            models
                .map((final PendingSyncModel model) => model.toEntity())
                .toList(),
          ),
    );
  }

  @override
  Future<Either<Failure, Unit>> removeSyncedScan(final int index) =>
      localDataSource.removePendingSync(index);

  @override
  Future<Either<Failure, Unit>> clearAllCache() =>
      localDataSource.clearLocalData();
}
