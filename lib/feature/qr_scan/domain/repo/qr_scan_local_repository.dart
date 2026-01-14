import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';

abstract class QrScanLocalRepository {
  Future<Either<Failure, List<SheetEntity>>> getLocalSheets();

  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet);

  Future<Either<Failure, Unit>> cacheQrScan(
    final QrScanEntity scan,
    final String sheetId,
  );

  Future<Either<Failure, List<QrScanEntity>>> getCachedScans(
    final String sheetId,
  );

  Future<Either<Failure, List<QrScanEntity>>> getPendingSyncScans();

  Future<Either<Failure, Unit>> removeSyncedScan(
    final String sheetId,
    final int index,
  );

  Future<Either<Failure, Unit>> clearAllCache();
}
