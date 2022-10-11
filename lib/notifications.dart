import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class Notifications{
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    tz.initializeTimeZones();
    // TODO: Dynamic timezone location
    tz.setLocalLocation(await TimeZoneLocation.getTimeZoneLocation());

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_stat_ac_unit');
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true);

    return const NotificationDetails(
      android: androidNotificationDetails,
    );
  }

  void showNotification() async{
    NotificationDetails notificationDetails = await _notificationDetails();

    await flutterLocalNotificationsPlugin.show(
      0,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
  }

  void scheduleNotification(int id, String title, String body, DateTime schedule) async{
    NotificationDetails notificationDetails = await _notificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      await convertDateTime(schedule),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<tz.TZDateTime> convertDateTime(DateTime date) async{
    return tz.TZDateTime.from(date, await TimeZoneLocation.getTimeZoneLocation());
  }
}

class TimeZoneLocation {
  static Future<tz.Location> getTimeZoneLocation() async {
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    return tz.getLocation(timeZoneName);
  }
}