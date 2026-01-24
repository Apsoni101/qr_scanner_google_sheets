import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/local_storage/hive_key_constants.dart';
import 'package:qr_scanner_practice/core/local_storage/hive_service.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/sheet_selection/data/model/pending_sync_model.dart';

abstract class HomeScreenLocalDataSource {
  Future<Either<Failure, List<PendingSyncModel>>> getPendingSyncs();

  Future<Either<Failure, Unit>> removePendingSync(final int index);
}

class HomeScreenLocalDataSourceImpl implements HomeScreenLocalDataSource {
  HomeScreenLocalDataSourceImpl({required this.hiveService});

  final HiveService hiveService;

  @override
  Future<Either<Failure, List<PendingSyncModel>>> getPendingSyncs() async {
    try {
      final List<PendingSyncModel>? pendingSyncs = hiveService
          .getObjectList<PendingSyncModel>(HiveKeyConstants.pendingSyncs);
      return Right<Failure, List<PendingSyncModel>>(
        pendingSyncs ?? <PendingSyncModel>[],
      );
    } catch (e) {
      return Left<Failure, List<PendingSyncModel>>(
        Failure(message: 'Failed to fetch pending syncs: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> removePendingSync(final int index) async {
    try {
      final List<PendingSyncModel>? pendingSyncs = hiveService
          .getObjectList<PendingSyncModel>(HiveKeyConstants.pendingSyncs);

      if (pendingSyncs != null && index < pendingSyncs.length) {
        pendingSyncs.removeAt(index);
        await hiveService.setObjectList(
          HiveKeyConstants.pendingSyncs,
          pendingSyncs,
        );
      }

      return const Right<Failure, Unit>(unit);
    } catch (e) {
      return Left<Failure, Unit>(
        Failure(message: 'Failed to remove pending sync: $e'),
      );
    }
  }
}
