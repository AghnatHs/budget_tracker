import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DateFormatSetting {
  dayDayMonthYearHourMinute,
  dayMonthYearHourMinute,
}
//TODO : Implement fetch from setting

final dateFormatSettingProvider =
    StateProvider<DateFormatSetting>((ref) => DateFormatSetting.dayDayMonthYearHourMinute);

final dateFormatProvider = StateProvider<String>((ref) {
  DateFormatSetting dateFormatSetting = ref.watch(dateFormatSettingProvider);
  switch (dateFormatSetting) {
    // format : 'Something - Hours'
    case DateFormatSetting.dayDayMonthYearHourMinute:
      return 'EEEE, dd MMMM yyyy - kk:mm';
    case DateFormatSetting.dayMonthYearHourMinute:
      return 'dd MMMM yyyy - kk:mm';
  }
});
