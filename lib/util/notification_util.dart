import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:motivator/services/debug.dart';
import 'package:motivator/util/shared.dart';
import 'package:logging/logging.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationUtil {

  static final NotificationUtil _instance = NotificationUtil._internal();

  String? firebaseToken;
  var screen;

  Debug? debug = null;

  Map<String, String> channelMap = {
    "id": "custom_sound",
    "name": "Brocast notification",
    "description": "Custom Bro Sound for notifications"
  };

  static const MethodChannel _channel = MethodChannel('nl.motivator.motivator/channel_bro');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late NotificationDetails platformChannelSpecifics;

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('res_bro_icon');

    //Initialization Settings for iOS devices
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification
    );
  }

  void selectNotification(String? payload) {
    print("selected the notificatoins");
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  factory NotificationUtil() {
    return _instance;
  }

  NotificationUtil._internal();

  initialize(var screen) async {
    this.screen = screen;

    Logger.root.level = Level.SEVERE;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    if (firebaseToken == null) {
      await Firebase.initializeApp();
      debug = Debug();
      await initializeFirebaseService();

      createNotificationChannel();

      // show the dialog/open settings screen
      NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
              sound: true, badge: true, alert: true))
          .then((_) {
        // when finished, check the permission status
        print("notifications allowed");
      });

      platformChannelSpecifics = NotificationDetails(
          android: AndroidNotificationDetails(
            'custom_sound',
            'Brocast notification',
            playSound: true,
            priority: Priority.high,
            importance: Importance.high,
          ),
          iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 0,
              subtitle: "subtitle",
              threadIdentifier: "threadIdentifier"
          ));

      this.screen.update();
    }
  }

  Future<void> initializeFirebaseService() async {
    await Firebase.initializeApp();
    firebaseToken = await FirebaseMessaging.instance.getToken();

    print("registration id: \n$firebaseToken");
    if (firebaseToken == null || firebaseToken == "") {
      return;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // open message when the app is in the foreground.
      print('A new onMessage event was published!');
      print("message: $message");
      _showNotification();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // open message when the app is in the background, but not terminated.
      print('A new onMessageOpenedApp event was published!');
      print("message: $message");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // open message when app is terminated
      print("we have clicked on the message I think");
      print("message: $message");
    });

  }

  createNotificationChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      print("channel created");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  sendFirebaseToken() {
    Debug debug = Debug();
    debug.debugPost(firebaseToken!).then((val) {
      if (val) {
        print("registration send");
      } else {
        print("sending a debug post FAILED!");
      }
    });
  }

  sendDebugString(String notificationDetail, String? title, String? body, String data) {
    String sendString = notificationDetail;
    sendString = sendString + "   title $title";
    sendString = sendString + "   body $body";
    sendString = sendString + "   data $data";
    HelperFunction.getTestString().then((val) {
      if (val == null || val == "") {
        sendString = "no test string:  " + sendString;
      } else {
        sendString = val + ":   " + sendString;
      }
      debug!.debugPost(sendString).then((val) {
        if (val) {
          print("we have successfully send an update");
        } else {
          print("sending a debug post FAILED!");
        }
      });
    });
  }

  getFirebaseToken() {
    return this.firebaseToken;
  }

  void firebaseBackgroundInitialization() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
  }

  Future<void> _showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'This is the Notification Body',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  String? title = message.notification!.title;
  String? body = message.notification!.body;
  String data = message.data.toString();
  Debug debug = Debug();
  String sendString = "background: ";
  sendString = sendString + "   title $title";
  sendString = sendString + "   body $body";
  sendString = sendString + "   data $data";
  print("background message: $message");
  HelperFunction.getTestString().then((val) {
    if (val == null || val == "") {
      sendString = "no test string:  " + sendString;
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
