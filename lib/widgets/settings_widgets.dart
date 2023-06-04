import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'snackbar.dart';

//Small Widgets
class SettingSelectorRadioButton extends ConsumerWidget {
  final String value;
  final String groupValue;
  final String? titleText;
  const SettingSelectorRadioButton(
      {required this.value, required this.groupValue, this.titleText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: (String? value) {
        ref.read(appSettingsThemeProvider.notifier).state = value!;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(createSnackbar('Theme changed to $value'));
      },
      title: Text(value),
    );
  }
}

class DateFormatSelectorRadioButton extends ConsumerWidget {
  final String value;
  final String groupValue;
  final String? titleText;
  const DateFormatSelectorRadioButton(
      {required this.value, required this.groupValue, this.titleText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: (String? value) {
        ref.read(appSettingsDateFormatProvider.notifier).state = value!;
      },
      title: Text(titleText == null ? value : titleText!),
    );
  }
}

class SettingDisplay extends ConsumerWidget {
  const SettingDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String themeSetting = ref.watch(appSettingsThemeProvider);
    String dateFormatSetting = ref.watch(appSettingsDateFormatProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionTile(
            leading: const SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.format_paint,
                )),
            title: const Text('Theme'),
            subtitle: Text(themeSetting),
            children: [
              Column(children: [
                SettingSelectorRadioButton(
                  value: 'Blue',
                  groupValue: themeSetting,
                ),
                SettingSelectorRadioButton(
                  value: 'Green',
                  groupValue: themeSetting,
                ),
                SettingSelectorRadioButton(
                  value: 'Indigo',
                  groupValue: themeSetting,
                ),
                SettingSelectorRadioButton(
                  value: 'Red',
                  groupValue: themeSetting,
                ),
              ])
            ],
          ),
          ExpansionTile(
            leading:
                const SizedBox(height: double.infinity, child: Icon(Icons.calendar_month_sharp)),
            title: const Text('Date Format'),
            subtitle: Text(dateFormatName[dateFormatSetting]!),
            children: [
              Column(children: [
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayDayMonthYearHourMinute.name,
                  groupValue: dateFormatSetting,
                  titleText: dateFormatName[DateFormatSetting.dayDayMonthYearHourMinute.name]!,
                ),
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayMonthYearHourMinute.name,
                  groupValue: dateFormatSetting,
                  titleText: dateFormatName[DateFormatSetting.dayMonthYearHourMinute.name]!,
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}
