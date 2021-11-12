import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motiv8tor/pages/home_page.dart';
import 'package:motiv8tor/services/debug.dart';
import 'package:motiv8tor/util/shared.dart';
import 'package:motiv8tor/util/socket_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),
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
  // Uncomment those lines after activate google services inside example/android/build.gradle
  // Create the initialization Future outside of `build`:
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(App());
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  var socket = SocketServices();
  print('Handling a background message: ${message.messageId}');
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  print("message: $message");
  print("notification1? : ${message.notification}");
  print("notification2? : $title");
  print("notification3? : $body");
  print('Message data: ${message.data}');

  String sendString = "background message:         title: ${message.notification!.title}        body:${message.notification!.body}       data in the notification:${message.data}";
  Debug debug = new Debug();
  if (socket.isConnected()) {
    sendString = "SOCKET!   " + sendString;
  }
  HelperFunction.getTestString().then((val) {
    if (val == null || val == "") {
      sendString = "no test string!   " + sendString;
    } else {
      sendString = val + ":   " + sendString;
    }
    debug.debugPost(sendString).then((val) {
      if (val) {
        print("we have successfully send an update");
      } else {
        print("sending a debug post FAILED!");
      }
    });
  });
}

class App extends StatefulWidget {
  App();

  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  static String name = 'Awesome Notifications - Example App';
  static Color mainColor = Color(0xFF9D50DD);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navKey,
      title: App.name,
      color: App.mainColor,
      home: HomePage(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      ),
      theme: ThemeData(
        brightness: Brightness.light,

        primaryColor: App.mainColor,
        accentColor: Colors.blueGrey,
        canvasColor: Colors.white,
        focusColor: Colors.blueAccent,
        disabledColor: Colors.grey,

        backgroundColor: Colors.blueGrey.shade400,

        appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(
              color: App.mainColor,
            ),
            textTheme: TextTheme(
              headline6: TextStyle(color: App.mainColor, fontSize: 18),
            )),

        fontFamily: 'Robot',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 64.0, height: 1.5, fontWeight: FontWeight.w500),
          headline2: TextStyle(
              fontSize: 52.0, height: 1.5, fontWeight: FontWeight.w500),
          headline3: TextStyle(
              fontSize: 48.0, height: 1.5, fontWeight: FontWeight.w500),
          headline4: TextStyle(
              fontSize: 32.0, height: 1.5, fontWeight: FontWeight.w500),
          headline5: TextStyle(
              fontSize: 28.0, height: 1.5, fontWeight: FontWeight.w500),
          headline6: TextStyle(
              fontSize: 22.0, height: 1.5, fontWeight: FontWeight.w500),
          subtitle1:
              TextStyle(fontSize: 18.0, height: 1.5, color: Colors.black54),
          subtitle2:
              TextStyle(fontSize: 12.0, height: 1.5, color: Colors.black54),
          button: TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black54),
          bodyText1: TextStyle(fontSize: 16.0, height: 1.5),
          bodyText2: TextStyle(fontSize: 16.0, height: 1.5),
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          textTheme: ButtonTextTheme.accent,
        ),
      ),
    );
  }
}
