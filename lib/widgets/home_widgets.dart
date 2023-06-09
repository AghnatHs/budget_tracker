// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

import '../functions.dart';
import '../providers/database_providers.dart';

import 'input_dialog_widgets.dart';
import 'snackbar.dart';

//TEXT STYLE
const TextStyle normalBudgetTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
);
const TextStyle totalBudgetTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);
const TextStyle incomeGreenTextStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
);
const TextStyle incomeRedTextStyle = TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.bold,
);

//Small Widgets
class BudgetInfoCard extends ConsumerWidget {
  final String header;
  final String content;
  final TextStyle headerStyle;
  final TextStyle contentStyle;
  const BudgetInfoCard(
      {this.headerStyle = totalBudgetTextStyle,
      this.contentStyle = normalBudgetTextStyle,
      required this.header,
      required this.content,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 8),
        child: Column(children: [
          Text(
            header,
            style: headerStyle,
          ),
          const Divider(),
          //DISPLAY TOTAL BUDGET
          AutoSizeText(
            content,
            maxLines: 1,
            style: contentStyle,
          )
        ]),
      ),
    );
  }
}

class BudgetHistoryListTile extends ConsumerWidget {
  final String token;
  final String budget;
  final String budgetType;
  final String detail;
  final String date;

  const BudgetHistoryListTile(
      {required this.token,
      required this.budget,
      required this.budgetType,
      required this.detail,
      required this.date,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAcknowledgeBudgetDeleteOnLongPress =
        ref.watch(appSettingsAcknowledgeBudgetDeleteOnLongPress);
    Color textColor = budgetType == 'income' ? Colors.green : Colors.red;
    return ListTile(
      //TODO: i know
      onTap: () {
        if (!isAcknowledgeBudgetDeleteOnLongPress) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(createSnackbar('Long press to delete',
              duration: 3,
              actions: SnackBarAction(
                  label: 'DONT SHOW AGAIN',
                  onPressed: () =>
                    ref.read(appSettingsAcknowledgeBudgetDeleteOnLongPress.notifier).state = !isAcknowledgeBudgetDeleteOnLongPress
              )
            )
          );
        } else{}
      },
      onLongPress: () {
        showDialog(
          barrierColor: Colors.black87,
          context: context,
          builder: (BuildContext context) => BudgetTileConfirmDeleteDialog(
              token: token,
              amount: budget,
              budgetType: budgetType,
              detail: detail,
              date: date),
        );
      },
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(
        currencyFormat(budget, prefix: budgetType),
        style: TextStyle(color: textColor),
      ),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        detail != "" ? Text(detail) : Container(),
        Text(
          date,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ]),
      /*
      trailing: IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () {
            showDialog(
              barrierColor: Colors.black87,
              context: context,
              builder: (BuildContext context) => BudgetTileConfirmDeleteDialog(
                  token: token,
                  amount: budget,
                  budgetType: budgetType,
                  detail: detail,
                  date: date),
            );
          }),
        */
      isThreeLine: false,
    );
  }
}

//Displayer
class TotalBudgetDisplay extends ConsumerWidget {
  const TotalBudgetDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int totalBudget = ref.watch(totalBudgetProvider);
    String prefix = totalBudget >= 0 ? 'income' : 'expense';
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 5),
          child: BudgetInfoCard(
            header: 'Total Budget',
            content: currencyFormat(totalBudget.toString(), prefix: prefix),
            contentStyle: totalBudgetTextStyle.copyWith(color: prefix == 'income' ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }
}

class BudgetInfoDisplay extends ConsumerWidget {
  const BudgetInfoDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int incomeBudget = ref.watch(incomeBudgetProvider);
    int expenseBudget = ref.watch(expenseBudgetProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: SizedBox(
              height: 75,
              child: BudgetInfoCard(
                headerStyle: incomeGreenTextStyle,
                header: 'Incomes',
                content: currencyFormat(incomeBudget.toString(), prefix: 'income'),
              )),
        ),
        Expanded(
          child: SizedBox(
              height: 75,
              child: BudgetInfoCard(
                headerStyle: incomeRedTextStyle,
                header: 'Expenses',
                content: currencyFormat(expenseBudget.toString(), prefix: 'expense'),
              )),
        )
      ],
    );
  }
}

class BudgetHistoryDisplay extends ConsumerWidget {
  const BudgetHistoryDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _db = ref.watch(budgetHistoryDataProvider);
    var dateFormat = ref.watch(dateFormatProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
      child: ListView.builder(
          itemCount: _db.length,
          itemBuilder: (BuildContext context, int index) {
            return BudgetHistoryListTile(
                token: _db[index].token,
                budget: _db[index].amount,
                budgetType: _db[index].type,
                detail: _db[index].detail,
                date: DateFormat(dateFormat).format(_db[index].date));
          }),
    );
  }
}
