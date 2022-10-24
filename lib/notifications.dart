import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'Date.dart';

class Notifications{
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  Future<NotificationDetails> notificationDetails() async {
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
    NotificationDetails details = await notificationDetails();

    flutterLocalNotificationsPlugin.show(
      0,
      'plain title',
      'plain body',
      details,
      payload: 'item x',
    );
  }

  void scheduleNotification(int id, String title, String body, DateTime schedule) async{
    NotificationDetails details = await notificationDetails();

    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      await Date.convertDateTime(schedule),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void deleteScheduledNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }
}