import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class NotificationHandler<T> {
  NotificationHandler({
    required this.ref,
  });

  final WidgetRef ref;

  void triggerNotificationOnClick([T? payload]);
}