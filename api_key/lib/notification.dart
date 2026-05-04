import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Web only
import 'dart:html' as html show Notification;

final FlutterLocalNotificationsPlugin setting =
    FlutterLocalNotificationsPlugin();

void showNotification({
  required String senderName,
  required String message,
}) {
  if (kIsWeb) {
    // 🌐 Web notification
    if (html.Notification.permission == 'granted') {
      html.Notification(senderName, body: message);
    }
  } else {
    // 📱 Mobile notification
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
}