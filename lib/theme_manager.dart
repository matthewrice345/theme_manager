library theme_manager;

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData data);

typedef ThemeDataWithBrightnessBuilder = ThemeData Function(
    Brightness brightness);

class ThemeManager extends StatefulWidget {
  const ThemeManager({
    Key key,
    this.data,
    this.themedWidgetBuilder,
    this.defaultBrightness = Brightness.light,
    this.loadBrightnessOnStart = true,
  }) : super(key: key);

  /// Builder that gets called when the brightness or theme changes
  final ThemedWidgetBuilder themedWidgetBuilder;

  /// Callback that returns the latest brightness
  final ThemeDataWithBrightnessBuilder data;

  /// The default brightness on start
  ///
  /// Defaults to `Brightness.light`
  final Brightness defaultBrightness;

  /// Whether or not to load the brightness on start
  ///
  /// Defaults to `true`
  final bool loadBrightnessOnStart;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ThemeManager>>();
  }
}

class ThemeManagerState extends State<ThemeManager> {
  bool _shouldLoadBrightness;

  static const String _sharedPreferencesKey = 'brightnessPreference';

  /// Get the current `ThemeData`
  ThemeData get themeData => _themeData;
  ThemeData _themeData;

  /// Get the current `Brightness`
  Brightness get brightness => _brightness;
  Brightness _brightness;

  /// Get the current `BrightnessPreference`
  BrightnessPreference get brightnessPreference => _brightnessPreference;
  BrightnessPreference _brightnessPreference;

  @override
  void initState() {
    super.initState();
    _initVariables();
    _loadBrightness();
  }

  /// Loads the brightness depending on the `loadBrightnessOnStart` value
  Future<void> _loadBrightness() async {
    if (!_shouldLoadBrightness) {
      return;
    }
    _brightnessPreference = await _getBrightnessPreference();
    if (brightnessPreference == BrightnessPreference.dark) {
      _brightness = Brightness.dark;
    } else if (brightnessPreference == BrightnessPreference.light) {
      _brightness = Brightness.light;
    } else {
      _brightness = WidgetsBinding.instance.window.platformBrightness;
    }
    _themeData = widget.data(_brightness);
    if (mounted) {
      setState(() {});
    }
  }

  /// Initializes the variables
  void _initVariables() {
    _brightnessPreference = BrightnessPreference.system;
    _brightness = widget.defaultBrightness;
    _themeData = widget.data(_brightness);
    _shouldLoadBrightness = widget.loadBrightnessOnStart;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(_brightness);
  }

  @override
  void didUpdateWidget(ThemeManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(_brightness);
  }

  /// Sets the new brightness
  /// Rebuilds the tree
  Future<void> _setBrightness(
      Brightness brightness, BrightnessPreference preference) async {
    // Update state with new values
    setState(() {
      _themeData = widget.data(brightness);
      _brightness = brightness;
      _brightnessPreference = preference;
    });
  }

  /// Toggles the brightness from dark to light
  Future<void> setBrightnessPreference(BrightnessPreference preference) async {
    switch (preference) {
      case BrightnessPreference.light:
        await _setBrightness(Brightness.light, preference);
        break;
      case BrightnessPreference.dark:
        await _setBrightness(Brightness.dark, preference);
        break;
      default:
        await _setBrightness(
            WidgetsBinding.instance.window.platformBrightness, preference);
        break;
    }

    // Save the brightness preference
    await _saveBrightness(preference);
  }

  /// Changes the theme using the provided `ThemeData`
  void setThemeData(ThemeData data) {
    setState(() {
      _themeData = data;
    });
  }

  /// Saves the provided brightness in `SharedPreferences`
  Future<void> _saveBrightness(BrightnessPreference preference) async {
    /// Doesn't save the brightness if you don't want to load it
    if (!_shouldLoadBrightness) {
      return;
    }
    int saveState = 0;
    switch (preference) {
      case BrightnessPreference.light:
        saveState = 1;
        break;
      case BrightnessPreference.dark:
        saveState = 2;
        break;
      default:
        saveState = 0;
        break;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sharedPreferencesKey, saveState);
  }

  /// Returns the `BrightnessPreference`
  Future<BrightnessPreference> _getBrightnessPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Gets the bool stored in prefs
    // Or returns whether or not the `defaultBrightness` is dark
    final int savedState = prefs.getInt(_sharedPreferencesKey) ?? 0;
    switch (savedState) {
      case 1:
        return BrightnessPreference.light;
      case 2:
        return BrightnessPreference.dark;
      default:
        return BrightnessPreference.system;
    }
  }

  /// Clears the `BrightnessPreference`
  Future<void> clearBrightnessPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sharedPreferencesKey);
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _themeData);
  }
}

enum BrightnessPreference { system, light, dark }
