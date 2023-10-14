import 'package:fl_budget_tracker/widgets/analytics_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsTypeProvider = StateProvider<String>((ref) => 'daily');
final analyticsPageProvider = StateNotifierProvider<AnalyticsPageNotifier, Map<String,Widget>>(
  (ref) => AnalyticsPageNotifier()
);


class AnalyticsPageNotifier extends StateNotifier<Map<String, Widget>> {
  AnalyticsPageNotifier()
      : super({
          'daily': const AnalyticsDailyPage(),
          'monthly': const AnalyticsMonthlyPage(),
        });
}
