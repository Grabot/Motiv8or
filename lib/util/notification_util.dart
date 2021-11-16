import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motivator/services/debug.dart';
import 'package:motivator/util/shared.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationUtil {
  static final NotificationUtil _instance = NotificationUtil._internal();

  String? firebaseToken;
  var screen;


  factory NotificationUtil() {
    return _instance;
  }

  NotificationUtil._internal();

  initialize(var screen) async {
    this.screen = screen;
    if (firebaseToken == null) {

      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        print("awesome notifciation allowed? $isAllowed");
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });

      AwesomeNotifications().createdStream.listen((receivedNotification) {
        String? createdSourceText =
        AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
        print('$createdSourceText notification created');
      });

      AwesomeNotifications().displayedStream.listen((receivedNotification) {
        String? createdSourceText =
        AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
        print('$createdSourceText notification displayed');
      });

      AwesomeNotifications().dismissedStream.listen((receivedAction) {
        String? dismissedSourceText = AssertUtils.toSimpleEnumString(
            receivedAction.dismissedLifeCycle);
        print('Notification dismissed on $dismissedSourceText');
      });

      AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification) {
        // notification when the user has the app opened
        // It receives it via firebase messaging and creates a notification
        // Because firebase will not create one when the app is opened.
        // If the user clicks this notification, this function is called
        print("clicked notification when app opened");
        print(receivedNotification);
        print(receivedNotification.title);
        print(receivedNotification.body);
        print(receivedNotification.payload);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        // When the app is closed and the user receives a notification
        // and the user clicks on the notification. This function is called.
        print("clicked notification when app closed");
        print("onMessageOpenedApp: $message");
        print("notification: ${message.notification}");
        print("title: ${message.notification!.title}");
        print("body: ${message.notification!.body}");
        print("body: ${message.data}");
      });

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

    Debug debug = Debug();
    await debug.debugPost(firebaseToken!).then((val) {
      if (val) {
        print("registration send");
      } else {
        print("sending a debug post FAILED!");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("foreground on message: $message");
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String data = message.data.toString();
      Debug debug = Debug();
      String sendString = "foreground: ";
      sendString = sendString + "   title $title";
      sendString = sendString + "   body $body";
      sendString = sendString + "   data $data";
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
      showCustomSoundNotification();
    });
  }

  getFirebaseToken() {
    return this.firebaseToken;
  }

  @override
  void dispose() {
    print("disposing the notification util");
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }

  void firebaseBackgroundInitialization() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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


Future<void> showCustomSoundNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 6,
          channelKey: "custom_sound",
          title: 'It\'s time to morph!',
          body: 'It\'s time to go save the world!',
          color: Color(int.parse("0xFF039BE5")),
          payload: {
            'secret': 'the green ranger and the white ranger are the same person'
          }));
}
