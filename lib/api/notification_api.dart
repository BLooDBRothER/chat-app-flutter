import 'dart:convert';

import 'package:chat_app_firebase/handler/notification/notification_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (notificationResponse) {
        if(notificationResponse.payload == null) {
          return;
        }

        NotificationInitializer.triggerNotificationFromPayload(notificationResponse.payload!);
      }
    );
  }

  static pushNotification(
      RemoteMessage message,
      ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default',
      'Default Channel',
      channelDescription: 'Default Channel for all the notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.show(
        0,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data)
    );
  }
}