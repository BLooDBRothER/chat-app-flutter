import 'package:chat_app_firebase/models/notification_payload_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class NotificationHandler<T> {
  void triggerNotificationOnClick({T? payload});
}