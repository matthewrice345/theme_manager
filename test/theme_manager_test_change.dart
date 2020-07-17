import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_manager/theme_manager.dart';

ValueKey<String> lightButtonKey = const ValueKey<String>('lightButtonKey');
ValueKey<String> darkButtonKey = const ValueKey<String>('darkButtonKey');
ValueKey<String> systemButtonKey = const ValueKey<String>('systemButtonKey');
GlobalKey<ThemeManagerState> themeManagerKey = GlobalKey<ThemeManagerState>();

void main() {
  testWidgets('change brightness', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    MaterialApp app = find.byType(MaterialApp).evaluate().first.widget;

    expect(app.theme.brightness, equals(Brightness.dark));

    await tester.tap(find.byKey(lightButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.theme.brightness, equals(Brightness.light));

    await tester.tap(find.byKey(darkButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.theme.brightness, equals(Brightness.dark));

    await tester.tap(find.byKey(systemButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    // system theme for tests is Brightness.Light
    expect(app.theme.brightness, equals(Brightness.light));

    await tester.tap(find.byKey(darkButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.theme.brightness, equals(Brightness.dark));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeManager(
        key: themeManagerKey,
        defaultBrightness: Brightness.dark,
        data: (Brightness brightness) {
          return ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueAccent,
            brightness: brightness,
          );
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return MaterialApp(
            title: 'Theme Manager Demo',
            theme: theme,
            home: ButtonPage(),
          );
        });
  }
}

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.light);
          },
          key: lightButtonKey,
        ),
        RaisedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.dark);
          },
          key: darkButtonKey,
        ),
        RaisedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightnessPreference(BrightnessPreference.system);
          },
          key: systemButtonKey,
        ),
      ],
    );
  }
}
