import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/objects/bro_bros.dart';
import 'package:motivator/objects/broup.dart';
import 'package:motivator/objects/chat.dart';
import 'package:motivator/services/navigation_service.dart';
import 'package:motivator/util/locator.dart';
import 'package:motivator/constants/route_paths.dart' as routes;
import 'package:motivator/util/socket_util.dart';
import 'package:motivator/util/notification_util.dart';
import 'package:app_settings/app_settings.dart';
import 'package:motivator/util/storage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final NavigationService _navigationService = locator<NavigationService>();

  String? firebaseToken = "";
  String? debugCode = "";

  late NotificationUtil notificationUtil;
  late SocketUtil socket;
  late Storage storage;

  bool isAllowed = false;

  List<bool> broAdded = [];
  bool broupAdded = false;

  @override
  void initState() {
    notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);
    notificationUtil.requestIOSPermissions();
    
    // index start at 0 but we will process it from 1,
    // we add five entries because we want to make the id match the index
    // This is not the way you should do it, but this is just for testing.
    broAdded.add(false);
    broAdded.add(false);
    broAdded.add(false);
    broAdded.add(false);
    broAdded.add(false);

    firebaseToken = notificationUtil.getFirebaseToken();

    socket = SocketUtil();

    storage = Storage();
    storage.database.then((value) {
      storage.fetchAllChats().then((value) {
        print("fetched all");
        print(value);
        for (Chat chat in value) {
          if (chat.isBroup == 1) {
            // We only have one broup as test. If it's in the db set value true.
            broupAdded = true;
          } else {
            broAdded[chat.id] = true;
          }
        }
        setState(() {
        });
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
                  notificationUtil.showNotification("notify button", "heey, you pressed the button!", 1, 0);
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
                        storage.selectChat(1, 0).then((value) {
                          if (value != null) {
                            _navigationService.navigateTo(routes.BroRoute, arguments: value);
                          } else {
                            setState(() {
                              debugCode = "Bro 1 is not added";
                            });
                          }
                        });
                      },
                      child: const Text("Page 1")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        storage.selectChat(2, 0).then((value) {
                          if (value != null) {
                            _navigationService.navigateTo(routes.BroRoute, arguments: value);
                          } else {
                            setState(() {
                              debugCode = "Bro 2 is not added";
                            });
                          }
                        });
                      },
                      child: const Text("Page 2")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        storage.selectChat(3, 0).then((value) {
                          if (value != null) {
                            _navigationService.navigateTo(routes.BroRoute, arguments: value);
                          } else {
                            setState(() {
                              debugCode = "Bro 3 is not added";
                            });
                          }
                        });
                      },
                      child: const Text("Page 3")
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: ElevatedButton(
                      onPressed: () {
                        storage.selectChat(4, 0).then((value) {
                          if (value != null) {
                            _navigationService.navigateTo(routes.BroRoute, arguments: value);
                          } else {
                            setState(() {
                              debugCode = "Bro 4 is not added";
                            });
                          }
                        });
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
                  color: broAdded[1] ? Colors.green : Colors.red,
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
                        storage.addChat(broBros1).then((value) {
                          storage.selectChat(1, 0).then((value) {
                            if (value != null) {
                              setState(() {
                                broAdded[1] = true;
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
                  color: broAdded[2] ? Colors.green : Colors.red,
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
                        storage.addChat(broBros2).then((value) {
                          storage.selectChat(2, 0).then((value) {
                            if (value != null) {
                              setState(() {
                                broAdded[2] = true;
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
                  color: broAdded[3] ? Colors.green : Colors.red,
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
                        storage.addChat(broBros3).then((value) {
                          storage.selectChat(3, 0).then((value) {
                            if (value != null) {
                              setState(() {
                                broAdded[3] = true;
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
                  color: broAdded[4] ? Colors.green : Colors.red,
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
                        storage.addChat(broBros4).then((value) {
                          storage.selectChat(4, 0).then((value) {
                            if (value != null) {
                              setState(() {
                                broAdded[4] = true;
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
            Container(
              width: MediaQuery.of(context).size.width/3,
              child: ElevatedButton(
                  onPressed: () {
                    storage.selectChat(1, 1).then((value) {
                      if (value != null) {
                        _navigationService.navigateTo(routes.BroupRoute, arguments: value);
                      } else {
                        setState(() {
                          debugCode = "Broup is not added";
                        });
                      }
                    });
                  },
                  child: const Text("Broup Page")
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              color: broupAdded ? Colors.green : Colors.red,
              child: ElevatedButton(
                onPressed: () {
                  Broup broup = Broup(
                      1,
                      "broup",
                      "the only broup",
                      "Brocreators",
                      "0x956789",
                      0,
                      "2020120123123",
                      "broup_1",
                      0,
                      0,
                      1
                  );
                  storage.addChat(broup).then((value) {
                    storage.selectChat(1, 1).then((value) {
                      if (value != null) {
                        setState(() {
                          broupAdded = true;
                        });
                      }
                    });
                  });
                },
                child: const Text("Add the broup")
              ),
            ),
            SizedBox(height: 30),
            Text(
              'firebase token: \n$firebaseToken',
            ),
            Text(
              'possible debug code: \n$debugCode',
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
