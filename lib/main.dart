import 'package:flutter/material.dart';
import 'package:motivator/pages/home_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:motivator/util/notification_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    'resource://drawable/res_bro_icon',
    [
      NotificationChannel(
          channelKey: "custom_sound",
          channelName: "Custom sound notifications",
          channelDescription: "Notifications with custom sound",
          playSound: true,
          soundSource: 'resource://raw/res_brodio',
          defaultColor: Colors.red,
          ledColor: Colors.red,
          vibrationPattern: lowVibrationPattern),
    ],
    debug: true
  );

  NotificationUtil notificationUtil = NotificationUtil();
  notificationUtil.firebaseBackgroundInitialization();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

