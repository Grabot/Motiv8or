import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motivator/services/debug.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? firebaseToken = "";

  bool notificationsAllowed = false;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {

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

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      print("awesome notifciation allowed? $isAllowed");
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    initializeFirebaseService();

    super.initState();
  }

  Future<void> initializeFirebaseService() async {

    await Firebase.initializeApp();
    firebaseToken = await FirebaseMessaging.instance.getToken();

    print("registration id: \n$firebaseToken");
    if (StringUtils.isNullOrEmpty(firebaseToken, considerWhiteSpaceAsEmpty: true)) {
      return;
    }

    Debug debug = Debug();
    await debug.debugPost(firebaseToken!).then((val) {
      if (val) {
        setState(() {
          
        });
        print("registration send");
      } else {
        print("sending a debug post FAILED!");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  showCustomSoundNotification(6);
                },
                child: Text("click here for sound notification!")
            ),
            SizedBox(height: 30),
            TextButton(
                onPressed: () {
                  print("pressed the second button!");
                },
                child: Text("click here for another debug thingy!")
            ),
            SizedBox(height: 30),
            Text(
              'firebase token: \n$firebaseToken',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCustomSoundNotification(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "custom_sound",
            title: 'It\'s time to morph!',
            body: 'It\'s time to go save the world!',
            color: Colors.yellow,
            payload: {
              'secret': 'the green ranger and the white ranger are the same person'
            }));
  }

}
