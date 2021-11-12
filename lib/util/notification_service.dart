import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    if (firebaseToken == null) {
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

    if (firebaseToken== null || firebaseToken == "") {
      return;
    }

    print('Firebase token: $firebaseToken');

    this.screen.updateFirebaseToken(firebaseToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print("message: $message");
      print("notification1? : ${message.notification}");
      print("notification2? : ${message.notification!.title}");
      print("notification3? : ${message.notification!.body}");
      String sendString = "foreground message:         title: ${message.notification!.title}        body:${message.notification!.body}       data in the notification:${message.data}";
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


Future<bool> requestPermissionToSendNotifications(BuildContext context) async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowed){
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xfffbfbfb),
          title: Text('Get Notified!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Allow Awesome Notifications to send you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: (){ Navigator.pop(context); },
                child: Text(
                  'Later',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )
            ),
            TextButton(
              onPressed: () async {
                isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
                Navigator.pop(context);
              },
              child: Text(
                'Allow',
                style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
    );
  }
  return isAllowed;
}

Future<void> showCustomSoundNotification(int id) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: "custom_sound",
          title: 'It\'s time to morph!',
          body: 'It\'s time to go save the world!',
          color: Colors.yellow,
      ));
}