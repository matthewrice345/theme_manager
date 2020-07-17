import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({Key key, this.onSelectedTheme})
      : super(key: key);

  final ValueChanged<BrightnessPreference> onSelectedTheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.accentColor,
          value: BrightnessPreference.system,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (BrightnessPreference value) {
            onSelectedTheme(BrightnessPreference.system);
          },
          title: const Text('System'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.accentColor,
          value: BrightnessPreference.light,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (BrightnessPreference value) {
            onSelectedTheme(BrightnessPreference.light);
          },
          title: const Text('Light'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.accentColor,
          value: BrightnessPreference.dark,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (BrightnessPreference value) {
            onSelectedTheme(BrightnessPreference.dark);
          },
          title: const Text('Dark'),
        ),
      ],
    );
  }
}
