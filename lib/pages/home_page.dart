import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/pages/page_1.dart';
import 'package:motivator/pages/page_2.dart';
import 'package:motivator/pages/page_3.dart';
import 'package:motivator/pages/page_4.dart';
import 'package:motivator/util/notification_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firebaseToken = "";

  late NotificationUtil notificationUtil;

  @override
  void initState() {
    notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);
    super.initState();
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
                  showCustomSoundNotification("custom title", "custom body", "");
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
