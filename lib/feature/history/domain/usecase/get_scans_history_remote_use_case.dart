import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/history/domain/repo/scans_history_remote_repository.dart';
import 'package:qr_scanner_practice/feature/result_scan/domain/entity/pending_sync_entity.dart';

class GetScansHistoryRemoteUseCase {
  const GetScansHistoryRemoteUseCase({required this.repository});

  final ScansHistoryRemoteRepository repository;

  Future<Either<Failure, List<PendingSyncEntity>>> getAllScansFromAllSheets() =>
      repository.getAllScansFromAllSheets();
}
