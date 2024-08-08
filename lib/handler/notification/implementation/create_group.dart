import 'package:chat_app_firebase/handler/notification/notification_handler.dart';
import 'package:chat_app_firebase/models/notification_payload_model.dart';
import 'package:chat_app_firebase/providers/chat_screen_provider.dart';

class CreateGroupNotificationHandler extends NotificationHandler {

  CreateGroupNotificationHandler({ required super.ref });

  @override
  void triggerNotificationOnClick({NotificationPayload? payload}) {
    ref.read(chatScreenProvider).switchChatScreen(1);
  }

}