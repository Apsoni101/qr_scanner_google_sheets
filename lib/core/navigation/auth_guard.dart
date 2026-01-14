import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';
import 'package:qr_scanner_practice/core/services/firebase/firebase_auth_service.dart';
import 'package:qr_scanner_practice/core/services/network/failure.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.firebaseAuthService});

  final FirebaseAuthService firebaseAuthService;

  @override
  Future<void> onNavigation(
      final NavigationResolver resolver,
      final StackRouter router,
      ) async {
    debugPrint('🔐 AuthGuard: Navigation check started');
    debugPrint('📍 Target route: ${resolver.route.name}');

    final Either<Failure, bool> isSignedInResult =
    await firebaseAuthService.isSignedIn();

    await isSignedInResult.fold(
          (final Failure failure) async {
        debugPrint('❌ AuthGuard: Error checking sign-in status');
        debugPrint('🚨 Error message: ${failure.message}');
        debugPrint('🔄 Redirecting to SignInRoute');
        router.replace(SignInRoute());
      },
          (final bool isSignedIn) async {
        if (isSignedIn) {
          debugPrint('✅ AuthGuard: User is signed in');
          debugPrint('➡️ Allowing navigation to ${resolver.route.name}');
          resolver.next();
        } else {
          debugPrint('⚠️ AuthGuard: User is NOT signed in');
          debugPrint('🔄 Redirecting to SignInRoute');
          router.replace(SignInRoute());
        }
      },
    );

    debugPrint('🏁 AuthGuard: Navigation check completed\n');
  }
}