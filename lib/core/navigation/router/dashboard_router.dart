import 'package:auto_route/auto_route.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';
import 'package:qr_scanner_practice/core/navigation/auth_guard.dart';
import 'package:qr_scanner_practice/core/navigation/routes/dashboard_tab_routes.dart';


@RoutePage(name: 'DashboardRouter')
class DashboardRouterPage extends AutoRouter {
  const DashboardRouterPage({super.key});
}

AutoRoute dashboardRoute(final AuthGuard authGuard) => AutoRoute(
  page: DashboardRouter.page,
  guards: <AutoRouteGuard>[authGuard],
  children: <AutoRoute>[...dashboardTabRoutes,],
);
