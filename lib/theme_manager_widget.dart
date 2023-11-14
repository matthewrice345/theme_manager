import 'dart:async';

import 'package:flutter/material.dart';
import 'package:theme_manager/enums.dart';
import 'package:theme_manager/preferences.dart';
import 'package:theme_manager/theme_state.dart';

typedef ThemedBuilder = Widget Function(BuildContext context, ThemeState state);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(Brightness brightness);

class ThemeManager extends StatefulWidget {
  const ThemeManager({
    super.key,
    required this.data,
    required this.themedBuilder,
    this.defaultBrightnessPreference = BrightnessPreference.system,
  });

  /// Builder that gets called when the brightness or theme changes
  final ThemedBuilder themedBuilder;

  /// Callback that returns the updated theme brightness
  final ThemeDataWithBrightnessBuilder data;

  /// The default brightness preference on start
  /// Defaults to `BrightnessPreference.system` when not set.
  final BrightnessPreference defaultBrightnessPreference;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ThemeManager>>() as ThemeManagerState;
  }
}

class ThemeManagerState extends State<ThemeManager> with WidgetsBindingObserver {
  /// Get the current `ThemeData`
  ThemeState get state => _state;
  late ThemeState _state;

  ValueNotifier<ThemeState> get themeStateNotifier => _themeStateNotifier;
  late ValueNotifier<ThemeState> _themeStateNotifier;

  @override
  void initState() {
    super.initState();
    _state = ThemeState(
      widget.data(widget.defaultBrightnessPreference.brightness(context)),
      widget.defaultBrightnessPreference,
    );
    _themeStateNotifier = ValueNotifier<ThemeState>(state);
    _loadBrightness();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state = ThemeState(
      widget.data(state.brightnessPreference.brightness(context)),
      state.brightnessPreference,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(ThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _state = ThemeState(
      widget.data(state.brightnessPreference.brightness(context)),
      state.brightnessPreference,
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _loadBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Initializes the variables
  Future<void> _loadBrightness() async {
    final brightnessPreference = await Preferences.getBrightness(widget.defaultBrightnessPreference);
    setThemeData(brightnessPreference);
  }

  /// Sets the [BrightnessPreference] and saves it to shared preferences
  Future<void> setBrightness(BrightnessPreference brightnessPreference) async {
    await Preferences.saveBrightness(brightnessPreference);
    setThemeData(brightnessPreference);
  }

  /// Gets the stored shared preference for the brightness preference
  Future<BrightnessPreference> getBrightness() {
    return Preferences.getBrightness(state.brightnessPreference);
  }

  /// Clears the stored shared preference for the brightness preference
  Future<void> clearBrightnessPreference() async {
    await Preferences.clearBrightness();
    setThemeData(widget.defaultBrightnessPreference);
  }

  /// Changes the theme using the provided `ThemeData`
  void setThemeData(BrightnessPreference brightnessPreference) {
    final brightness = brightnessPreference.brightness(context);
    _state = ThemeState(widget.data.call(brightness), brightnessPreference);
    if (mounted) {
      setState(() {});
    }
    _themeStateNotifier.value = state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedBuilder(context, state);
  }
}
