import 'package:flutter_test/flutter_test.dart';

import 'package:theme_manager/theme_manager.dart';

import 'package:flutter/material.dart';

ValueKey<String> key = const ValueKey<String>('themeManagerKey');
ThemeManagerState state;
GlobalKey<ThemeManagerState> themeManagerKey = GlobalKey<ThemeManagerState>();

void main() {
  testWidgets('test finds state', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(state, equals(null));

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(state, isNotNull);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeManager(
        key: themeManagerKey,
        defaultBrightnessPreference: BrightnessPreference.light,
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
            home: MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        state = ThemeManager.of(context);
      },
      key: key,
    );
  }
}
