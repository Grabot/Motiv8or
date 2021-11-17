import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motivator/services/debug.dart';
import 'package:motivator/util/shared.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:developer';


class NotificationUtil {
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
    if (firebaseToken == null) {

      debug = Debug();
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        log("awesome notifciation allowed? $isAllowed");
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });

      AwesomeNotifications().createdStream.listen((receivedNotification) {
        String? createdSourceText =
        AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
        log('$createdSourceText notification created');
      });

      AwesomeNotifications().displayedStream.listen((receivedNotification) {
        String? createdSourceText =
        AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
        log('$createdSourceText notification displayed');
      });

      AwesomeNotifications().dismissedStream.listen((receivedAction) {
        String? dismissedSourceText = AssertUtils.toSimpleEnumString(
            receivedAction.dismissedLifeCycle);
        log('Notification dismissed on $dismissedSourceText');
      });

      AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification) {
        // notification when the user has the app opened
        // It receives it via firebase messaging and creates a notification
        // Because firebase will not create one when the app is opened.
        // If the user clicks this notification, this function is called
        log("clicked notification when app opened");
        log("title: ${receivedNotification.title}");
        log("body: ${receivedNotification.body}");
        log("data: ${receivedNotification.payload}");
        sendDebugString("foreground:   ", receivedNotification.title, receivedNotification.body, receivedNotification.payload.toString());
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        // When the app is closed and the user receives a notification
        // and the user clicks on the notification. This function is called.
        log("clicked notification when app closed");
        log("notification: ${message.notification}");
        log("title: ${message.notification!.title}");
        log("body: ${message.notification!.body}");
        log("data: ${message.data}");
        sendDebugString("background:   ", message.notification!.title, message.notification!.body, message.data.toString());
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        log("we have clicked on the message I think");
        log("message: $message");
      });

      await initializeFirebaseService();
      this.screen.update();
    }
  }

  Future<void> initializeFirebaseService() async {
    await Firebase.initializeApp();
    firebaseToken = await FirebaseMessaging.instance.getToken();

    log("registration id: \n$firebaseToken");
    if (firebaseToken == null || firebaseToken == "") {
      return;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("foreground on message: $message");
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String data = message.data.toString();
      showCustomSoundNotification(title!, body!, data);
    });
  }

  sendFirebaseToken() {
    Debug debug = Debug();
    debug.debugPost(firebaseToken!).then((val) {
      if (val) {
        log("registration send");
      } else {
        log("sending a debug post FAILED!");
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
          log("we have successfully send an update");
        } else {
          log("sending a debug post FAILED!");
        }
      });
    });
  }

  getFirebaseToken() {
    return this.firebaseToken;
  }

  @override
  void dispose() {
    log("disposing the notification util");
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
  }

  Future<bool> redirectToPermissionsPage() async {
    await AwesomeNotifications().showNotificationConfigPage();
    return await AwesomeNotifications().isNotificationAllowed();
  }

  void firebaseBackgroundInitialization() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
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
  log("background message: $message");
  HelperFunction.getTestString().then((val) {
    if (val == null || val == "") {
      sendString = "no test string:  " + sendString;
    } else {
      sendString = val + ":   " + sendString;
    }
    debug.debugPost(sendString).then((val) {
      if (val) {
        log("we have successfully send an update");
      } else {
        log("sending a debug post FAILED!");
      }
    });
  });
}


Future<void> showCustomSoundNotification(String title, String body, var data) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 6,
          channelKey: "custom_sound",
          title: title,
          body: body,
          color: Color(int.parse("0xFF039BE5")),
          payload: {
            'data': data
          }));
}
