import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:motivator/services/debug.dart';
import 'package:motivator/util/shared.dart';
import 'package:logging/logging.dart';
import 'package:motivator/util/storage.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String androidChannelId = "custom_sound";
const String androidChannelName = "Brocast notification";
const String androidChannelDescription = "Custom Bro Sound for notifications";

class NotificationUtil {

  static final NotificationUtil _instance = NotificationUtil._internal();

  NotificationUtil._internal();

  factory NotificationUtil() {
    return _instance;
  }

  String? firebaseToken;
  var screen;

  Debug? debug;

  Map<String, String> channelMap = {
    "id": androidChannelId,
    "name": androidChannelName,
    "description": androidChannelDescription
  };

  static const MethodChannel _channel
            = MethodChannel('nl.motivator.motivator/channel_bro');

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
            = FlutterLocalNotificationsPlugin();
  late NotificationDetails platformChannelSpecifics;

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings
              = AndroidInitializationSettings('res_bro_icon');

    const IOSInitializationSettings iosSettings = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false
    );

    const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings
    );

    await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onSelectNotification: selectNotification
    );
  }

  void selectNotification(String? payload) {
    print("selected the notification");
    print("payload $payload");
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

  initialize(var screen) async {
    this.screen = screen;

    Logger.root.level = Level.SEVERE;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    if (firebaseToken == null) {
      await Firebase.initializeApp();
      debug = Debug();
      initializeLocalNotifications();
      initializeFirebaseService();

      createNotificationChannel();

      NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
              sound: true, badge: true, alert: true))
          .then((_) {
        print("notifications allowed");
      });

      platformChannelSpecifics = const NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannelId,
            androidChannelName,
            channelDescription: androidChannelDescription,
            playSound: true,
            priority: Priority.high,
            importance: Importance.high,
          ),
          iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              badgeNumber: 0,
              sound: "res_brodio.aiff"
          ));
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
      // Here we create a notification for both android and ios
      Storage storage = Storage();
      print('A new onMessage event was published!');
      print("message: $message");
      _showNotification();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // open message when the app is in the background, but not terminated.
      Storage storage = Storage();
      print('A new onMessageOpenedApp event was published!');
      print("message: $message");
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // open message when app is terminated
      Storage storage = Storage();
      print("we have clicked on the message I think");
      print("message: $message");
    });
    screen.updateFirebaseToken(firebaseToken);
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

  sendDebugString(String notify, String? title, String? body, String data) {
    String sendString = notify;
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
    return firebaseToken;
  }

  void firebaseBackgroundInitialization() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  void showNotification() {
    _showNotification();
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
