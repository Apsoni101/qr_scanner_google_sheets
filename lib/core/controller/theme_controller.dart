import 'package:flutter/material.dart';
import 'package:qr_scanner_practice/core/services/storage/hive_key_constants.dart';
import 'package:qr_scanner_practice/core/services/storage/hive_service.dart';



class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._hiveService) : super(ThemeMode.system);

  final HiveService _hiveService;

  /// Load theme from Hive
  Future<void> initialize() async {
    final String? modeName = _hiveService.getString(HiveKeyConstants.themeMode);

    if (modeName != null) {
      value = ThemeMode.values.byName(modeName);
    } else {
      value = ThemeMode.system;
    }
  }

  /// Save theme to Hive
  Future<void> setTheme(final ThemeMode theme) async {
    value = theme;
    await _hiveService.setString(HiveKeyConstants.themeMode, theme.name);
  }

  /// Switch between light and dark
  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
  }
}
