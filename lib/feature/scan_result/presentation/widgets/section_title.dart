import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(final BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
        color: context.appColors.textPrimary.withValues(alpha: 0.8),
      ),
    );
  }
}
