import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:fl_budget_tracker/screens/template_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final appSettingsPrefsInit = await SharedPreferences.getInstance();
  appSettingsPrefsInit.getString(ThemeFromSetting) == null
      ? appSettingsPrefsInit.setString(ThemeFromSetting, 'Green')
      : () {};
  appSettingsPrefsInit.getString(DateFormatFromSetting) == null
      ? appSettingsPrefsInit.setString(
          DateFormatFromSetting, DateFormatSetting.dayDayMonthYearHourMinute.name)
      : () {};
  appSettingsPrefsInit.getBool(AcknowledgeBudgetDeleteOnLongPress) == null
      ? appSettingsPrefsInit.setBool(
        AcknowledgeBudgetDeleteOnLongPress, false) 
      : () {};
  appSettingsPrefsInit.setStringList(
      AppInfoFromSetting, [packageInfo.appName, packageInfo.version]);
      
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
      title: 'Budget Tracker',
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
