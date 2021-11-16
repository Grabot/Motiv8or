import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motivator/pages/home_page.dart';
import 'package:motivator/util/notification_util.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {

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
        title: const Text("page 1"),
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
            color: Colors.red,
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