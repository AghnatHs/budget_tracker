import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:fl_budget_tracker/screens/template_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appSettingsPrefsInit = await SharedPreferences.getInstance();
  //SET TO DEFAULT VALUE WHEN FIRST TIME
  appSettingsPrefsInit.getString(ThemeFromSetting) == null
      ? appSettingsPrefsInit.setString(ThemeFromSetting, 'Green')
      : () {};
  appSettingsPrefsInit.getString(DateFormatFromSetting) == null
      ? appSettingsPrefsInit.setString(
          DateFormatFromSetting, DateFormatSetting.dayDayMonthYearHourMinute.name)
      : () {};
  runApp(
    ProviderScope(
      overrides: [appSettingsProvider.overrideWithValue(appSettingsPrefsInit)],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color themeColor = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Track Me Budget',
      theme: ThemeData(
        primaryColor: themeColor,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          primarySwatch: themeColor as MaterialColor,
        ),
      ),
      home: const TemplateScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
