import 'package:flutter/material.dart' hide DateUtils;
import 'package:motiv8tor/util/notification_service.dart';
import 'package:motiv8tor/util/socket_services.dart';

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
