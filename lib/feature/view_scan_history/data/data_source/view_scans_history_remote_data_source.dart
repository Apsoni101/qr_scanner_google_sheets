import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qr_scanner_practice/core/constants/app_constants.dart';
import 'package:qr_scanner_practice/core/firebase/firebase_auth_service.dart';
import 'package:qr_scanner_practice/core/network/constants/network_constants.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/core/network/http_api_client.dart';
import 'package:qr_scanner_practice/core/network/http_method.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/data/model/scan_result_model.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/data/model/sheet_model.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/domain/entity/pending_sync_entity.dart';

abstract class ViewScansHistoryRemoteDataSource {
  Future<Either<Failure, List<PendingSyncEntity>>> getAllScansFromAllSheets();
}

class ViewScansHistoryRemoteDataSourceImpl
    implements ViewScansHistoryRemoteDataSource {
  ViewScansHistoryRemoteDataSourceImpl({
    required this.apiClient,
    required this.authService,
  });

  final HttpApiClient apiClient;
  final FirebaseAuthService authService;

  Future<Either<Failure, Options>> _getAuthorizedOptions() async {
    final Either<Failure, String> tokenResult = await authService
        .getGoogleAccessToken();
    return tokenResult.fold(
      Left.new,
      (final String token) => Right<Failure, Options>(
        Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      ),
    );
  }

  Future<Either<Failure, List<SheetModel>>> _getOwnedSheets(
    final Options options,
  ) async {
    const String query =
        'mimeType="${NetworkConstants.sheetMimeType}" '
        'and "me" in owners '
        'and trashed=false '
        'and (properties has { key="appCreated" and value="${AppConstants.appCreatedLabel}" } '
        'or fullText contains "${AppConstants.appCreatedLabel}")';

    final Map<String, dynamic> queryParams = <String, dynamic>{
      'q': query,
      'fields': NetworkConstants.sheetFields,
      'pageSize': NetworkConstants.pageSize,
      'orderBy': NetworkConstants.orderBy,
    };

    return apiClient.request<List<SheetModel>>(
      url: NetworkConstants.driveBaseUrl,
      method: HttpMethod.get,
      options: options,
      queryParameters: queryParams,
      responseParser: (final Map<String, dynamic> json) {
        final List<dynamic> files = json['files'] ?? <dynamic>[];
        return files
            .map(
              (final dynamic file) =>
                  SheetModel.fromJson(Map<String, dynamic>.from(file)),
            )
            .toList();
      },
    );
  }

  Future<Either<Failure, List<ScanResultModel>>> _readScansFromSheet(
    final String sheetId,
    final Options options,
  ) async {
    const String sheetRange =
        '${AppConstants.sheetName}!${AppConstants.readRange}';
    final String url =
        '${NetworkConstants.sheetsBaseUrl}/$sheetId/values/$sheetRange';

    return apiClient.request<List<ScanResultModel>>(
      url: url,
      method: HttpMethod.get,
      options: options,
      responseParser: (final Map<String, dynamic> json) {
        final List values = json['values'] ?? <dynamic>[];
        return _mapToScanResultModels(values);
      },
    );
  }

  List<ScanResultModel> _mapToScanResultModels(final List values) {
    return values
        .map(
          (final dynamic row) =>
              ScanResultModel.fromSheetRow(List<dynamic>.from(row)),
        )
        .toList();
  }

  @override
  Future<Either<Failure, List<PendingSyncEntity>>>
  getAllScansFromAllSheets() async {
    final Either<Failure, Options> authOptions = await _getAuthorizedOptions();

    return authOptions.fold(
      (final Failure failure) async =>
          Left<Failure, List<PendingSyncEntity>>(failure),
      (final Options options) async => _fetchAllScansFromSheets(options),
    );
  }

  Future<Either<Failure, List<PendingSyncEntity>>> _fetchAllScansFromSheets(
    final Options options,
  ) async {
    final Either<Failure, List<SheetModel>> sheetsResult =
        await _getOwnedSheets(options);

    return sheetsResult.fold(
      (final Failure failure) async =>
          Left<Failure, List<PendingSyncEntity>>(failure),
      (final List<SheetModel> sheets) async =>
          _collectScansFromAllSheets(sheets, options),
    );
  }

  Future<Either<Failure, List<PendingSyncEntity>>> _collectScansFromAllSheets(
    final List<SheetModel> sheets,
    final Options options,
  ) async {
    final List<PendingSyncEntity> allScans = <PendingSyncEntity>[];

    for (final SheetModel sheet in sheets) {
      final Either<Failure, List<ScanResultModel>> scansResult =
          await _readScansFromSheet(sheet.id, options);

      scansResult.fold(
        (final Failure _) {
          /// Continue even if one sheet fails
        },
        (final List<ScanResultModel> scans) {
          final List<PendingSyncEntity> sheetScans =
              _convertToPendingSyncEntities(scans, sheet);
          allScans.addAll(sheetScans);
        },
      );
    }

    _sortScansByTimestamp(allScans);

    return Right<Failure, List<PendingSyncEntity>>(allScans);
  }

  List<PendingSyncEntity> _convertToPendingSyncEntities(
    final List<ScanResultModel> scans,
    final SheetModel sheet,
  ) {
    return scans
        .map(
          (final ScanResultModel scan) => PendingSyncEntity(
            scan: scan.toEntity(),
            sheetId: sheet.id,
            sheetTitle: sheet.title,
          ),
        )
        .toList();
  }

  void _sortScansByTimestamp(final List<PendingSyncEntity> scans) {
    scans.sort(
      (final PendingSyncEntity a, final PendingSyncEntity b) =>
          b.scan.timestamp.compareTo(a.scan.timestamp),
    );
  }
}
