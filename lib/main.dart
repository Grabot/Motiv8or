import 'package:flutter/material.dart';
import 'package:motivator/pages/home_page.dart';
import 'package:motivator/services/navigation_service.dart';
import 'package:motivator/util/locator.dart';
import 'package:motivator/util/notification_util.dart';
import 'package:motivator/constants/route_paths.dart' as routes;
import 'package:motivator/router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

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
      initialRoute: routes.HomeRoute,
      onGenerateRoute: router.generateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: const HomePage(),
    );
  }
}

