import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:fl_budget_tracker/widgets/analytics_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../functions.dart';

//Return map contains budget that month has
final monthlyMonthDataProvider = StateNotifierProvider.autoDispose<MonthlyMonthDataNotifier,
    Map<String, List<BudgetHistoryData>>>((ref) {
  final budgetHistoryData = ref.watch(budgetHistoryDataProvider);
  final monthlyMonthDataProvider = MonthlyMonthDataNotifier();

  final Map<String, List<BudgetHistoryData>> data = {};

  for (var budget in budgetHistoryData) {
    var budgetDate = DateFormat('MMMM yyyy').format(budget.date);
    data.update(budgetDate, (value) => [...value, budget], ifAbsent: () => [budget]);
  }

  monthlyMonthDataProvider.overwriteState(data);

  return monthlyMonthDataProvider;
});

//Return list of widget contains budget detail of each month
final monthlyWidgetsDataProvider =
    StateNotifierProvider.autoDispose<MonthlyWidgetsDataNotifier, List<Widget>>((ref) {
  final dateFormat = ref.watch(dateFormatProvider).split('-')[0];
  final monthlyMonthData = ref.watch(monthlyMonthDataProvider);
  final monthlyWidgetsDataProvider = MonthlyWidgetsDataNotifier();

  final List<Widget> data = [];
  final Set<String> days = {};

  for (var month in monthlyMonthData.keys) {
    List<Widget> monthlyTextEmbeddedBoxChildren = [];

    for (var budget in monthlyMonthData[month]!) {
      String date = DateFormat(dateFormat).format(budget.date);

      monthlyTextEmbeddedBoxChildren.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Only create the date widget on top.
            !days.contains(date) ? Text(date) : const Stack(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    currencyFormat(budget.amount, prefix: budget.type),
                    style:
                        TextStyle(color: budget.type == 'income' ? Colors.green : Colors.red),
                  ),
                ),
                Expanded(child: Text(budget.detail)),
              ],
            ),
          ],
        ),
      );
      days.add(date);
    }

    Widget monthlyTextEmbeddedBox = TextEmbeddedBox(
      maxHeight: 250,
      title: month,
      children: monthlyTextEmbeddedBoxChildren.toList(),
    );

    data.add(monthlyTextEmbeddedBox);
  }

  monthlyWidgetsDataProvider.overwriteState(data);
  return monthlyWidgetsDataProvider;
});

//Return map contains month as key and summary (income - expenses) as value
final monthlySummaryProvider =
    StateNotifierProvider.autoDispose<MonthlySummaryNotifier, Map<String, int>>((ref) {
  final monthlyMonthData = ref.watch(monthlyMonthDataProvider);
  final monthlySummary = MonthlySummaryNotifier();

  final Map<String, int> data = {};

  for (var month in monthlyMonthData.keys) {
    int thisMonthIncome = 0;
    int thisMonthExpense = 0;
    for (var budget in monthlyMonthData[month]!) {
      String type = budget.type;
      int amount = int.parse(budget.amount);
      type == 'income' ? thisMonthIncome += amount : thisMonthExpense += amount;
    }
    int thisMonthSummary = thisMonthIncome - thisMonthExpense;
    data.update(month, (value) => thisMonthSummary, ifAbsent: () => thisMonthSummary);
  }

  monthlySummary.overwriteState(data);
  return monthlySummary;
});

//Return map contains month as key and income per month as value
final monthlySummaryOnlyIncomeProvider =
    StateNotifierProvider.autoDispose<MonthlySummaryOnlyIncomeNotifier, Map<String, int>>(
        (ref) {
  final monthlyMonthData = ref.watch(monthlyMonthDataProvider);
  final monthlySummaryOnlyIncome = MonthlySummaryOnlyIncomeNotifier();

  final Map<String, int> data = {};

  for (var month in monthlyMonthData.keys) {
    int thisMonthIncome = 0;
    for (var budget in monthlyMonthData[month]!) {
      String type = budget.type;
      int amount = int.parse(budget.amount);
      type == 'income' ? thisMonthIncome += amount : (){};
    }
    data.update(month, (value) => thisMonthIncome, ifAbsent: () => thisMonthIncome);
  }

  monthlySummaryOnlyIncome.overwriteState(data);
  return monthlySummaryOnlyIncome;
});

//Return map contains month as key and income per month as value
final monthlySummaryOnlyExpenseProvider =
    StateNotifierProvider.autoDispose<MonthlySummaryOnlyExpenseNotifier, Map<String, int>>(
        (ref) {
  final monthlyMonthData = ref.watch(monthlyMonthDataProvider);
  final monthlySummaryOnlyExpense = MonthlySummaryOnlyExpenseNotifier();

  final Map<String, int> data = {};

  for (var month in monthlyMonthData.keys) {
    int thisMonthExpense = 0;
    for (var budget in monthlyMonthData[month]!) {
      String type = budget.type;
      int amount = int.parse(budget.amount);
      type == 'expense' ? thisMonthExpense += amount : (){};
    }
    data.update(month, (value) => thisMonthExpense, ifAbsent: () => thisMonthExpense);
  }

  monthlySummaryOnlyExpense.overwriteState(data);
  return monthlySummaryOnlyExpense;
});

class MonthlyWidgetsDataNotifier extends StateNotifier<List<Widget>> {
  MonthlyWidgetsDataNotifier() : super([]);

  void overwriteState(List<Widget> newState) {
    state = newState;
  }
}

class MonthlyMonthDataNotifier extends StateNotifier<Map<String, List<BudgetHistoryData>>> {
  MonthlyMonthDataNotifier() : super({});

  void overwriteState(Map<String, List<BudgetHistoryData>> newState) {
    state = newState;
  }
}

class MonthlySummaryNotifier extends StateNotifier<Map<String, int>> {
  MonthlySummaryNotifier() : super({});

  void overwriteState(Map<String, int> newState) {
    state = newState;
  }
}

class MonthlySummaryOnlyIncomeNotifier extends StateNotifier<Map<String, int>> {
  MonthlySummaryOnlyIncomeNotifier() : super({});

  void overwriteState(Map<String, int> newState) {
    state = newState;
  }
}

class MonthlySummaryOnlyExpenseNotifier extends StateNotifier<Map<String, int>> {
  MonthlySummaryOnlyExpenseNotifier() : super({});

  void overwriteState(Map<String, int> newState) {
    state = newState;
  }
}