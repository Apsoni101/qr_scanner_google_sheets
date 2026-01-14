import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/core/services/storage/hive_service.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/qr_scan_model.dart';
import 'package:qr_scanner_practice/feature/qr_scan/data/model/sheet_model.dart';

abstract class SheetsLocalDataSource {
  Future<Either<Failure, List<SheetModel>>> getLocalSheets();

  Future<Either<Failure, Unit>> saveSheetLocally(final SheetModel sheet);

  Future<Either<Failure, Unit>> saveQrScanLocally(
      final QrScanModel scan,
      final String sheetId,
      );

  Future<Either<Failure, List<QrScanModel>>> getLocalQrScans(
      final String sheetId,
      );

  Future<Either<Failure, List<QrScanModel>>> getPendingSyncs();

  Future<Either<Failure, Unit>> removePendingSync(
      final String sheetId,
      final int index,
      );

  Future<Either<Failure, Unit>> clearLocalData();
}

class SheetsLocalDataSourceImpl implements SheetsLocalDataSource {
  SheetsLocalDataSourceImpl({required this.hiveService});

  final HiveService hiveService;

  static const String _sheetsBoxName = 'qr_sheets';
  static const String _scansBoxName = 'qr_scans';
  static const String _pendingSyncsKey = 'pending_syncs';

  @override
  Future<Either<Failure, List<SheetModel>>> getLocalSheets() async {
    try {
      final List<SheetModel>? sheets =
      hiveService.getObjectList<SheetModel>(_sheetsBoxName);
      return Right(sheets ?? <SheetModel>[]);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to fetch local sheets: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSheetLocally(
      final SheetModel sheet,
      ) async {
    try {
      final List<SheetModel>? existingSheets =
      hiveService.getObjectList<SheetModel>(_sheetsBoxName);
      final List<SheetModel> sheets = existingSheets ?? <SheetModel>[];

      final int existingIndex =
      sheets.indexWhere((s) => s.id == sheet.id);
      if (existingIndex != -1) {
        sheets[existingIndex] = sheet;
      } else {
        sheets.add(sheet);
      }

      await hiveService.setObjectList(_sheetsBoxName, sheets);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to save sheet locally: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveQrScanLocally(
      final QrScanModel scan,
      final String sheetId,
      ) async {
    try {
      final String scanKey = '${_scansBoxName}_$sheetId';
      final List<QrScanModel>? existingScans =
      hiveService.getObjectList<QrScanModel>(scanKey);
      final List<QrScanModel> scans = existingScans ?? <QrScanModel>[];

      scans.add(scan);
      await hiveService.setObjectList(scanKey, scans);

      // Add to pending syncs
      await _addPendingSync(sheetId, scan);

      return const Right(unit);
    } catch (e) {
      return Left(
        Failure(
          message: 'Failed to save QR scan locally: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<QrScanModel>>> getLocalQrScans(
      final String sheetId,
      ) async {
    try {
      final String scanKey = '${_scansBoxName}_$sheetId';
      final List<QrScanModel>? scans =
      hiveService.getObjectList<QrScanModel>(scanKey);
      return Right(scans ?? <QrScanModel>[]);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to fetch local scans: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<QrScanModel>>> getPendingSyncs() async {
    try {
      final List<QrScanModel>? pendingSyncs =
      hiveService.getObjectList<QrScanModel>(_pendingSyncsKey);
      return Right(pendingSyncs ?? <QrScanModel>[]);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to fetch pending syncs: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> removePendingSync(
      final String sheetId,
      final int index,
      ) async {
    try {
      final List<QrScanModel>? pendingSyncs =
      hiveService.getObjectList<QrScanModel>(_pendingSyncsKey);
      if (pendingSyncs != null && index < pendingSyncs.length) {
        pendingSyncs.removeAt(index);
        await hiveService.setObjectList(_pendingSyncsKey, pendingSyncs);
      }
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to remove pending sync: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearLocalData() async {
    try {
      await hiveService.remove(_sheetsBoxName);
      await hiveService.remove(_scansBoxName);
      await hiveService.remove(_pendingSyncsKey);
      return const Right(unit);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to clear local data: ${e.toString()}'),
      );
    }
  }

  Future<void> _addPendingSync(
      final String sheetId,
      final QrScanModel scan,
      ) async {
    final List<QrScanModel>? pendingSyncs =
    hiveService.getObjectList<QrScanModel>(_pendingSyncsKey);
    final List<QrScanModel> syncs = pendingSyncs ?? <QrScanModel>[];
    syncs.add(scan);
    await hiveService.setObjectList(_pendingSyncsKey, syncs);
  }
}