import 'package:flutter/material.dart';
import 'package:motivator/pages/home_page.dart';
import 'package:motivator/util/notification_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

