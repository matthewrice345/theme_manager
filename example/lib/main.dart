import 'package:flutter/material.dart';
import 'package:theme_manager/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      /// WidgetsBinding.instance.window.platformBrightness is used because a
      /// Material BuildContext will not be available outside of the Material app
      defaultBrightnessPreference: BrightnessPreference.light,
      data: (Brightness brightness) => ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
      ),
      themedBuilder: (BuildContext context, ThemeState state) {
        return MaterialApp(
          title: 'Theme Manager Demo',
          theme: state.themeData,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final brightnessPreference = ThemeManager.of(context).state.brightnessPreference;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Manager'),
        centerTitle: true,
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.system),
                child: const Text('System'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.light),
                child: const Text('Light'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightnessPreference.isSystem ? Colors.red : Colors.blue,
                ),
                onPressed: () => ThemeManager.of(context)
                    .setBrightness(BrightnessPreference.dark),
                child: const Text('Dark'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ThemePickerDialog.show(context, (preference) {
            ThemeManager.of(context).setBrightness(preference);
          });
        },
        child: ThemeBuilder(
          builder: (context, themeState) {
            switch (themeState.brightnessPreference) {
              case BrightnessPreference.light:
                return const Icon(Icons.wb_sunny);
              case BrightnessPreference.dark:
                return const Icon(Icons.brightness_3);
              default:
                return const Icon(Icons.brightness_auto);
            }
          },
        ),
      ),
    );
  }
}
