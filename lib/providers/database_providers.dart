import 'dart:math';

import 'package:fl_budget_tracker/database/backup_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';

String randomizeToken() {
  String char =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#%^&*(),./;'[]{}:<>?_-+";
  List seed = char.split('');
  String token = '';

  Random random = Random();
  int tokenLength = random.nextInt(95) + 1;

  for (int i = 0; i < tokenLength; i++) {
    int index = random.nextInt(char.length);
    token += seed[index];
  }
  return token;
}

//DATABASE PROVIDER
final budgetHistoryDataProvider =
    StateNotifierProvider<BudgetHistoryDataNotifier, List<BudgetHistoryData>>((ref) {
  BudgetHistoryDataNotifier notifier = BudgetHistoryDataNotifier();
  notifier.fetchFromJson();
  return notifier;
});

final incomeBudgetProvider = StateProvider<int>((ref) {
  int sum = 0;
  final budgetHistoryData = ref.watch(budgetHistoryDataProvider);
  for (var budget in budgetHistoryData) {
    budget.type == 'income' ? sum += int.parse(budget.amount) : null;
  }
  return sum;
});

final expenseBudgetProvider = StateProvider<int>((ref) {
  int sum = 0;
  final budgetHistoryData = ref.watch(budgetHistoryDataProvider);
  for (var budget in budgetHistoryData) {
    budget.type == 'expense' ? sum += int.parse(budget.amount) : null;
  }
  return sum;
});

final totalBudgetProvider = StateProvider<int>(
    (ref) => ref.watch(incomeBudgetProvider) - ref.watch(expenseBudgetProvider));

@immutable
class BudgetHistoryData {
  final String token;
  final String amount;
  final String type;
  final String detail;
  final DateTime date;
  const BudgetHistoryData(
      {required this.token,
      required this.amount,
      required this.type,
      required this.detail,
      required this.date});

  BudgetHistoryData copyWith(
      {String? token, String? amount, String? type, String? detail, DateTime? date}) {
    return BudgetHistoryData(
        token: token ?? this.token,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        detail: detail ?? this.detail,
        date: date ?? this.date);
  }

  @override
  String toString() {
    return '$amount;$date';
  }
}

class BudgetHistoryDataNotifier extends StateNotifier<List<BudgetHistoryData>> {
  BudgetHistoryDataNotifier() : super([]);

  void overwriteState(Map db) {
    state = [
      for (final token in db.keys)
        BudgetHistoryData(
            token: token,
            amount: db[token][0],
            type: db[token][1],
            detail: db[token][2],
            date: DateTime.parse(db[token][3]))
    ];
  }

  void fetchFromJson() async {
    // {"_token":[_amount, _type, _detail, DateTime _date]}
    try {
      final Map db = await fetchDb();
      overwriteState(db);
    } catch (e) {
      //print(e);
    }
  }

  void importFromExternal() async {
    try {
      final Map db = await getBackupDb();
      overwriteState(db);
    } catch (e) {
      //print(e);
    }
  }

  void addBudget(BudgetHistoryData budget) {
    state = [budget, ...state];
  }

  void removeBudget(String token) {
    state = [
      for (final budgetHistoryData in state)
        if (budgetHistoryData.token != token) budgetHistoryData,
    ];
  }

  int getTotalIncome() {
    int sum = 0;
    for (var budget in state) {
      if (budget.type == 'income') sum += int.parse(budget.amount);
    }
    return sum;
  }

  int getTotalExpense() {
    int sum = 0;
    for (var budget in state) {
      if (budget.type == 'expense') sum += int.parse(budget.amount);
    }
    return sum;
  }

  int getTotalSum() {
    return getTotalIncome() - getTotalExpense();
  }

  String getSummary() {
    return '';
  }
}
