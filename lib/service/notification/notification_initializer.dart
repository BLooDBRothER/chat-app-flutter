import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_firebase/handler/notification/implementation/accept_group_invite.dart';
import 'package:chat_app_firebase/handler/notification/implementation/create_group.dart';
import 'package:chat_app_firebase/models/notification_payload_model.dart';
import 'package:chat_app_firebase/handler/notification/notification_type.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationInitializer {
  static WidgetRef? ref;

  static triggerNotification(RemoteMessage remoteMessage) {
    final payload = NotificationPayload.fromJson(
        jsonDecode(remoteMessage.data.entries.elementAt(0).value));
    _triggerOnClick(payload);
  }

  static triggerNotificationFromPayload(String messagePayload) {
    final fullPayload = json.decode(messagePayload);

    final payload =
        NotificationPayload.fromJson(jsonDecode(fullPayload["payload"]));
    _triggerOnClick(payload);
  }

  static void _triggerOnClick(NotificationPayload<dynamic> payload) {
    if (ref == null) {
      log("No ref", name: "Notification", time: DateTime.timestamp());
      return;
    }

    try {
      switch (payload.type) {
        case NotificationType.GROUP_CREATE:
          CreateGroupNotificationHandler(ref: ref!)
              .triggerNotificationOnClick();
          break;
        case NotificationType.USER_GROUP_ACCEPT:
          AcceptGroupInviteNotificationHandler(ref: ref!)
              .triggerNotificationOnClick(
                  payload: NotificationPayload<
                          AcceptGroupInviteNotificationMsgData>.fromDynamic(
                      payload.type,
                      AcceptGroupInviteNotificationMsgData.fromDynamic(
                          payload.msgData)));
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
