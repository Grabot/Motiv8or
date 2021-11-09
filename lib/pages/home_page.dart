import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motiv8tor/common_widgets/led_light.dart';
import 'package:motiv8tor/common_widgets/simple_button.dart';
import 'package:motiv8tor/util/notification_util.dart';
import 'package:motiv8tor/util/socket_services.dart';
import 'package:numberpicker/numberpicker.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _firebaseAppToken = '';
  //String _oneSignalToken = '';

  bool delayLEDTests = false;

  bool notificationsAllowed = false;

  String packageName = 'motiv8tor.nl.awesome_notifications_example';
  String testString1 = "";
  String testString2 = "debug string 2";
  String testString3 = "debug string 3";

  Future<DateTime?> pickScheduleDate(BuildContext context,
      {required bool isUtc}) async {
    TimeOfDay? timeOfDay;
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now();
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 365)));

    if (newDate != null) {
      timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now.add(Duration(minutes: 1))),
      );

      if (timeOfDay != null) {
        return isUtc
            ? DateTime.utc(newDate.year, newDate.month, newDate.day,
                timeOfDay.hour, timeOfDay.minute)
            : DateTime(newDate.year, newDate.month, newDate.day, timeOfDay.hour,
                timeOfDay.minute);
      }
    }
    return null;
  }

  int _pickAmount = 50;
  Future<int?> pickBadgeCounter(BuildContext context, int initialAmount) async {
    setState(() => _pickAmount = initialAmount);

    // show the dialog
    return showDialog<int?>(
      context: context,
      builder: (BuildContext context) =>
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) =>
            AlertDialog(
              title: Text("Choose the new badge amount"),
              content: NumberPicker(
                value: _pickAmount,
                minValue: 0,
                maxValue: 9999,
                onChanged: (newValue) =>
                  setModalState(() => _pickAmount = newValue)
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(_pickAmount);
                  },
                ),
              ],
            )
        )
    );
  }

  var socket;

  @override
  void initState() {
    socket = SocketServices();
    socket.setScreen(this);
    socket.initialize();

    initializeFirebaseService();

    AwesomeNotifications().createdStream.listen((receivedNotification) {
      String? createdSourceText =
          AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
      Fluttertoast.showToast(msg: '$createdSourceText notification created');
    });

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      String? createdSourceText =
          AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
      Fluttertoast.showToast(msg: '$createdSourceText notification displayed');
    });

    AwesomeNotifications().dismissedStream.listen((receivedAction) {
      String? dismissedSourceText = AssertUtils.toSimpleEnumString(
          receivedAction.dismissedLifeCycle);
      Fluttertoast.showToast(
          msg: 'Notification dismissed on $dismissedSourceText');
    });

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      print("awesome notification are allowed? $isAllowed");
      setState(() {
        notificationsAllowed = isAllowed;
      });

      if (!isAllowed) {
        // Just ask on app open?
        // isAllowed = await requestPermissionToSendNotifications(context);
      }
    });

    testString1 = "socket is NOT connected";
    if (socket.isConnected()) {
      testString1 = "socket is connected";
    }

    setState(() {
    });
    super.initState();
  }

  update() {
    if (mounted) {
      print("going to update");
      testString1 = "socket is NOT connected";
      if (socket.isConnected()) {
        testString1 = "socket is connected";
      }
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initializeFirebaseService() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    print("we are going to initialize the firebase service here");
    String firebaseAppToken = await messaging.getToken(
          // https://stackoverflow.com/questions/54996206/firebase-cloud-messaging-where-to-find-public-vapid-key
          vapidKey: vapidKey,
        ) ??
        '';

    if (StringUtils.isNullOrEmpty(firebaseAppToken,
        considerWhiteSpaceAsEmpty: true)) return;

    if (!mounted) {
      _firebaseAppToken = firebaseAppToken;
    } else {
      setState(() {
        _firebaseAppToken = firebaseAppToken;
      });
    }

    print('Firebase token: $firebaseAppToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (
          // This step (if condition) is only necessary if you pretend to use the
          // test page inside console.firebase.google.com
          !StringUtils.isNullOrEmpty(message.notification?.title,
                  considerWhiteSpaceAsEmpty: true) ||
              !StringUtils.isNullOrEmpty(message.notification?.body,
                  considerWhiteSpaceAsEmpty: true)) {
        print('Message also contained a notification: ${message.notification}');

        String? imageUrl;
        imageUrl ??= message.notification!.android?.imageUrl;
        imageUrl ??= message.notification!.apple?.imageUrl;

        // https://pub.dev/packages/awesome_notifications#notification-types-values-and-defaults
        Map<String, dynamic> notificationAdapter = {
          NOTIFICATION_CONTENT: {
            NOTIFICATION_ID: Random().nextInt(2147483647),
            NOTIFICATION_CHANNEL_KEY: 'basic_channel',
            NOTIFICATION_TITLE: message.notification!.title,
            NOTIFICATION_BODY: message.notification!.body,
            NOTIFICATION_LAYOUT:
                StringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
            NOTIFICATION_BIG_PICTURE: imageUrl
          }
        };

        AwesomeNotifications()
            .createNotificationFromJsonData(notificationAdapter);
      } else {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      }
    });
  }

  String PAGE_FIREBASE_TESTS = '/firebase-tests';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData themeData = Theme.of(context);

    bool status = !StringUtils.isNullOrEmpty(_firebaseAppToken);

    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Debug App for socket and notfications',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              )),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          children: <Widget>[
            /* ******************************************************************** */

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(color: Colors.black87),
                              text: 'Firebase status:\n',
                              children: [
                                TextSpan(
                                    style: TextStyle(
                                        color: status
                                            ? Colors.green
                                            : Colors.redAccent),
                                    text: (status ? 'Available' : 'Unavailable') +
                                        '\n'),
                                WidgetSpan(child: LedLight(status))
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
                'Permission to send Notifications',
              textAlign: TextAlign.center,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      Text(notificationsAllowed ? 'Allowed' : 'Not allowed',
                          style: TextStyle(
                              color: notificationsAllowed
                                  ? Colors.green
                                  : Colors.red)),
                      LedLight(notificationsAllowed)
                    ],
                  )
                ]),
            SimpleButton('Request permission',
                onPressed: () => requestPermissionToSendNotifications(context).then(
                    (isAllowed) =>
                      setState(() {
                        notificationsAllowed = isAllowed;
                      })
                )
            ),
            SimpleButton('Open notifications permission page',
                onPressed: () => redirectToPermissionsPage().then(
                    (isAllowed) =>
                      setState(() {
                        notificationsAllowed = isAllowed;
                      })
                )
            ),
            SimpleButton('Show notification with custom sound',
                onPressed: () {
                  showCustomSoundNotification(6);
                }),
            SimpleButton('Cancel notification',
                backgroundColor: Colors.red,
                labelColor: Colors.white,
                onPressed: () => cancelNotification(6)),
            SimpleButton('Schedule notification with local time zone',
                onPressed: () async {
              DateTime? pickedDate =
                  await pickScheduleDate(context, isUtc: false);
              if (pickedDate != null) {
                showNotificationAtScheduleCron(pickedDate);
              }
            }),
            SimpleButton('Schedule notification with utc time zone',
                onPressed: () async {
              DateTime? pickedDate =
                  await pickScheduleDate(context, isUtc: true);
              if (pickedDate != null) {
                showNotificationAtScheduleCron(pickedDate);
              }
            }),
            SizedBox(
              height:50
            ),
            Text(
              "eigen dubug spull"
            ),
            SimpleButton('make connection via socket',
              onPressed: () async {
                socket = SocketServices();
                socket.setScreen(this);
                socket.initialize();
                print("pressed the socket connection button");
              }),
            SimpleButton('check if socket connection is still live',
                onPressed: () async {
                  print("pressed the socket check button");
                }),
            SimpleButton('test socket connection, join room 1',
                onPressed: () async {
                  print("pressed the join room 1 button");
                }),
            SimpleButton('test socket connection, leave room 1',
                onPressed: () async {
                  print("pressed the lave room 1 button");
                }),
            SimpleButton('Send random socket message',
                onPressed: () async {
                  print("pressed the send random socket message");
                }),
            SimpleButton('update state',
                onPressed: () async {
                  this.update();
                  setState(() {
                  });
                }),
            Text(
              "debug 1: $testString1"
            ),
            Text(
                "debug 2: $testString2"
            ),
            Text(
                "debug 3: $testString3"
            )
          ],
        ));
  }
}
