import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/qr_scan_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/qr_scan/domain/repo/qr_scan_local_repository.dart';

class QrScanLocalUseCase {
  const QrScanLocalUseCase({required this.repository});

  final QrScanLocalRepository repository;

  Future<Either<Failure, List<SheetEntity>>> getLocalSheets() =>
      repository.getLocalSheets();

  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet) =>
      repository.cacheSheet(sheet);

  Future<Either<Failure, Unit>> cacheQrScan(
      final QrScanEntity scan,
      final String sheetId,
      ) =>
      repository.cacheQrScan(scan, sheetId);

  Future<Either<Failure, List<QrScanEntity>>> getCachedScans(
      final String sheetId,
      ) =>
      repository.getCachedScans(sheetId);

  Future<Either<Failure, List<QrScanEntity>>> getPendingSyncScans() =>
      repository.getPendingSyncScans();

  Future<Either<Failure, Unit>> removeSyncedScan(
      final String sheetId,
      final int index,
      ) =>
      repository.removeSyncedScan(sheetId, index);

  Future<Either<Failure, Unit>> clearAllCache() =>
      repository.clearAllCache();
}