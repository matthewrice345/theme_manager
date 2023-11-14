import 'package:flutter_test/flutter_test.dart';

import 'package:theme_manager/theme_manager.dart';

import 'package:flutter/material.dart';

ValueKey<String> key = const ValueKey<String>('themeManagerKey');
ThemeManagerState? state;
GlobalKey<ThemeManagerState> themeManagerKey = GlobalKey<ThemeManagerState>();

void main() {
  testWidgets('test finds state', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(state, equals(null));

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(state, isNotNull);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      key: themeManagerKey,
      defaultBrightnessPreference: BrightnessPreference.light,
      data: (Brightness brightness) {
        return ThemeData(
          primarySwatch: Colors.blue,
          brightness: brightness,
        );
      },
      themedBuilder: (BuildContext context, ThemeState data) {
        return MaterialApp(
          title: 'Theme Manager Demo',
          theme: data.themeData,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        state = ThemeManager.of(context);
      },
      key: key,
      child: const Text(''),
    );
  }
}
