import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_scanner_practice/core/constants/app_textstyles.dart';
import 'package:qr_scanner_practice/core/extensions/context_extensions.dart';

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    required this.title,
    required this.iconAsset,
    required this.onPressed,
    this.trailingTitle,
    super.key,
    this.trailing,
  });

  final String title;
  final String? trailingTitle;
  final String iconAsset;
  final Widget? trailing;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      title: Text(
        title,
        style: AppTextStyles.airbnbCerealW500S16Lh24Ls0.copyWith(
          color: context.appColors.textPrimary,
        ),
      ),
      leading: Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.appColors.surfaceL3,
        ),
        child: SvgPicture.asset(
          iconAsset,
          colorFilter: ColorFilter.mode(
            context.appColors.primaryDefault,
            BlendMode.srcIn,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (trailingTitle != null)
            Text(
              trailingTitle ?? '',
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          if (trailing != null) ...<Widget>[?trailing],
        ],
      ),
    );
  }
}
