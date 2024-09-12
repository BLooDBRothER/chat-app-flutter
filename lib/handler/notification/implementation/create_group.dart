import 'dart:developer';

import 'package:chat_app_firebase/handler/notification/notification_handler.dart';
import 'package:chat_app_firebase/handler/notification/notification_type.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';

import '../../../screens/groups/request/group_requests.dart';

class CreateGroupNotificationHandler extends NotificationHandler {

  CreateGroupNotificationHandler();

  @override
  void triggerNotificationOnClick({dynamic payload}) {
    log("Triggering ${NotificationType.GROUP_CREATE}", name: "Notification", time: DateTime.timestamp());
    locator<NavigationService>().pushAndReplaceTo(GroupRequests.routeName);
  }

}