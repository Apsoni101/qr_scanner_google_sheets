import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/auth/domain/repositories/auth_remote_repo.dart';

/// Remote repository implementation for authentication operations
class AuthRemoteRepoImpl implements AuthRemoteRepo {
  /// Creates an instance of AuthRemoteRepoImpl
  AuthRemoteRepoImpl({required this.authRemoteDataSource});

  /// Remote data source for performing authentication operations
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() =>
      authRemoteDataSource.signInWithGoogle();

  @override
  Future<Either<Failure, Unit>> signOut() => authRemoteDataSource.signOut();

  @override
  bool isSignedIn() => authRemoteDataSource.isSignedIn();
}
