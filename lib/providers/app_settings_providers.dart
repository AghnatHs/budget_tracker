// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const String ThemeFromSetting = 'setting_theme';
const String DateFormatFromSetting = 'setting_date_format';

final appSettingsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});


final appSettingsThemeProvider = StateProvider<String>((ref) {
  final appSettings = ref.watch(appSettingsProvider);
  final theme = appSettings.getString(ThemeFromSetting);
  ref.listenSelf((previous, current) {
    appSettings.setString(ThemeFromSetting, current);
  });

  return theme!;
});

final appSettingsDateFormatProvider = StateProvider<String>((ref) {
  final appSettings = ref.watch(appSettingsProvider);
  final dateFormat = appSettings.getString(DateFormatFromSetting);
  ref.listenSelf((previous, current) {
    appSettings.setString(DateFormatFromSetting, current);
  });

  return dateFormat!;
});
