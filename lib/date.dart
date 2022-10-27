import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class Date{
  Date();

  static int daysToBirthday(DateTime birthday){
    DateTime from = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime to = DateTime(DateTime.now().year, birthday.month, birthday.day);
    return to.difference(from).inDays <= 0 ? DateTime(DateTime.now().year + 1, birthday.month, birthday.day).difference(from).inDays : to.difference(from).inDays;
  }

  static DateTime now(){
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(const Duration(hours: 12));
  }

  static DateTime cutTime(DateTime date){
    return DateTime(date.year, date.month, date.day);
  }

  static Future<tz.TZDateTime> convertDateTime(DateTime date) async{
    tz.initializeTimeZones();
    tz.setLocalLocation(await getTimeZoneLocation());

    return tz.TZDateTime.from(date, await getTimeZoneLocation());
  }

  static Future<tz.Location> getTimeZoneLocation() async {
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    return tz.getLocation(timeZoneName);
  }

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