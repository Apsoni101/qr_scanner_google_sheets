import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_scanner_practice/core/services/firebase/firebase_auth_service.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';
import 'package:qr_scanner_practice/feature/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signUpWithEmailAndData(
    final String email,
    final String password,
    final String name,
    final String surname,
    final String birthdate,
  );

  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  );

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserModel>> signInWithGoogle();

  bool isSignedIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.authService});

  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailAndData(
    final String email,
    final String password,
    final String name,
    final String surname,
    final String birthdate,
  ) async {
    final Either<Failure, User> authResult = await authService.signUpWithEmail(
      email,
      password,
    );

    return authResult.fold(Left.new, (final User user) {
      final UserModel userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        surname: surname,
        birthdate: birthdate,
        isNewUser: true,
      );

      return Right<Failure, UserModel>(userModel);
    });
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  ) async {
    final Either<Failure, User> result = await authService.signInWithEmail(
      email,
      password,
    );

    return result.fold(Left.new, (final User user) {
      try {
        final UserModel userModel = UserModel.fromFirebaseUser(user);
        return Right<Failure, UserModel>(userModel);
      } catch (e) {
        return Left<Failure, UserModel>(
          Failure(message: 'Failed to parse Firebase user: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    final Either<Failure, User> result = await authService.signInWithGoogle();

    return result.fold(
      (final Failure failure) {
        return Left<Failure, UserModel>(failure);
      },
      (final User user) {
        try {
          final UserModel userModel = UserModel.fromFirebaseUser(
            user,
          ).copyWith(isNewUser: true);
          return Right<Failure, UserModel>(userModel);
        } catch (e) {
          return Left<Failure, UserModel>(
            Failure(message: 'Failed to parse Firebase user: $e'),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> signOut() => authService.signOut();

  @override
  bool isSignedIn() => authService.auth.currentUser != null;
}
