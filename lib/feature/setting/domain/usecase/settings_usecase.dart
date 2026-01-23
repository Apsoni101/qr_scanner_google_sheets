import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/setting/domain/repo/settings_repository.dart';

class SettingsUseCase {
  SettingsUseCase({required this.repository});

  final SettingsRepository repository;

  Future<Either<Failure, UserEntity>> getCurrentUser() =>
      repository.getCurrentUser();

  Future<Either<Failure, Unit>> signOut() => repository.signOut();
}
