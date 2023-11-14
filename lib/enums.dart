import 'package:flutter/material.dart';

enum BrightnessPreference {
  system,
  light,
  dark;

  Brightness brightness(BuildContext context) {
    switch (this) {
      case BrightnessPreference.dark:
        return Brightness.dark;
      case BrightnessPreference.light:
        return Brightness.light;
      default:
        try {
          return View.of(context).platformDispatcher.platformBrightness;
        } catch (e) {
          debugPrint("Failed to load the brightness $e");
          // ignore: deprecated_member_use
          return WidgetsBinding.instance.window.platformBrightness;
        }
    }
  }

  bool get isSystem => this == BrightnessPreference.system;
  bool get isDark => this == BrightnessPreference.dark;
  bool get isLight => this == BrightnessPreference.light;
}
