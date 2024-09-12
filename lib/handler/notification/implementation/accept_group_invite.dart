import 'dart:developer';

import 'package:chat_app_firebase/handler/notification/notification_handler.dart';

import '../notification_type.dart';

class AcceptGroupInviteNotificationMsgData {
  final String groupId;

  const AcceptGroupInviteNotificationMsgData({
    required this.groupId
  });

  factory AcceptGroupInviteNotificationMsgData.fromJson(Map<String, dynamic> payload) {
    return AcceptGroupInviteNotificationMsgData(groupId: payload['groupId']);
  }
}

class AcceptGroupInviteNotificationHandler
    extends NotificationHandler<AcceptGroupInviteNotificationMsgData> {

  @override
  void triggerNotificationOnClick(
      {AcceptGroupInviteNotificationMsgData? payload}) {
    if(payload == null) {
      log("Error No Payload for ${NotificationType.USER_GROUP_ACCEPT}", name: "Notification", time: DateTime.timestamp());
      throw 'No Payload';
    }
    log("Triggering ${NotificationType.USER_GROUP_ACCEPT}", name: "Notification", time: DateTime.timestamp());
    print("inside accept invites -------------- ${payload.groupId}");
  }
}
