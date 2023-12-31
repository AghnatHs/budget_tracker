// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fl_budget_tracker/functions.dart';
import 'package:fl_budget_tracker/providers/analytics_monthly_providers.dart';
import 'package:fl_budget_tracker/providers/analytics_daily_providers.dart';
import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

//SMALL WIDGETS
class DayInfoDisplay extends ConsumerWidget {
  const DayInfoDisplay({required this.day, Key? key}) : super(key: key);
  final String day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //String day = ref.watch(dayInfoDayProvider);
    List<BudgetHistoryData> budgetHistory = ref.watch(dailyDayDataProvider)[day]!;
    Map<String, int> dayReport = ref.watch(dailyDayReportProvider)[day]!;

    int incomeDaily = dayReport['income']!;
    int expenseDaily = dayReport['expense']!;
    int summaryDaily = dayReport['summary']!;
    String summaryPrefix = summaryDaily > 0 ? 'income' : 'expense';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                    title: Text(
                      'Summary  ${currencyFormat(summaryDaily.toString(), prefix: summaryPrefix)}',
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Expanded(flex: 1, child: Text('Income')),
                            Expanded(
                                flex: 3,
                                child: Text(
                                    currencyFormat(incomeDaily.toString(), prefix: 'income')))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Expanded(flex: 1, child: Text('Expense')),
                            Expanded(
                                flex: 3,
                                child: Text(currencyFormat(expenseDaily.toString(),
                                    prefix: 'expense')))
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
          //LIST OF BUDGET
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(budgetHistory.length, (index) {
                    BudgetHistoryData budget = budgetHistory[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                currencyFormat(budget.amount, prefix: budget.type),
                                style: TextStyle(
                                    color:
                                        budget.type == 'income' ? Colors.green : Colors.red),
                              ),
                            ),
                            Expanded(flex: 3, child: Text(budget.detail)),
                            Expanded(
                                flex: 1, child: Text(DateFormat('kk:mm').format(budget.date)))
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextEmbeddedBox extends ConsumerWidget {
  final String title;
  final List<Widget> children;
  final double maxHeight;
  const TextEmbeddedBox(
      {required this.maxHeight, required this.title, required this.children, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int thisMonthSummary = ref.watch(monthlySummaryProvider)[title]!;
    int thisMonthSummaryOnlyIncome = ref.watch(monthlySummaryOnlyIncomeProvider)[title]!;
    int thisMonthSummaryOnlyExpense = ref.watch(monthlySummaryOnlyExpenseProvider)[title]!;

    //Summary Text Properties
    String prefix = thisMonthSummary > 0 ? 'income' : 'expense';
    MaterialColor summaryTextColor = thisMonthSummary > 0 ? Colors.green : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Flex(direction: Axis.vertical, children: [
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.all(9),
                padding: const EdgeInsets.all(9),
                constraints: BoxConstraints(maxHeight: maxHeight),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(1),
                  shape: BoxShape.rectangle,
                ),
                child: Scrollbar(
                  controller: ScrollController(),
                  thumbVisibility: true,
                  thickness: 2,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  )),
                ),
              ),
            ]),
            Positioned(
                left: 25,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(9, 1, 9, 1),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Income     : ${currencyFormat(thisMonthSummaryOnlyIncome.toString(), prefix: "income")}",
                style: const TextStyle(color: Colors.green),
              ),
              Text(
                "Expense   : ${currencyFormat(thisMonthSummaryOnlyExpense.toString(), prefix: "expense")}",
                style: const TextStyle(color: Colors.red),
              ),
              Text(
                "Summary : ${currencyFormat(thisMonthSummary.toString(), prefix: prefix)}",
                style: TextStyle(color: summaryTextColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

//DISPLAYER
//SHOW THE DAILY ANALYTICS

class AnalyticsDailyPage extends ConsumerWidget {
  const AnalyticsDailyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dailyDayData = ref.watch(dailyDayDataProvider);
    //list of days user had been inputed some cash
    List<String> dayDates = dailyDayData.keys.toList();
    Set<String> months = {};

    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: ScrollController(),
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      //Each day expansion tile
                      children: List.generate(dayDates.length, (index) {
                        String thisMonth = dayDates[index].split(" ")[2];
                        Widget dayExpansionTile = Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              months.contains(thisMonth)
                                  ? const Stack()
                                  : Text(
                                      thisMonth,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                    ), //Month Text
                              ExpansionTile(
                                collapsedBackgroundColor: Colors.black12,
                                title: Text(dayDates[index]),
                                children: [DayInfoDisplay(day: dayDates[index])],
                              ),
                            ],
                          ),
                        );
                        months.add(thisMonth);
                        return dayExpansionTile;
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//SHOW THE MONTHLY ANALYTICS
class AnalyticsMonthlyPage extends ConsumerWidget {
  const AnalyticsMonthlyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> monthlyWidgets = ref.watch(monthlyWidgetsDataProvider);

    return Scrollbar(
      controller: ScrollController(),
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: monthlyWidgets,
          ),
        ),
      ),
    );
  }
}
