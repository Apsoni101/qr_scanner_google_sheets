import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: context.appColors.appBarBackground,
      title: Text(
        title,
        style: AppTextStyles.airbnbCerealW600S20Lh28Ls0.copyWith(
          color: context.appColors.textPrimary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
