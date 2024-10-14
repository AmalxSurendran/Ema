import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _handleMessageBackground(RemoteMessage message) async {
  dynamic data = jsonDecode(message.data["details"]);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails('general', "General Notifications",
          priority: Priority.high, importance: Importance.high);
  DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails();
  NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iosNotificationDetails);
  flutterLocalNotificationsPlugin.show(
      0, data["title"], data["content"], notificationDetails,
      payload: data["clickAction"]);
}

class NotificationService {
  static initNotifications() async {
    FirebaseMessaging.onMessage.listen(_handleMessageForeground);
    FirebaseMessaging.onBackgroundMessage(_handleMessageBackground);
  }

  static Future<void> _handleMessageForeground(RemoteMessage message) async {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');
  }
}
