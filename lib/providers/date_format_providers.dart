import 'package:fl_budget_tracker/providers/app_settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFormatSetting {
  dayDayMonthYearHourMinute,
  dayMonthYearHourMinute,
  dayMonthDayYearHourMinute,
  monthDayYearHourMinute,
  dayMonthYearHourMinuteNoAbbr,
}

//Used in setting for naming
Map<String, String> dateFormatName = {
  DateFormatSetting.dayDayMonthYearHourMinute.name: 'Monday, 1 January 2000',
  DateFormatSetting.dayMonthYearHourMinute.name: '1 January 2000',
  DateFormatSetting.dayMonthDayYearHourMinute.name: 'Monday, January 1 2000',
  DateFormatSetting.monthDayYearHourMinute.name: 'January 1 2000',
  DateFormatSetting.dayMonthYearHourMinuteNoAbbr.name: '1/1/2000'
};

Map<String, DateFormatSetting> toDateFormatSetting = {
  DateFormatSetting.dayDayMonthYearHourMinute.name:
      DateFormatSetting.dayDayMonthYearHourMinute,
  DateFormatSetting.dayMonthYearHourMinute.name: DateFormatSetting.dayMonthYearHourMinute,
  DateFormatSetting.dayMonthDayYearHourMinute.name:
      DateFormatSetting.dayMonthDayYearHourMinute,
  DateFormatSetting.monthDayYearHourMinute.name: DateFormatSetting.monthDayYearHourMinute,
  DateFormatSetting.dayMonthYearHourMinuteNoAbbr.name:
      DateFormatSetting.dayMonthYearHourMinuteNoAbbr
};

final dateFormatProvider = StateProvider<String>((ref) {
  //DateFormatSetting dateFormatSetting = ref.watch(dateFormatSettingProvider);
  final appSettingDateFormat = ref.watch(appSettingsDateFormatProvider);
  DateFormatSetting dateFormatSetting = toDateFormatSetting[appSettingDateFormat]!;
  switch (dateFormatSetting) {
    // format : 'Something - Hours'
    case DateFormatSetting.dayDayMonthYearHourMinute:
      return 'EEEE, d MMMM yyyy - kk:mm';
    case DateFormatSetting.dayMonthYearHourMinute:
      return 'd MMMM yyyy - kk:mm';
    case DateFormatSetting.dayMonthDayYearHourMinute:
      return 'EEEE, MMMM d yyyy - kk:mm';
    case DateFormatSetting.monthDayYearHourMinute:
      return 'MMMM d yyyy - kk:mm';
    case DateFormatSetting.dayMonthYearHourMinuteNoAbbr:
      return 'd/M/yyyy - kk:mm';
  }
});
