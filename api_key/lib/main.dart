import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:api_key/secreen/components/routers.dart';
import 'package:api_key/secreen/components/notification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlutterLocalNotificationsPlugin setting =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
 
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await setting.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification tapped: ${response.payload}");
    },
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'chat_channel_id',
    'Chat Notifications',
    description: 'Shows incoming chat messages',
    importance: Importance.max,
    playSound: true,
  );

  await setting
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.voice,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
