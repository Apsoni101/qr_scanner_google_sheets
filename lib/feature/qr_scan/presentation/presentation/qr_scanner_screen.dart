import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/extensions/color_extension.dart';
import 'package:qr_scanner_practice/core/extensions/localization_extension.dart';
import 'package:qr_scanner_practice/core/navigation/app_router.gr.dart';

@RoutePage()
class QrScanningScreen extends StatefulWidget {
  const QrScanningScreen({super.key});

  @override
  State<QrScanningScreen> createState() => _QrScanningScreenState();
}

class _QrScanningScreenState extends State<QrScanningScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final ValueNotifier<bool> _isFlashOn = ValueNotifier<bool>(false);

  bool _hasNavigated = false;

  @override
  void dispose() {
    _controller.dispose();
    _isFlashOn.dispose();
    super.dispose();
  }

  void _onQrDetected(final String code) {
    if (_hasNavigated) {
      return;
    }

    _hasNavigated = true;
    _controller.stop();

    context.router.push(QrResultRoute(qrData: code)).then((_) {
      if (mounted) {
        _hasNavigated = false;
        _controller.start();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: <Widget>[
          MobileScanner(
            controller: _controller,
            onDetect: (final BarcodeCapture capture) {
              final String? code = capture.barcodes.firstOrNull?.rawValue;
              if (code != null && code.isNotEmpty) {
                _onQrDetected(code);
              }
            },
          ),

          /// Scanner overlay (ONE widget, very fast)
          _ScannerOverlay(screenSize: screenSize),

          /// Instruction text
          Positioned(
            bottom: screenSize.height * 0.175,
            left: 0,
            right: 0,
            child: Center(child: _InstructionText()),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(final BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.close, color: context.appColors.white),
        onPressed: () => context.router.maybePop(),
      ),
      actions: <Widget>[
        _FlashToggleButton(controller: _controller, isFlashOn: _isFlashOn),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                FLASH BUTTON                                */
/* -------------------------------------------------------------------------- */

class _FlashToggleButton extends StatelessWidget {
  const _FlashToggleButton({required this.controller, required this.isFlashOn});

  final MobileScannerController controller;
  final ValueNotifier<bool> isFlashOn;

  @override
  Widget build(final BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isFlashOn,
      builder: (_, final bool flashOn, final __) {
        return IconButton(
          icon: Icon(
            flashOn ? Icons.flash_on : Icons.flash_off,
            color: context.appColors.white,
          ),
          onPressed: () async {
            await controller.toggleTorch();
            isFlashOn.value = !flashOn;
          },
        );
      },
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              SCANNER OVERLAY                                */
/* -------------------------------------------------------------------------- */

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay({required this.screenSize});

  final Size screenSize;

  @override
  Widget build(final BuildContext context) {
    final double frameSize = screenSize.width * 0.65;

    return CustomPaint(
      size: screenSize,
      painter: _ScannerOverlayPainter(
        frameSize: frameSize,
        overlayColor: Colors.black.withValues(alpha: 0.65),
        cornerColor: context.appColors.white,
        screenSize: screenSize,
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({
    required this.frameSize,
    required this.overlayColor,
    required this.cornerColor,
    required this.screenSize,
  });

  final double frameSize;
  final Color overlayColor;
  final Color cornerColor;
  final Size screenSize;

  late final double _cornerLength = frameSize * 0.108;
  late final double _strokeWidth = frameSize * 0.015;
  late final double _radius = frameSize * 0.046;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = size.center(Offset.zero);

    final Rect rect = Rect.fromCenter(
      center: center,
      width: frameSize,
      height: frameSize,
    );

    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(_radius));

    /// Dark overlay with transparent cut-out
    final Path overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, Paint()..color = overlayColor);

    /// Corner lines
    final Paint paint = Paint()
      ..color = cornerColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawCorner(final Offset start, final Offset h, final Offset v) {
      canvas
        ..drawLine(start, start + h, paint)
        ..drawLine(start, start + v, paint);
    }

    final double left = rect.left;
    final double right = rect.right;
    final double top = rect.top;
    final double bottom = rect.bottom;

    drawCorner(
      Offset(left, top),
      Offset(_cornerLength, 0),
      Offset(0, _cornerLength),
    );
    drawCorner(
      Offset(right, top),
      Offset(-_cornerLength, 0),
      Offset(0, _cornerLength),
    );
    drawCorner(
      Offset(left, bottom),
      Offset(_cornerLength, 0),
      Offset(0, -_cornerLength),
    );
    drawCorner(
      Offset(right, bottom),
      Offset(-_cornerLength, 0),
      Offset(0, -_cornerLength),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

/* -------------------------------------------------------------------------- */
/*                              INSTRUCTION TEXT                               */
/* -------------------------------------------------------------------------- */

class _InstructionText extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double horizontalPadding = screenSize.width * 0.064;
    final double verticalPadding = screenSize.height * 0.015;
    final double borderRadius = screenSize.width * 0.02;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),

        ///kept color hardcoded since it will always be permanent irrespective of theme
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        context.locale.pointCameraToScanQr,
        style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
          color: context.appColors.white,
        ),
      ),
    );
  }
}
