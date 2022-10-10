import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationTest{
  NotificationTest();

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Germany/Berlin'));

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
        channelDescription: 'description',
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

  void scheduledNotification() async{
    NotificationDetails notificationDetails = await _notificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification test',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late NotificationTest notificationTest;

  @override
  void initState() {
    notificationTest = NotificationTest();
    notificationTest.initNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification test'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                notificationTest.showNotification();
              },
              child: const Text('Show notification')),
          ElevatedButton(
              onPressed: () async {
                notificationTest.scheduledNotification();
              },
              child: const Text('Show scheduled notification'))
        ],
      ),
    );
  }
}