import 'package:fl_budget_tracker/widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: <Widget>[
        HomeTop(),
        HomeMiddle(),
        Divider(thickness: 1,),
        HomeBottom(),
      ],
    );
  }
}

class HomeTop extends ConsumerWidget {
  const HomeTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: 
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Theme.of(context).primaryColor, Colors.white],
              )
            ),
            child: const TotalBudgetDisplay(),
          ),
        ),
    );
  }
}

class HomeMiddle extends ConsumerWidget {
  const HomeMiddle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Expanded(
      flex: 1,
      child: BudgetInfoDisplay(),
    );
  }
}

class HomeBottom extends ConsumerWidget {
  const HomeBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex:4,
      child: 
      Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9))
          ),
        child: const BudgetHistoryDisplay(),
        ),
    );
  }
}
