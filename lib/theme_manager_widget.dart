import 'dart:async';

import 'package:flutter/material.dart';
import 'package:theme_manager/enums.dart';
import 'package:theme_manager/preferences.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(
    Brightness brightness);

class ThemeManager extends StatefulWidget {
  const ThemeManager({
    super.key,
    required this.data,
    required this.themedWidgetBuilder,
    this.defaultBrightnessPreference = BrightnessPreference.system,
  });

  /// Builder that gets called when the brightness or theme changes
  final ThemedWidgetBuilder themedWidgetBuilder;

  /// Callback that returns the latest brightness
  final ThemeDataWithBrightnessBuilder data;

  /// The default brightness preference on start
  ///
  /// Defaults to `BrightnessPreference.system`
  final BrightnessPreference defaultBrightnessPreference;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ThemeManager>>()
        as ThemeManagerState;
  }
}

class ThemeManagerState extends State<ThemeManager> {
  /// Get the current `ThemeData`
  ThemeData get themeData => _themeData;
  late ThemeData _themeData;

  /// Get the current `BrightnessPreference`
  BrightnessPreference get brightnessPreference => _brightnessSharedPreference;
  late BrightnessPreference _brightnessSharedPreference;

  @override
  void initState() {
    super.initState();
    _brightnessSharedPreference = widget.defaultBrightnessPreference;
    _themeData = widget.data(_brightnessSharedPreference.brightness(context));
    _initVariables();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = _brightnessSharedPreference.brightness(context);
    _themeData = widget.data(brightness);
  }

  @override
  void didUpdateWidget(ThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final brightness = _brightnessSharedPreference.brightness(context);
    _themeData = widget.data(brightness);
  }

  /// Initializes the variables
  /// Loads the brightness depending on the `loadBrightnessOnStart` value
  Future<void> _initVariables() async {
    setThemeData(widget.data(_brightnessSharedPreference.brightness(context)));
    _brightnessSharedPreference =
        await Preferences.getBrightness(widget.defaultBrightnessPreference);
  }

  /// Toggles the brightness from dark to light
  Future<void> setBrightness(BrightnessPreference brightnessPreference) async {
    _brightnessSharedPreference = brightnessPreference;
    final brightness = _brightnessSharedPreference.brightness(context);
    setThemeData(widget.data(brightness));
    await Preferences.saveBrightness(brightnessPreference);
  }

  /// Gets the stored shared preference for the brightness preference
  Future<BrightnessPreference> getBrightness() {
    return Preferences.getBrightness(brightnessPreference);
  }

  /// Clears the stored shared preference for the brightness preference
  Future<void> clearBrightnessPreference() async {
    await Preferences.clearBrightness();
    _brightnessSharedPreference = widget.defaultBrightnessPreference;
    // ignore: use_build_context_synchronously
    final brightness = _brightnessSharedPreference.brightness(context);
    setThemeData(widget.data(brightness));
  }

  /// Changes the theme using the provided `ThemeData`
  void setThemeData(ThemeData data) {
    _themeData = data;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _themeData);
  }
}
