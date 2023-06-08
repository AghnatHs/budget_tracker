import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:fl_budget_tracker/providers/date_format_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'snackbar.dart';

// ignore: constant_identifier_names
const TextStyle SettingTitleTextStyle = TextStyle(fontWeight: FontWeight.bold);

//Small Widgets
class ThemeSelectorRadioButton extends ConsumerWidget {
  final String value;
  final String groupValue;
  final String? titleText;
  const ThemeSelectorRadioButton(
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
  const DateFormatSelectorRadioButton(
      {required this.value, required this.groupValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: (String? value) {
        ref.read(appSettingsDateFormatProvider.notifier).state = value!;
      },
      title: Text(dateFormatName[value]!),
    );
  }
}

class SettingDisplay extends ConsumerWidget {
  const SettingDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String themeSetting = ref.watch(appSettingsThemeProvider);
    String dateFormatSetting = ref.watch(appSettingsDateFormatProvider);

    SharedPreferences appSettingsPrefs = ref.watch(appSettingsProvider);
    List appInfo = appSettingsPrefs.getStringList(AppInfoFromSetting)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionTile(
            leading: const SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.format_paint,
                )),
            title: const Text(
              'Theme',
              style: SettingTitleTextStyle,
            ),
            subtitle: Text(themeSetting),
            children: [
              Column(children: [
                ThemeSelectorRadioButton(
                  value: 'Blue',
                  groupValue: themeSetting,
                ),
                ThemeSelectorRadioButton(
                  value: 'Green',
                  groupValue: themeSetting,
                ),
                ThemeSelectorRadioButton(
                  value: 'Indigo',
                  groupValue: themeSetting,
                ),
                ThemeSelectorRadioButton(
                  value: 'Red',
                  groupValue: themeSetting,
                ),
              ])
            ],
          ),
          ExpansionTile(
            leading: const SizedBox(
                height: double.infinity, child: Icon(Icons.calendar_month_sharp)),
            title: const Text(
              'Date Format',
              style: SettingTitleTextStyle,
            ),
            subtitle: Text(dateFormatName[dateFormatSetting]!),
            children: [
              Column(children: [
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayDayMonthYearHourMinute.name,
                  groupValue: dateFormatSetting,
                ),
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayMonthYearHourMinute.name,
                  groupValue: dateFormatSetting,
                ),
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayMonthDayYearHourMinute.name,
                  groupValue: dateFormatSetting,
                ),
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.monthDayYearHourMinute.name,
                  groupValue: dateFormatSetting,
                ),
                DateFormatSelectorRadioButton(
                  value: DateFormatSetting.dayMonthYearHourMinuteNoAbbr.name,
                  groupValue: dateFormatSetting,
                )
              ])
            ],
          ),
          ListTile(
            leading: const SizedBox(height: double.infinity, child: Icon(Icons.info_outline)),
            title: const Text(
              'About',
              style: SettingTitleTextStyle,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(appInfo[0]), //APP NAME
              Text('version ${appInfo[1]}') //APP VERSION
            ]),
          )
        ],
      ),
    );
  }
}
