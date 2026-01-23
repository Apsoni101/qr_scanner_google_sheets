import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';

class RoundedCornerElevatedCard extends StatelessWidget {
  const RoundedCornerElevatedCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: context.appColors.cardBackground,
      elevation: 1,
      child: child,
    );
  }
}
