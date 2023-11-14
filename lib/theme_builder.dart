import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager_widget.dart';
import 'package:theme_manager/theme_state.dart';

typedef ThemeBuilderWidget = Widget Function(
    BuildContext context, ThemeState state);

/// A widget that rebuilds when the theme changes. Sometimes you need to rebuild
/// part of the widget tree that may not get updated via the [ThemeManagerWidget].
/// While the theme is changed correctly places such as a [Builder] widget may not
/// get updated. This widget will rebuild when the theme changes.
///
/// This widget its not meant to wrap the [MaterialApp].
class ThemeBuilder extends StatelessWidget {
  const ThemeBuilder({super.key, required this.builder});
  final ThemeBuilderWidget builder;

  @override
  Widget build(BuildContext context) {
    final notifier = ThemeManager.of(context).themeStateNotifier;

    return ValueListenableBuilder<ThemeState>(
      builder: (BuildContext context, ThemeState value, Widget? child) {
        return builder(context, value);
      },
      valueListenable: notifier,
    );
  }
}
