import 'package:api_key/secreen/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:api_key/secreen/components/home.dart';
import 'package:api_key/secreen/components/voicerecoder.dart';
import 'package:api_key/secreen/components/login.dart';
import 'package:api_key/secreen/components/states.dart';
import 'package:api_key/secreen/components/register.dart';
import 'package:api_key/secreen/components/charapp.dart';
import 'package:api_key/secreen/components/screenchat.dart';
class AppRouter {
  static const String home = "/home";
  static const String voice = "/voice";
  static const String login = "/login";
  static const String register = "/register";
  static const String chatapp = '/chat';
  static const String screenchat = '/secreenchat';

  static Route generateRoute(RouteSettings setting) {
    if (!setLogin && setting.name != login && setting.name != register) {
      return MaterialPageRoute(builder: (_) => Login());
    }
    switch (setting.name) {
      case login:
        return MaterialPageRoute(builder: (_) => Login());
      case home:
        return MaterialPageRoute(builder: (_) => Home());
      case voice:
        return MaterialPageRoute(builder: (_) => Voice());
      case register:
        return MaterialPageRoute(builder: (_) => Register());
      case chatapp:
        return MaterialPageRoute(builder: (_) => Chatapp());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: MyAppbar(title: setting.name ?? "Unknown"),
            body: Center(child: Text("${setting.name} Page not found")),
          ),
        );
    }
  }
}
