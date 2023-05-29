import 'package:fl_budget_tracker/database/database.dart';
import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:fl_budget_tracker/providers/input_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../functions.dart';

const TextStyle inputTitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

class InputDialog extends ConsumerStatefulWidget {
  const InputDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<InputDialog> createState() => InputDialogState();
}

class InputDialogState extends ConsumerState<InputDialog> {
  InputDialogState({Key? key}) : super();

  TextEditingController amountTextController = TextEditingController();
  TextEditingController detailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Input',
        style: inputTitleTextStyle,
      ),
      titlePadding: const EdgeInsets.fromLTRB(9, 9, 0, 0),
      contentPadding: const EdgeInsets.all(2),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(9, 0, 0, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(
              thickness: 2,
            ),
            //Amount input
            TextFormField(
              keyboardType: TextInputType.number,
              controller: amountTextController,
              autovalidateMode: AutovalidateMode.always,
              maxLength: 18,
              decoration: const InputDecoration(
                hintText: 'format: 100000 (Rp10.000)',
                labelText: 'Amount',
              ),
              onChanged: (String? value) {
                setState(() {});
              },
              validator: (String? value) {
                return int.tryParse(value!) != null ? null : 'Please enter valid integer';
              },
            ),
            //Detail input
            TextFormField(
              maxLength: 50,
              controller: detailTextController,
              decoration: const InputDecoration(
                hintText: 'Write detail about this cashflow',
                labelText: 'Detail',
              ),
              onChanged: (String? value) {},
            ),
            //Budget type
            DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: ref.watch(inputBudgetTypeProvider),
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense'))
                  ],
                  onChanged: (String? value) =>
                      ref.read(inputBudgetTypeProvider.notifier).update((state) => value!)),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: amountTextController.value.text.isEmpty
              ? null
              : () {
                  Navigator.pop(context);
                  ref.read(budgetHistoryDataProvider.notifier).addBudget(BudgetHistoryData(
                      token: randomizeToken(),
                      amount: amountTextController.text,
                      type: ref.watch(inputBudgetTypeProvider),
                      detail: detailTextController.text,
                      date: DateTime.now()));
                  saveDbJson(data: ref.watch(budgetHistoryDataProvider));
                },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

//'DELETING BUDGET TILE' WIDGET
class BudgetTileMockup extends ConsumerWidget {
  final String amount;
  final String budgetType;
  final String detail;
  final String date;
  const BudgetTileMockup(
      {required this.amount,
      required this.budgetType,
      required this.detail,
      required this.date,
      Key? key})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color textColor = budgetType == 'income' ? Colors.green : Colors.red;
    return ListTile(
      tileColor: Colors.black12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: Text(
        currencyFormat(amount, prefix: budgetType),
        style: TextStyle(color: textColor),
      ),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(detail),
        Text(
          date,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ]),
    );
  }
}

class BudgetTileConfirmDeleteDialog extends ConsumerWidget {
  //SHOW SNACKBAR AFTER DELETING
  final String token;
  final String amount;
  final String budgetType;
  final String detail;
  final String date;
  const BudgetTileConfirmDeleteDialog(
      {required this.token,
      required this.amount,
      required this.budgetType,
      required this.detail,
      required this.date,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Delete this budget?', style: inputTitleTextStyle),
      titlePadding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
      contentPadding: const EdgeInsets.all(2),
      content: Padding(
          padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetTileMockup(
                    amount: amount, budgetType: budgetType, detail: detail, date: date),
                const SizedBox(
                  height: 8,
                ),
                const Text('This action cannot be undone!'),
                const Divider(),
              ])),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            TextButton(
                onPressed: () {
                  ref.read(budgetHistoryDataProvider.notifier).removeBudget(token);
                  saveDbJson(data: ref.watch(budgetHistoryDataProvider));
                  Navigator.pop(context);
                },
                child: const Text('ACCEPT'))
          ],
        )
      ],
    );
  }
}
