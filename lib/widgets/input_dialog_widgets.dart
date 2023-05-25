import 'package:fl_budget_tracker/database/database.dart';
import 'package:fl_budget_tracker/providers/database_providers.dart';
import 'package:fl_budget_tracker/providers/input_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              onChanged: (String? value) {setState(() {});},
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

//TODO: MAKE CONFIRM DIALOG IN DELETING BUDGET TILE
