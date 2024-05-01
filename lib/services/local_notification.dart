import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> scheduleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,int notificationId) async {
  var androidDetails = const AndroidNotificationDetails(
    'channel_id',
    'Channel Name',
    importance: Importance.high,
  );
  var iOSDetails = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidDetails,
    iOS: iOSDetails,
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Title',
    'Description',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
}
