import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/pending_sync_entity.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/result_scan_entity.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/sheet_entity.dart';

abstract class SheetSelectionRepository {
  /// Local operations
  Future<Either<Failure, List<SheetEntity>>> getLocalSheets();

  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet);

  Future<Either<Failure, Unit>> cacheScanResult(
    final ScanResultEntity scan,
    final String sheetId,
    final String sheetTitle,
  );

  /// Remote operations
  Future<Either<Failure, List<SheetEntity>>> getOwnedSheets();

  Future<Either<Failure, String>> createSheet(final String sheetName);

  Future<Either<Failure, Unit>> saveScan(
    final ScanResultEntity entity,
    final String sheetId,
  );
}
