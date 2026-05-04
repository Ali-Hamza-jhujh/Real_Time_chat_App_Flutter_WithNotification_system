import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:api_key/main.dart'; 

void showNotification({
  required String senderName,
  required String message,
}) {
  setting.show(
    0,
    senderName,
    message,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'chat_channel_id',
        'Chat Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}