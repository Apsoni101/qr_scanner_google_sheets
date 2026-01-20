import 'package:dartz/dartz.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';
import 'package:qr_scanner_practice/feature/auth/domain/repositories/auth_remote_repo.dart';

/// Use case for remote authentication operations
class AuthRemoteUseCase {
  /// Creates an instance of AuthRemoteUseCase
  AuthRemoteUseCase({required this.authRemoteRepo});

  /// Remote authentication repository
  final AuthRemoteRepo authRemoteRepo;

  /// Signs in the user using Google authentication
  Future<Either<Failure, UserEntity>> signInWithGoogle() =>
      authRemoteRepo.signInWithGoogle();

  /// Signs out the currently authenticated user
  Future<Either<Failure, Unit>> signOut() => authRemoteRepo.signOut();

  /// Checks if user is signed in with remote service
  bool isSignedIn() => authRemoteRepo.isSignedIn();
}
