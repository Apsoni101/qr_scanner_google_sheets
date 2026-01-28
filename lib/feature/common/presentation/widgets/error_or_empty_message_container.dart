import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';

class ErrorOrEmptyMessageContainer extends StatelessWidget {
  const ErrorOrEmptyMessageContainer({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });

  final String message;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
