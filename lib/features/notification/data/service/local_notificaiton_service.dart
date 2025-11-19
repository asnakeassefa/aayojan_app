import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/notification_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    log('showing notification');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'general_notifications', // Replace with your channel ID
      'General Notifications', // Replace with your channel name
      channelDescription:
          'Notifications for general updates and alerts.', // Replace with your channel description
      importance: Importance.high,
      icon: '@drawable/notification_icon', // Replace with your icon asset path
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'your_sound.wav', // Replace with your sound asset path
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}