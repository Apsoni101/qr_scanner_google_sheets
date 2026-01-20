import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/result_scan/data/data_source/scan_result_remote_data_source.dart';
import 'package:qr_scanner_practice/feature/result_scan/data/model/scan_result_model.dart';
import 'package:qr_scanner_practice/feature/result_scan/domain/entity/result_scan_entity.dart';
import 'package:qr_scanner_practice/feature/result_scan/domain/entity/sheet_entity.dart';
import 'package:qr_scanner_practice/feature/result_scan/domain/repo/result_scan_remote_repository.dart';

class ResultScanRemoteRepositoryImpl implements ResultScanRemoteRepository {
  const ResultScanRemoteRepositoryImpl({required this.remoteDataSource});

  final ResultScanRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<SheetEntity>>> getOwnedSheets() =>
      remoteDataSource.getOwnedSheets();

  @override
  Future<Either<Failure, String>> createSheet(final String sheetName) =>
      remoteDataSource.createSheet(sheetName);

  @override
  Future<Either<Failure, Unit>> saveScan(
    final ResultScanEntity entity,
    final String sheetId,
  ) => remoteDataSource.saveScan(ScanResultModel.fromEntity(entity), sheetId);

  @override
  Future<Either<Failure, List<ResultScanEntity>>> getAllScans(
    final String sheetId,
  ) => remoteDataSource.read(sheetId);

  @override
  Future<Either<Failure, Unit>> updateScan(
    final String sheetId,
    final String range,
    final ResultScanEntity entity,
  ) => remoteDataSource.update(
    sheetId,
    range,
    ScanResultModel.fromEntity(entity),
  );

  @override
  Future<Either<Failure, Unit>> deleteScan(
    final String sheetId,
    final String range,
  ) => remoteDataSource.delete(sheetId, range);
}
