import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_manager/theme_manager.dart';

ValueKey<String> lightButtonKey = const ValueKey<String>('lightButtonKey');
ValueKey<String> darkButtonKey = const ValueKey<String>('darkButtonKey');
ValueKey<String> systemButtonKey = const ValueKey<String>('systemButtonKey');
GlobalKey<ThemeManagerState> themeManagerKey = GlobalKey<ThemeManagerState>();

void main() {
  testWidgets('change brightness', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    MaterialApp app =
        find.byType(MaterialApp).evaluate().first.widget as MaterialApp;

    expect(app.theme?.brightness, equals(Brightness.dark));

    await tester.tap(find.byKey(lightButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
    expect(app.theme?.brightness, equals(Brightness.light));

    await tester.tap(find.byKey(darkButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
    expect(app.theme?.brightness, equals(Brightness.dark));

    await tester.tap(find.byKey(systemButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
    // system theme for tests is Brightness.Light
    expect(app.theme?.brightness, equals(Brightness.light));

    await tester.tap(find.byKey(darkButtonKey));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
    expect(app.theme?.brightness, equals(Brightness.dark));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
        key: themeManagerKey,
        defaultBrightnessPreference: BrightnessPreference.dark,
        data: (Brightness brightness) {
          return ThemeData(
            primarySwatch: Colors.blue,
            brightness: brightness,
          );
        },
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return MaterialApp(
            title: 'Theme Manager Demo',
            theme: theme,
            home: const ButtonPage(),
          );
        });
  }
}

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightness(BrightnessPreference.light);
          },
          key: lightButtonKey,
          child: const Text('Light'),
        ),
        ElevatedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightness(BrightnessPreference.dark);
          },
          key: darkButtonKey,
          child: const Text('Dark'),
        ),
        ElevatedButton(
          onPressed: () {
            ThemeManager.of(context).setBrightness(BrightnessPreference.system);
          },
          key: systemButtonKey,
          child: const Text('System'),
        ),
      ],
    );
  }
}
