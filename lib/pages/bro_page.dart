import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/objects/bro_bros.dart';
import 'package:motivator/util/notification_util.dart';

import 'home_page.dart';

class BroPage extends StatefulWidget {

  final BroBros bro;

  const BroPage({
    Key? key,
    required this.bro
  }) : super(key: key);

  @override
  State<BroPage> createState() => _BroPageState();
}

class _BroPageState extends State<BroPage> {

  BroBros? bro;
  @override
  void initState() {
    NotificationUtil notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);

    this.bro = widget.bro;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("page of bro"),
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
              color: Colors.green,
              child: Text("This is ${bro!.chatName}  also know as ${bro!.alias}")
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