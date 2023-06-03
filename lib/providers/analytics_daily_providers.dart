import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

//Return map contains dates as key and each dates contains BudgetHistoryData that user had inputted
final dailyDayDataProvider = StateNotifierProvider.autoDispose<DailyDayDataNotifier,
    Map<String, List<BudgetHistoryData>>>((ref) {
  final dateFormat = ref.watch(dateFormatProvider).split('-')[0];
  final budgetHistoryData = ref.watch(budgetHistoryDataProvider);
  final dailyDayDataProvider = DailyDayDataNotifier();

  final Map<String, List<BudgetHistoryData>> data = {};
  for (var budget in budgetHistoryData) {
    var budgetDate = DateFormat(dateFormat).format(budget.date);
    data.update(budgetDate, (value) => [...value, budget], ifAbsent: () => [budget]);
  }

  dailyDayDataProvider.overwriteState(data);

  return dailyDayDataProvider;
});

//Return map contains income, expense and summary each day
final dailyDayReportProvider =
    StateNotifierProvider.autoDispose<DailyDayReportNotifier, Map<String, Map<String, int>>>(
        (ref) {
  final dailyDayData = ref.watch(dailyDayDataProvider);
  final dailyDayReport = DailyDayReportNotifier();

  final Map<String, Map<String, int>> data = {};
  for (String day in dailyDayData.keys) {
    //each day
    int income = 0;
    int expense = 0;
    for (var budget in dailyDayData[day]!) {
      switch (budget.type) {
        case 'income':
          income += int.parse(budget.amount);
          break;
        case 'expense':
          expense += int.parse(budget.amount);
          break;
        default:
          income += 0;
      }
    }
    int summary = income - expense;
    data.update(day, (value) => {'income': income, 'expense': expense, 'summary': summary},
        ifAbsent: () => {'income': income, 'expense': expense, 'summary': summary});
  }
  dailyDayReport.overwriteState(data);
  return dailyDayReport;
});

class DailyDayDataNotifier extends StateNotifier<Map<String, List<BudgetHistoryData>>> {
  DailyDayDataNotifier() : super({});

  void overwriteState(Map<String, List<BudgetHistoryData>> newData) {
    state = newData;
  }
}

class DailyDayReportNotifier extends StateNotifier<Map<String, Map<String, int>>> {
  /* 
  ex. 
  {
    '1 june 1945' : {'income' : 2500, 'expense' : 1500 }
  }
  */
  DailyDayReportNotifier() : super({});

  void overwriteState(Map<String, Map<String, int>> newData) {
    state = newData;
  }
}