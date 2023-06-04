import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFormatSetting {
  dayDayMonthYearHourMinute,
  dayMonthYearHourMinute,
}
//TODO:CREATE NEW DATE FORMAT
//Used in setting for naming
Map<String, String> dateFormatName = {
  DateFormatSetting.dayDayMonthYearHourMinute.name: 'Monday, 1 January 2000',
  DateFormatSetting.dayMonthYearHourMinute.name: '1 January 2000'
};

Map<String, DateFormatSetting> toDateFormatSetting = {
  DateFormatSetting.dayDayMonthYearHourMinute.name:
      DateFormatSetting.dayDayMonthYearHourMinute,
  DateFormatSetting.dayMonthYearHourMinute.name: DateFormatSetting.dayMonthYearHourMinute
};

final dateFormatProvider = StateProvider<String>((ref) {
  //DateFormatSetting dateFormatSetting = ref.watch(dateFormatSettingProvider);
  final appSettingDateFormat = ref.watch(appSettingsDateFormatProvider);
  DateFormatSetting dateFormatSetting = toDateFormatSetting[appSettingDateFormat]!;
  switch (dateFormatSetting) {
    // format : 'Something - Hours'
    case DateFormatSetting.dayDayMonthYearHourMinute:
      return 'EEEE, dd MMMM yyyy - kk:mm';
    case DateFormatSetting.dayMonthYearHourMinute:
      return 'dd MMMM yyyy - kk:mm';
  }
});
