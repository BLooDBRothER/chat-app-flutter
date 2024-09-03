import 'package:chat_app_firebase/handler/notification/notification_handler.dart';
import 'package:chat_app_firebase/models/notification_payload_model.dart';
import 'package:chat_app_firebase/screens/groups/create/create_group.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';

class CreateGroupNotificationHandler extends NotificationHandler {

  CreateGroupNotificationHandler({ required super.ref });

  @override
  void triggerNotificationOnClick({NotificationPayload? payload}) {
    locator<NavigationService>().pushAndReplaceTo(CreateGroupScreen.routeName);
  }

}