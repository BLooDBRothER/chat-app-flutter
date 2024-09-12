import 'dart:convert';

import 'package:chat_app_firebase/handler/notification/implementation/accept_group_invite.dart';
import 'package:chat_app_firebase/handler/notification/implementation/create_group.dart';
import 'package:chat_app_firebase/handler/notification/notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationInitializer {

  static triggerNotification(RemoteMessage remoteMessage) {
    print("inside trig Not");
    final payload = jsonDecode(remoteMessage.data.entries.elementAt(0).value);
    _triggerOnClick(payload);
  }

  static triggerNotificationFromPayload(String messagePayload) {
    print("inside trig Not payload");
    final fullPayload = json.decode(messagePayload);

    final payload =jsonDecode(fullPayload["payload"]);
    _triggerOnClick(payload);
  }

  static void _triggerOnClick(Map<String, dynamic> payload) {
    try {
      print("on click");
      print(payload['type']);
      NotificationType type = NotificationType.values.byName(payload['type']);
      print(type);
      switch (type) {
        case NotificationType.GROUP_CREATE:
          CreateGroupNotificationHandler()
              .triggerNotificationOnClick();
          break;
        case NotificationType.USER_GROUP_ACCEPT:
          AcceptGroupInviteNotificationMsgData notificationPayload = AcceptGroupInviteNotificationMsgData.fromJson(payload['msgData']);
          AcceptGroupInviteNotificationHandler()
              .triggerNotificationOnClick(payload: notificationPayload);
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
