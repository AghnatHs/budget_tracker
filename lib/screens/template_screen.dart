import 'package:fl_budget_tracker/providers/screen_providers.dart';
import 'package:fl_budget_tracker/widgets/input_dialog_widgets.dart';
import 'package:fl_budget_tracker/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplateScreen extends ConsumerWidget {
  const TemplateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Screen user currently viewing
    Widget screenCurrently = ref.watch(screenProvider);
    int screenIndex = ref.watch(screenIndexProvider);

    return Scaffold(
        body: screenCurrently,
        bottomNavigationBar: const BottomNavigator(),
        floatingActionButton: screenIndex == 0 ? FloatingActionButton.extended(
            icon: const Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            label: const Text(
              'Input',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => showDialog(
                barrierColor: Colors.black87,
                context: context,
                builder: (BuildContext context) => const InputDialog())) : null);
  }
}
/*

        */