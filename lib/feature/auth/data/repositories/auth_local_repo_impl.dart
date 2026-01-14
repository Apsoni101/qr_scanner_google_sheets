import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/feature/auth/data/data_sources/auth_local_data_source.dart';
import 'package:qr_scanner_practice/feature/auth/data/models/user_model.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/auth/domain/repositories/auth_local_repo.dart';


class AuthLocalRepoImpl implements AuthLocalRepo {
  AuthLocalRepoImpl({required this.authLocalDataSource});

  final AuthLocalDataSource authLocalDataSource;

  @override
  Future<Unit> saveUserCredentials(UserEntity user) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email,
      name: user.name,
      surname: user.surname,
      birthdate: user.birthdate,
    );

    return authLocalDataSource.saveUserCredentials(userModel);
  }

  @override
  UserEntity? getSavedUserCredentials() {
    final userModel = authLocalDataSource.getSavedUserCredentials();
    return userModel;
  }

  @override
  Future<Unit> removeSavedUserCredentials() {
    return authLocalDataSource.removeSavedUserCredentials();
  }

  @override
  Future<Unit> clearUserData() {
    return authLocalDataSource.clearUserData();
  }

  @override
  UserEntity? getCurrentUser() {
    return authLocalDataSource.getSavedUserCredentials();
  }
}
