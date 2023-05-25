import 'package:fl_budget_tracker/providers/screen_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigator extends ConsumerWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting')
      ],
      //backgroundColor: Theme.of(context).colorScheme.secondary,
      elevation: 12,
      currentIndex: ref.watch(screenIndexProvider),
      onTap: (int index) => ref.read(screenIndexProvider.notifier).update((state) => index)
      );
  }
}
