import 'dart:developer';

import 'package:chat_app_firebase/service/notification/notification_api.dart';
import 'package:chat_app_firebase/service/notification/notification_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static bool _isNotificationListenerEnabled = false;
  static bool _isInitialMessageLoaded = false;
  static String? fcmToken;

  Future<void> initNotification() async {
    if(_isNotificationListenerEnabled) {
      return;
    }
    _isNotificationListenerEnabled = true;

    await _firebaseMessaging.requestPermission(
      alert: true,
      provisional: true,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true
    );

    fcmToken = await _firebaseMessaging.getToken();

    await initNotificationListener();
  }

  Future<void> initNotificationListener() async {

    await setupFgAndBgMessageHandler();
    setupInteractedMessage();

    _isNotificationListenerEnabled = true;

  }

  Future<void> setupFgAndBgMessageHandler() async {
    log("Attaching Foreground Notification Listener", name: "Notification", time: DateTime.timestamp());
    FirebaseMessaging.onMessage.listen((event) async {
      log("From Listening", name: "Notification", time: DateTime.timestamp());

      await NotificationApi.pushNotification(event);
    });
    loadInitialMessage();
  }

  void setupInteractedMessage() {
    log("Attaching Interaction Listener", name: "Notification", time: DateTime.timestamp());

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("From Opened", name: "Notification", time: DateTime.timestamp());

      NotificationInitializer.triggerNotification(message);
    });
  }

  static loadInitialMessage() {
    log("Fetching Notification On App Open", name: "Notification", time: DateTime.timestamp());
    if(_isInitialMessageLoaded) {
      return;
    }
    _isInitialMessageLoaded = true;
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
      if(initialMessage != null) {
        NotificationInitializer.triggerNotification(initialMessage);
      }
    });
  }
}