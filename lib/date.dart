import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/// Static functions for general use when working with dates.
class Date{
  Date();

  /// Calculates days until next birthday. Wraps around next year.
  static int daysToBirthday(DateTime birthday){
    DateTime from = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime to = DateTime(DateTime.now().year, birthday.month, birthday.day);
    return to.difference(from).inDays <= 0 ? DateTime(DateTime.now().year + 1, birthday.month, birthday.day).difference(from).inDays : to.difference(from).inDays;
  }

  /// Returns today as DateTime at exact 12 o'clock.
  static DateTime now(){
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(hours: 12));
  }

  /// Returns given date without time fields.
  static DateTime cutTime(DateTime date){
    return DateTime(date.year, date.month, date.day);
  }

  /// converts DateTime to TZDateTime
  static Future<tz.TZDateTime> convertDateTime(DateTime date) async{
    tz.initializeTimeZones();
    tz.setLocalLocation(await getTimeZoneLocation());

    return tz.TZDateTime.from(date, await getTimeZoneLocation());
  }

  /// Getting local timezone for 'convertDateTime' method. Only used in this class.
  static Future<tz.Location> getTimeZoneLocation() async {
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    return tz.getLocation(timeZoneName);
  }

  /// Calculating age with given birth date
  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    int currentMonth = currentDate.month;
    int birthMonth = birthDate.month;

    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = currentDate.day;
      int birthDay = birthDate.day;

      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }
}