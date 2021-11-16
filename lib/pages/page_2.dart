import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/util/notification_util.dart';

import 'home_page.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {

  @override
  void initState() {
    NotificationUtil notificationUtil = NotificationUtil();
    notificationUtil.initialize(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("page 2"),
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
            color: Colors.blue,
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