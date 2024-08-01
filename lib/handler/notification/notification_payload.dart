import 'package:chat_app_firebase/handler/notification/notification_type.dart';

class NotificationPayload<T> {
  NotificationPayload(this.type, this.msgData);

  final NotificationType type;
  T? msgData;

  factory NotificationPayload.fromJson(Map<String, dynamic> data) {
    final type = data["type"] as String;
    final msgData = data["msgData"] as T?;

    return NotificationPayload(NotificationType.values.byName(type), msgData);
  }
}