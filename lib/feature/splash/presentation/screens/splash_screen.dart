import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/extensions/color_extension.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await context.router.replaceAll(<PageRouteInfo<Object?>>[
          const DashboardRouter(),
        ]);
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Stack(
    children: <Widget>[
      Positioned.fill(child: ColoredBox(color: context.appColors.white)),
      Align(
        child: Icon(
          Icons.qr_code_scanner,
          size: 120,
          color: context.appColors.primaryBlue,
        ),
      ),
    ],
  );
}
