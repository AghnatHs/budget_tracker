import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/analytics_page_providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var analyticsType = ref.watch(analyticsTypeProvider);
    var analyticsPage= ref.watch(analyticsPageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          DropdownButtonHideUnderline(
              child: DropdownButton(
                  dropdownColor: Theme.of(context).primaryColor,
                  style: const TextStyle(color: Colors.white),
                  value: analyticsType,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly'))
                  ],
                  onChanged: (String? value) =>
                      ref.read(analyticsTypeProvider.notifier).update((state) => value!)))
        ],
      ),
      body: analyticsPage[analyticsType],
    );
  }
}
