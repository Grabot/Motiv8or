

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motiv8tor/services/debug.dart';

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
      Debug debug = new Debug();
      debug.debugPost("foreground: " + message.data.toString()).then((val) {
        if (val) {
          this.screen.updateDebugString("foreground message from firebase!");
        } else {
          print("sending a debug post FAILED!");
        }
      });
    });
  }

  getFirebaseAppToken() {
    return firebaseToken;
  }
}