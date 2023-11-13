import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';

class Preferences {
  static const String _sharedPreferencesKey = 'brightnessPreference';

  static Future<BrightnessPreference> getBrightness(
      BrightnessPreference initialPreference) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_sharedPreferencesKey) == false) {
      await saveBrightness(initialPreference);
      return initialPreference;
    }

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

  /// Saves the provided brightness in `SharedPreferences`
  static Future<void> saveBrightness(BrightnessPreference preference) async {
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

  /// Clears the `BrightnessPreference`
  static Future<void> clearBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sharedPreferencesKey);
  }
}
