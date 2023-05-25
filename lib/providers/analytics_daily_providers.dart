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
//provide list of BudgetHistoryData in given day
final dailyBudgetHistoryByGivenDayProvider = StateNotifierProvider.autoDispose<
    BudgetHistoryByGivenDayNotifier, List<BudgetHistoryData>>((ref) {
  final dailyDayData = ref.watch(dailyDayDataProvider);
  final day = ref.watch(dayInfoDayProvider);
  final budgetHistory = BudgetHistoryByGivenDayNotifier();
  budgetHistory.overwriteState(dailyDayData[day] ?? []);

  return budgetHistory;
});
//provide day user selected
final dayInfoDayProvider = StateProvider<String>((ref) => '');
//provide income, expense, and summary from this day budgets
final dailyIncomeProvider = StateProvider.autoDispose<int>((ref) {
  int sum = 0;
  final dailyBudgetHistoryData = ref.watch(dailyBudgetHistoryByGivenDayProvider);
  for (var budget in dailyBudgetHistoryData) {
    budget.type == 'income' ? sum += int.parse(budget.amount) : null;
  }
  return sum;
});
final dailyExpenseProvider = StateProvider.autoDispose<int>((ref) {
  int sum = 0;
  final dailyBudgetHistoryData = ref.watch(dailyBudgetHistoryByGivenDayProvider);
  for (var budget in dailyBudgetHistoryData) {
    budget.type == 'expense' ? sum += int.parse(budget.amount) : null;
  }
  return sum;
});
final dailySummaryProvider = StateProvider.autoDispose<int>(
    (ref) => ref.watch(dailyIncomeProvider) - ref.watch(dailyExpenseProvider));

class BudgetHistoryByGivenDayNotifier extends StateNotifier<List<BudgetHistoryData>> {
  BudgetHistoryByGivenDayNotifier() : super([]);

  void overwriteState(List<BudgetHistoryData> newData) {
    state = newData;
  }
}

class DailyDayDataNotifier extends StateNotifier<Map<String, List<BudgetHistoryData>>> {
  DailyDayDataNotifier() : super({});

  void overwriteState(Map<String, List<BudgetHistoryData>> newData) {
    state = newData;
  }
}
