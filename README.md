# theme_manager
## A theme manager for light, dark, and system themes.

![](https://github.com/matthewrice345/theme_manager/blob/master/assets/screen.gif)

A theme manager that supports light, dark, and system default themes. State is retained and applied upon application start. Heavily inspired by dynamic_theme by Norbert Kozsir.

## Getting Started

Add `theme_manager` to your project.
```
  dependencies:
    theme_manager: ^1.1.1
```

run `flutter packages get` and import `theme_manager`
```dart
import 'package:theme_manager/theme_manager.dart';
```

A dialog is provided that can switch between themes. 
```dart
import 'package:theme_manager/change_theme_widget.dart';
```

## How to use

Make sure `WidgetsFlutterBinding` are initialized. This is required.

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  runApp(MyApp());
}
```

Wrap your `MaterialApp` with `ThemeManager`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      defaultBrightnessPreference: BrightnessPreference.system,
      data: (Brightness brightness) => ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
        brightness: brightness,
      ),
      loadBrightnessOnStart: true,
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return MaterialApp(
          title: 'Theme Manager Demo',
          theme: theme,
          home: MyHomePage(),
        );
      },
    );
  }
}
```

When you want to change your theme:

```dart
void setAsSystemDefault() => 
  ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.system);
void setAsLight() => 
  ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.light);
void setAsDark() => 
  ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.dark);
```

The system default will load either light or dark based on the device preferences. If your device
changes themes at sunset or sunrise then light/dark mode will apply automatically. 

The `BrightnessPreference` is saved in SharedPreferences automatically. There is also a clear
function to remove the preferences. 
```dart
void clear() => ThemeManager.of(context).clearBrightnessPreference();
```

### A dialog widget to change the brightness!
![](https://github.com/matthewrice345/theme_manager/blob/master/assets/dialog.png)

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
