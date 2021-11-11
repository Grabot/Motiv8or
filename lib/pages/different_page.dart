import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motiv8tor/common_widgets/led_light.dart';
import 'package:motiv8tor/common_widgets/simple_button.dart';
import 'package:motiv8tor/util/notification_service.dart';
import 'package:motiv8tor/util/notification_util.dart';
import 'package:motiv8tor/util/socket_services.dart';
import 'package:numberpicker/numberpicker.dart';

import '../constants.dart';

class DifferentPage extends StatefulWidget {
  @override
  _DifferentPageState createState() =>
      _DifferentPageState();
}

class _DifferentPageState extends State<DifferentPage> {

  var socket;
  var notify;

  String? _firebaseAppToken;

  @override
  void initState() {
    _firebaseAppToken = null;

    socket = SocketServices();
    socket.setScreen(this);
    socket.initialize();

    notify = NotificationService();
    notify.setScreen(this);
    notify.initialize();

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
          ],
        ));
  }

  void updateFirebaseToken(String firebaseToken) {
    setState(() {
      _firebaseAppToken = firebaseToken;
    });
  }

  void messageReceivedSolo(var data) {
    print("received a message SOLO!");
    print(data);
  }

  void messageReceivedChat(var data) {
    print("received a message CHAT!");
    print(data);
  }
}
