import 'package:fl_budget_tracker/screens/analytics_screen.dart';
import 'package:fl_budget_tracker/screens/home_screen.dart';
import 'package:fl_budget_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//SCREEN PROVIDER
final List<Widget> screenWidgets = [
  const HomeScreen(),
  const AnalyticsScreen(),
  const SettingsScreen()
];
final screenIndexProvider = StateProvider<int>((ref) => 0);
final screenProvider = StateProvider<Widget>((ref) {
  return screenWidgets[ref.watch(screenIndexProvider)];
});
