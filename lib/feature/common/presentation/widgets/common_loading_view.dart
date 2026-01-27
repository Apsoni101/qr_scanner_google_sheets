import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/constants/asset_constants.dart';

class CommonLoadingView extends StatelessWidget {
  const CommonLoadingView({super.key});

  @override
  Widget build(final BuildContext context) {
    return Center(child: Image.asset(AppAssets.codeIsArtLoading));
  }
}
