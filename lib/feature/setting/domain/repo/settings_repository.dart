import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';

abstract class SettingsRepository {
  /// Get currently signed-in user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Sign out user
  Future<Either<Failure, Unit>> signOut();
}
