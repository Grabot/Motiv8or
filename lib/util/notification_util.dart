import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motivator/services/debug.dart';
import 'package:motivator/util/shared.dart';
import 'package:logging/logging.dart';


class NotificationUtil {

  final log = Logger('ExampleLogger');

  static final NotificationUtil _instance = NotificationUtil._internal();

  String? firebaseToken;
  var screen;

  Debug? debug = null;

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

    log.shout("Heey, look over here!");
    if (firebaseToken == null) {
      await Firebase.initializeApp();
      debug = Debug();
      await initializeFirebaseService();
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
    await Firebase.initializeApp();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // not on ios
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
