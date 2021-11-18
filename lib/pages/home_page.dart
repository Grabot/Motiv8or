import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/objects/bro_bros.dart';
import 'package:motivator/pages/page_1.dart';
import 'package:motivator/pages/page_2.dart';
import 'package:motivator/pages/page_3.dart';
import 'package:motivator/pages/page_4.dart';
import 'package:motivator/services/socket_service.dart';
import 'package:motivator/util/notification_util.dart';
import 'package:app_settings/app_settings.dart';
import 'package:motivator/util/storage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? firebaseToken = "";

  late NotificationUtil notificationUtil;
  late SocketService socket;
  late Storage storage;

  bool isAllowed = false;

  bool bro1Added = false;
  bool bro2Added = false;
  bool bro3Added = false;
  bool bro4Added = false;

  @override
  void initState() {
    notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);
    notificationUtil.requestIOSPermissions();

    firebaseToken = notificationUtil.getFirebaseToken();

    socket = SocketService();

    storage = Storage();
    storage.database.then((value) {
      storage.selectBroBros(1).then((value) {
        if (value != null) {
          setState(() {
            bro1Added = true;
          });
        }
      });
      storage.selectBroBros(2).then((value) {
        if (value != null) {
          setState(() {
            bro2Added = true;
          });
        }
      });
      storage.selectBroBros(3).then((value) {
        if (value != null) {
          setState(() {
            bro3Added = true;
          });
        }
      });
      storage.selectBroBros(4).then((value) {
        if (value != null) {
          setState(() {
            bro4Added = true;
          });
        }
      });
    });

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
            ElevatedButton(
                onPressed: () {
                  notificationUtil.showNotification();
                },
                child: const Text("click here for sound notification!")
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  notificationUtil.sendFirebaseToken();
                },
                child: const Text("send the firebase token!")
            ),
            SizedBox(height:10),
            ElevatedButton(
                onPressed: AppSettings.openNotificationSettings,
                child: Text('Open notification Settings'),
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageOne()));
                      },
                      child: const Text("Page 1")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageTwo()));
                      },
                      child: const Text("Page 2")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageThree()));
                      },
                      child: const Text("Page 3")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const PageFour()));
                      },
                      child: const Text("Page 4")
                  ),
                ),
              ],
            ),
            Text("(red indicates the bro is not yet added, green means it's added)"),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  color: bro1Added ? Colors.green : Colors.red,
                  child: ElevatedButton(
                      onPressed: () {
                        BroBros broBros1 = BroBros(
                            1,
                            "bro 1",
                            "the first bro",
                            "steve",
                            "0x123456",
                            0,
                            "2020120123123",
                            "1_6",
                            0,
                            0,
                            0
                        );
                        storage.addBroBros(broBros1).then((value) {
                          storage.selectBroBros(1).then((value) {
                            if (value != null) {
                              setState(() {
                                bro1Added = true;
                              });
                            }
                          });
                        });
                      },
                      child: const Text("Add Bro 1")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  color: bro2Added ? Colors.green : Colors.red,
                  child: ElevatedButton(
                      onPressed: () {
                        BroBros broBros2 = BroBros(
                            2,
                            "bro 2",
                            "the second bro",
                            "harry",
                            "0x234567",
                            0,
                            "2020120123123",
                            "2_6",
                            0,
                            0,
                            0
                        );
                        storage.addBroBros(broBros2).then((value) {
                          storage.selectBroBros(2).then((value) {
                            if (value != null) {
                              setState(() {
                                bro2Added = true;
                              });
                            }
                          });
                        });
                      },
                      child: const Text("Add Bro 2")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  color: bro3Added ? Colors.green : Colors.red,
                  child: ElevatedButton(
                      onPressed: () {
                        BroBros broBros3 = BroBros(
                            3,
                            "bro 3",
                            "the third bro",
                            "max",
                            "0x345678",
                            0,
                            "2020120123123",
                            "3_6",
                            0,
                            0,
                            0
                        );
                        storage.addBroBros(broBros3).then((value) {
                          storage.selectBroBros(3).then((value) {
                            if (value != null) {
                              setState(() {
                                bro3Added = true;
                              });
                            }
                          });
                        });
                      },
                      child: const Text("Add Bro 3")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  color: bro4Added ? Colors.green : Colors.red,
                  child: ElevatedButton(
                      onPressed: () {
                        BroBros broBros4 = BroBros(
                            4,
                            "bro 4",
                            "the fourth bro",
                            "Nanne",
                            "0x456789",
                            0,
                            "2020120123123",
                            "4_6",
                            0,
                            0,
                            0
                        );
                        storage.addBroBros(broBros4).then((value) {
                          storage.selectBroBros(4).then((value) {
                            if (value != null) {
                              setState(() {
                                bro4Added = true;
                              });
                            }
                          });
                        });
                      },
                      child: const Text("Add Bro 4")
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

  updateFirebaseToken(String firebaseToken) {
    setState(() {
      this.firebaseToken = firebaseToken;
    });
  }
}
