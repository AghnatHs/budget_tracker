// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const String ThemeFromSetting = 'setting_theme';
const String DateFormatFromSetting = 'setting_date_format';
const String AppInfoFromSetting = 'app_info';
const String AcknowledgeBudgetDeleteOnLongPress = 'budget_delete_on_long_press_info';

final appSettingsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

//set app setting prefs from these providers, and it's automatically update the shared prefs
//theme from app setting
final appSettingsThemeProvider = StateProvider<String>((ref) {
  final appSettings = ref.watch(appSettingsProvider);
  final theme = appSettings.getString(ThemeFromSetting);
  ref.listenSelf((previous, current) {
    appSettings.setString(ThemeFromSetting, current);
  });

  return theme!;
});

//date format from app setting
final appSettingsDateFormatProvider = StateProvider<String>((ref) {
  final appSettings = ref.watch(appSettingsProvider);
  final dateFormat = appSettings.getString(DateFormatFromSetting);
  ref.listenSelf((previous, current) {
    appSettings.setString(DateFormatFromSetting, current);
  });

  return dateFormat!;
});

//budget delete on long press info from app setting
final appSettingsAcknowledgeBudgetDeleteOnLongPress = StateProvider<bool>((ref) {
  final appSettings = ref.watch(appSettingsProvider);
  final deleteOnLongPress = appSettings.getBool(AcknowledgeBudgetDeleteOnLongPress);
  ref.listenSelf((previous, current) {
    appSettings.setBool(AcknowledgeBudgetDeleteOnLongPress, current);
  });

  return deleteOnLongPress!;
});
