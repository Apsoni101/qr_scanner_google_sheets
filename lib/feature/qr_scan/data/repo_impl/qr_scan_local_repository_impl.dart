import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/data_source/sheets_local_data_source.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/qr_scan_model.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/sheet_model.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/repo/qr_scan_local_repository.dart';

class QrScanLocalRepositoryImpl implements QrScanLocalRepository {
  const QrScanLocalRepositoryImpl({required this.localDataSource});

  final SheetsLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<SheetEntity>>> getLocalSheets() =>
      localDataSource.getLocalSheets();

  @override
  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet) =>
      localDataSource.saveSheetLocally(SheetModel.fromEntity(sheet));

  @override
  Future<Either<Failure, Unit>> cacheQrScan(
    final QrScanEntity scan,
    final String sheetId,
  ) => localDataSource.saveQrScanLocally(QrScanModel.fromEntity(scan), sheetId);

  @override
  Future<Either<Failure, List<QrScanEntity>>> getCachedScans(
    final String sheetId,
  ) => localDataSource.getLocalQrScans(sheetId);

  @override
  Future<Either<Failure, List<QrScanEntity>>> getPendingSyncScans() =>
      localDataSource.getPendingSyncs();

  @override
  Future<Either<Failure, Unit>> removeSyncedScan(
    final String sheetId,
    final int index,
  ) => localDataSource.removePendingSync(sheetId, index);

  @override
  Future<Either<Failure, Unit>> clearAllCache() =>
      localDataSource.clearLocalData();
}
