import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';

class QrScanInstructionText extends StatelessWidget {
  const QrScanInstructionText({super.key});

  @override
  Widget build(final BuildContext context) {
    return Text(
      context.locale.pointYourCameraAtAQrCode,
      style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
        color: context.appColors.textInversePrimary,
      ),
    );
  }
}
