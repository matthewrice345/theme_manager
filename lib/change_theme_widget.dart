import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({Key? key, required this.onSelectedTheme})
      : super(key: key);

  final ValueChanged<BrightnessPreference> onSelectedTheme;

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
            onSelectedTheme.call(BrightnessPreference.system);
          },
          title: const Text('System'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.primaryColor,
          value: BrightnessPreference.light,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (_) {
            onSelectedTheme.call(BrightnessPreference.light);
          },
          title: const Text('Light'),
        ),
        RadioListTile<BrightnessPreference>(
          activeColor: ThemeManager.of(context).themeData.primaryColor,
          value: BrightnessPreference.dark,
          groupValue: ThemeManager.of(context).brightnessPreference,
          onChanged: (_) {
            onSelectedTheme.call(BrightnessPreference.dark);
          },
          title: const Text('Dark'),
        ),
      ],
    );
  }
}
