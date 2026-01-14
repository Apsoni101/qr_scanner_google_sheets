import 'package:auto_route/auto_route.dart';
import 'package:qr_scanner_practice/core/di/app_injector.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';
import 'package:qr_scanner_practice/core/navigation/auth_guard.dart';
import 'package:qr_scanner_practice/core/navigation/route_paths.dart';
import 'package:qr_scanner_practice/core/navigation/router/auth_router.dart';
import 'package:qr_scanner_practice/core/navigation/router/dashboard_router.dart';


@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard = AppInjector.getIt<AuthGuard>();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
    AutoRoute(page: SplashRoute.page, path: RoutePaths.splash, initial: true),
    authRoute,
    dashboardRoute(authGuard),
  ];
}
