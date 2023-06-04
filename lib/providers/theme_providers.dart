import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

Color getTheme(String name) {
  switch (name) {
    case 'Green':
      return Colors.green;
    case 'Red':
      return Colors.red;
    case 'Indigo':
      return Colors.indigo;
    case 'Blue':
      return Colors.blue;
  }

  return Colors.green;
}

final themeProvider = StateProvider<Color>((ref) {
  final appSettingTheme = ref.watch(appSettingsThemeProvider);
  return getTheme(appSettingTheme);
});
