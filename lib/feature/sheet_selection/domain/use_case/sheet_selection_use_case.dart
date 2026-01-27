import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/paged_sheets_entity.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/result_scan_entity.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/repo/sheet_selection_repository.dart';

class SheetSelectionUseCase {
  const SheetSelectionUseCase({required this.repository});

  final SheetSelectionRepository repository;

  /// Local operations
  Future<Either<Failure, List<SheetEntity>>> getLocalSheets() =>
      repository.getLocalSheets();

  Future<Either<Failure, Unit>> cacheSheet(final SheetEntity sheet) =>
      repository.cacheSheet(sheet);

  Future<Either<Failure, Unit>> cacheScanResult(
    final ScanResultEntity scan,
    final String sheetId,
    final String sheetTitle,
  ) => repository.cacheScanResult(scan, sheetId, sheetTitle);

  /// Remote operations
  Future<Either<Failure, PagedSheetsEntity>> getOwnedSheets({
    final String? pageToken,
    final int? pageSize,
  }) => repository.getOwnedSheets(pageToken: pageToken, pageSize: pageSize);

  Future<Either<Failure, String>> createSheet(final String sheetName) =>
      repository.createSheet(sheetName);

  Future<Either<Failure, Unit>> saveScan(
    final ScanResultEntity entity,
    final String sheetId,
  ) => repository.saveScan(entity, sheetId);
}
