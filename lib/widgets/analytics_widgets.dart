import 'package:fl_budget_tracker/functions.dart';
import 'package:fl_budget_tracker/providers/analytics_monthly_providers.dart';
import 'package:fl_budget_tracker/providers/analytics_daily_providers.dart';
import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


//SMALL WIDGETS
class DayInfoDisplay extends ConsumerWidget {
  static const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);
  const DayInfoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String day = ref.watch(dayInfoDayProvider);
    List<BudgetHistoryData> budgetHistory = ref.watch(dailyBudgetHistoryByGivenDayProvider);

    int incomeDaily = ref.watch(dailyIncomeProvider);
    int expenseDaily = ref.watch(dailyExpenseProvider);
    int summaryDaily = ref.watch(dailySummaryProvider);
    String summaryPrefix = summaryDaily > 0 ? 'income' : 'expense';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            day,
            style: titleStyle,
          ),
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
          Expanded(
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
                        const Divider(
                          thickness: 2,
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
    String prefix = thisMonthSummary > 0 ? 'income' : 'expense';

    return Column(
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
        //TODO: SUMMARY IN MONTHLY WIDGET (improve)
        Text(currencyFormat(thisMonthSummary.toString(), prefix: prefix)),
        const Divider(thickness: 3,)
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

    //expose day which user selected,
    var dayInfoDay = ref.watch(dayInfoDayProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(dayDates.length, (index) {
                      Widget button = ElevatedButton(
                        onPressed: () {
                          ref
                              .read(dayInfoDayProvider.notifier)
                              .update((state) => dayDates[index]);
                        },
                        //Show days text
                        child: Text(dayDates[index]),
                      );
                      return button;
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        //show the day budget info
        Expanded(
          child: dayInfoDay != '' ? const DayInfoDisplay() : const Column(),
        )
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
