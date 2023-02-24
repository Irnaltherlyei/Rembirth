import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'Date.dart';

/// Notification manager. Need instance to show or schedule notifications.
class Notifications{
  Notifications();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  /// Setting up notification instance
  Future<void> initNotifications() async {

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  /// Choosing notification parameters. Private function.
  Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true
    );

    return const NotificationDetails(
      android: androidNotificationDetails,
    );
  }

  /// Show instant notification.
  void showNotification(int id, String title, String body, String payload) async{
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  /// Schedule notification.
  void scheduleNotification(int id, String title, String body, DateTime schedule, String payload) async{
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      await Date.convertDateTime(schedule),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload
    );
  }

  /// Delete schedule notification.
  void deleteScheduledNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Gets called when notification gets clicked on.
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (notificationResponse.payload != null) {
      onNotificationClick.add(payload);
    }
  }
}