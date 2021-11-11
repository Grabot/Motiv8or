

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motiv8tor/services/debug.dart';
import 'package:motiv8tor/util/shared.dart';

import '../constants.dart';

class NotificationService {
  static NotificationService _instance = new NotificationService._internal();

  String? firebaseToken;
  var screen;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  initialize() {
    if (StringUtils.isNullOrEmpty(firebaseToken)) {
      initializeFirebaseService();
    }
  }

  setScreen(var screen) {
    this.screen = screen;
  }

  Future<void> initializeFirebaseService() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    print("we are going to initialize the firebase service here");
    firebaseToken = await messaging.getToken(
      // https://stackoverflow.com/questions/54996206/firebase-cloud-messaging-where-to-find-public-vapid-key
      vapidKey: vapidKey,
    ) ??
        '';

    if (StringUtils.isNullOrEmpty(firebaseToken, considerWhiteSpaceAsEmpty: true)) {
      return;
    }

    print('Firebase token: $firebaseToken');

    this.screen.updateFirebaseToken(firebaseToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print("message: $message");
      String sendString = "foreground message: " + message.data.toString();
      HelperFunction.getTestString().then((val) {
        if (val == null || val == "") {
          sendString = "no test string!   " + sendString;
        } else {
          sendString = val + ":   " + sendString;
        }
        Debug debug = new Debug();
        debug.debugPost(sendString).then((val) {
          if (val) {
            this.screen.updateDebugString("foreground message from firebase!");
          } else {
            print("sending a debug post FAILED!");
          }
        });
      });
    });
  }

  getFirebaseAppToken() {
    return firebaseToken;
  }
}