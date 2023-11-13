import 'package:flutter/material.dart';
import 'package:theme_manager/enums.dart';
import 'package:theme_manager/theme_manager_widget.dart';

typedef OnThemeSelected = void Function(BrightnessPreference preference);

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({super.key, required this.onThemeSelected});

  static Future<void> show(
      BuildContext context, OnThemeSelected onThemeSelected) {
    return showDialog<void>(
        context: context,
        builder: (context) => ThemePickerDialog(
              onThemeSelected: onThemeSelected,
            ));
  }

  final OnThemeSelected onThemeSelected;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.primaryColor,
          value: BrightnessPreference.system,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (_) {
            onThemeSelected.call(BrightnessPreference.system);
          },
          title: const Text('System'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.primaryColor,
          value: BrightnessPreference.light,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (_) {
            onThemeSelected.call(BrightnessPreference.light);
          },
          title: const Text('Light'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.primaryColor,
          value: BrightnessPreference.dark,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (_) {
            onThemeSelected.call(BrightnessPreference.dark);
          },
          title: const Text('Dark'),
        ),
      ],
    );
  }
}
