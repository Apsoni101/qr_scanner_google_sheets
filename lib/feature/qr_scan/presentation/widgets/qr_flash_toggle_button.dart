import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_practice/core/constants/asset_constants.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';
import 'package:qr_scanner_practice/feature/qr_scan/presentation/bloc/qr_scanning_bloc/qr_scanning_bloc.dart';

class QrFlashToggleButton extends StatelessWidget {
  const QrFlashToggleButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<QrScanningBloc, QrScanningState, bool>(
      selector: (final QrScanningState state) => state.isFlashOn,
      builder: (final BuildContext context, final bool isFlashOn) {
        return IconButton(
          icon: isFlashOn
              ? SvgPicture.asset(
                  AppAssets.flashLightOnIc,
                  colorFilter: ColorFilter.mode(
                    context.appColors.surfaceL1,
                    BlendMode.srcIn,
                  ),
                )
              : SvgPicture.asset(
                  AppAssets.flashLightOffIc,
                  colorFilter: ColorFilter.mode(
                    context.appColors.surfaceL1,
                    BlendMode.srcIn,
                  ),
                ),
          style: IconButton.styleFrom(
            backgroundColor: isFlashOn
                ? context.appColors.primaryDefault
                : context.appColors.cameraOverlay,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            context.read<QrScanningBloc>().add(const ToggleFlashEvent());
            controller.toggleTorch();
          },
        );
      },
    );
  }
}
