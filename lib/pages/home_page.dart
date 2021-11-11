import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:motiv8tor/common_widgets/led_light.dart';
import 'package:motiv8tor/common_widgets/simple_button.dart';
import 'package:motiv8tor/pages/different_page.dart';
import 'package:motiv8tor/util/notification_service.dart';
import 'package:motiv8tor/util/notification_util.dart';
import 'package:motiv8tor/util/shared.dart';
import 'package:motiv8tor/util/socket_services.dart';
import 'package:numberpicker/numberpicker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _firebaseAppToken = '';

  bool delayLEDTests = false;

  bool notificationsAllowed = false;

  var socket;
  var notify;

  String debugString = "";

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

  @override
  void initState() {
    socket = SocketServices();
    socket.setScreen(this);
    socket.initialize();

    notify = NotificationService();
    notify.setScreen(this);
    notify.initialize();

    _firebaseAppToken = "";

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      print("awesome notification are allowed? $isAllowed");
      setState(() {
        notificationsAllowed = isAllowed;
      });
    });

    super.initState();
  }

  update() {
    if (mounted) {
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

  @override
  Widget build(BuildContext context) {
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
                                        color: !StringUtils.isNullOrEmpty(_firebaseAppToken)
                                            ? Colors.green
                                            : Colors.redAccent),
                                    text: (!StringUtils.isNullOrEmpty(_firebaseAppToken) ? 'Available' : 'Unavailable') +
                                        '\n'),
                                WidgetSpan(child: LedLight(!StringUtils.isNullOrEmpty(_firebaseAppToken)))
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
                setState(() {
                });
                print("pressed the socket connection button");
              }),
            Text(
              'Socket connection alive?',
              textAlign: TextAlign.center,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      Text(socket.isConnected() ? 'Connected' : 'Not connected',
                          style: TextStyle(
                              color: socket.isConnected()
                                  ? Colors.green
                                  : Colors.red)),
                      LedLight(socket.isConnected())
                    ],
                  )
                ]),
            SimpleButton('test socket connection, join solo room (bro home)',
                onPressed: () async {
                  print("pressed the join solo room button");
                  socket.joinRoomSolo();
                }),
            SimpleButton('test socket connection, join chat room (a chat)',
                onPressed: () async {
                  print("pressed the join room 1 button");
                  socket.joinRoomChat();
                }),
            SimpleButton('test socket connection, leave solo room (bro home)',
                onPressed: () async {
                  print("pressed the leave solo room button");
                  socket.leaveRoom("room_1");
                }),
            SimpleButton('test socket connection, leave chat room (a chat)',
                onPressed: () async {
                  print("pressed the leave room 1 button");
                  socket.leaveRoom("1_2");
                }),
            SimpleButton('test socket connection, send message in chat',
                onPressed: () async {
                  print("pressed the send message button");
                  socket.sendMessage("test", "1_2");
                }),
            SimpleButton('test socket connection, send message with couple seconds delay',
                onPressed: () async {
                  print("pressed the send message with delay button");
                  socket.sendMessageWithDelay("test", "1_2");
                }),
            SimpleButton('go to a different page!',
                onPressed: () async {
                  print("going to a different page");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => DifferentPage()));
                }),
            SimpleButton('send registration id to server',
                onPressed: () async {
                  print("sending registration id to server");
                  sendRegistration("room_1");
                }),
            Text(
                'Latest socked string: $debugString',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                )),
            SimpleButton('set test string shared preferencees',
                onPressed: () async {
                  await HelperFunction.setTestString("test string was set");
                }),
            SimpleButton('empty test string',
                onPressed: () async {
                  await HelperFunction.setTestString("");
                }),
          ],
        ));
  }

  void updateFirebaseToken(String firebaseToken) {
    print("we have found a token");
    print(firebaseToken);
    setState(() {
      _firebaseAppToken = firebaseToken;
    });
  }

  void messageReceivedSolo(var data) {
    print("received a message SOLO!");
    print(data);
    updateDebugString(data);
  }

  void messageReceivedChat(var data) {
    print("received a message CHAT!");
    print(data);
    updateDebugString(data);
  }

  void sendRegistration(String room) {
    print("firebase token?");
    print(_firebaseAppToken);
    socket.sendRegistrationId(_firebaseAppToken, room);
  }

  void updateDebugString(String debugString) {
    setState(() {
      this.debugString = debugString;
    });
  }
}
