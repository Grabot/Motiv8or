import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivator/pages/page_1.dart';
import 'package:motivator/pages/page_2.dart';
import 'package:motivator/pages/page_3.dart';
import 'package:motivator/pages/page_4.dart';
import 'package:motivator/util/notification_util.dart';
import 'package:notification_permissions/notification_permissions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firebaseToken = "";

  late NotificationUtil notificationUtil;

  Map<String, String> channelMap = {
    "id": "custom_sound",
    "name": "Brocast notification",
    "description": "Custom Bro Sound for notifications"
  };

  static const MethodChannel _channel = MethodChannel('nl.motivator.motivator/channel_test');

  bool isAllowed = false;

  @override
  void initState() {
    notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);

    createNotificationChannel();

    // show the dialog/open settings screen
    NotificationPermissions.requestNotificationPermissions(
        iosSettings: const NotificationSettingsIos(
            sound: true, badge: true, alert: true))
        .then((_) {
      // when finished, check the permission status
      setState(() {
        isAllowed = true;
        print("notifications allowed");
      });
    });

    super.initState();
  }

  createNotificationChannel() async {
    try {
      await _channel.invokeMethod('createNotificationChannel', channelMap);
      print("channel created");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test app for notifications and socket connection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  // showCustomSoundNotification("custom title", "custom body", "");
                },
                child: const Text("click here for sound notification!")
            ),
            SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  notificationUtil.sendFirebaseToken();
                },
                child: const Text("send the firebase token!")
            ),
            SizedBox(height:10),
            TextButton(
              onPressed: () {
                // notificationUtil.redirectToPermissionsPage();
              },
              child: Text("open the notification permission page")
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageOne()));
                      },
                      child: const Text("Page 1")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageTwo()));
                      },
                      child: const Text("Page 2")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageThree()));
                      },
                      child: const Text("Page 3")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageFour()));
                      },
                      child: const Text("Page 4")
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'firebase token: \n$firebaseToken',
            ),
          ],
        ),
      ),
    );
  }

  update() {
    setState(() {
      firebaseToken = notificationUtil.getFirebaseToken();
    });
  }
}
