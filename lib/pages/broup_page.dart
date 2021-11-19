import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/objects/bro_bros.dart';
import 'package:motivator/objects/broup.dart';
import 'package:motivator/util/notification_util.dart';

import 'home_page.dart';

class BroupPage extends StatefulWidget {

  final Broup? broup;

  const BroupPage({
    Key? key,
    required this.broup
  }) : super(key: key);

  @override
  State<BroupPage> createState() => _BroupPageState();
}

class _BroupPageState extends State<BroupPage> {

  Broup? broup;

  Color? broColor;

  @override
  void initState() {
    NotificationUtil notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);

    print("opened broup page");
    print(widget.broup);
    this.broup = widget.broup;

    // If there is no bro found the color is black, this should not occur.
    broColor = Colors.black;
    if (this.broup != null) {
      if (this.broup!.id == 1) {
        broColor = Colors.green;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Here you can chat with a whole broup"),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: broColor,
              child: broup == null ? Text("Big error") : Text("This is ${broup!.chatName}  also know as ${broup!.alias}")
            ),
          ),
        )
    );
  }

  update() {
    setState(() {
    });
  }
}
