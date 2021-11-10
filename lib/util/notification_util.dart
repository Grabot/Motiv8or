import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart' as Utils
    show DateUtils;

Future<bool> requestPermissionToSendNotifications(BuildContext context) async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowed){
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xfffbfbfb),
          title: Text('Get Notified!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Allow Awesome Notifications to send you beautiful notifications!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: (){ Navigator.pop(context); },
                child: Text(
                  'Later',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )
            ),
            TextButton(
              onPressed: () async {
                isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
                Navigator.pop(context);
              },
              child: Text(
                'Allow',
                style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
    );
  }
  return isAllowed;
}

// Future<bool> redirectToPermissionsPage() async {
//   await AwesomeNotifications().showNotificationConfigPage();
//   return await AwesomeNotifications().isNotificationAllowed();
// }

Future<void> showCustomSoundNotification(int id) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: "custom_sound",
          title: 'It\'s time to morph!',
          body: 'It\'s time to go save the world!',
          color: Colors.yellow,
          payload: {
            'secret': 'the green ranger and the white ranger are the same person'
          }));
}

Future<void> cancelNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}

Future<void> showNotificationAtScheduleCron(
    DateTime scheduleTime) async {
  String timeZoneIdentifier = AwesomeNotifications.localTimeZoneIdentifier;
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'scheduled',
        title: 'Just in time!',
        body: 'This notification was schedule to shows at ' +
            (Utils.DateUtils.parseDateToString(scheduleTime.toLocal()) ?? '?') +
            ' $timeZoneIdentifier (' +
            (Utils.DateUtils.parseDateToString(scheduleTime.toUtc()) ?? '?') +
            ' utc)',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://assets/images/delivery.jpeg',
        payload: {'uuid': 'uuid-test'}
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime));
}
