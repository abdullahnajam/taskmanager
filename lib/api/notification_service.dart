import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../screens/utils/constants.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }



  NotificationService._internal();





  Future<void> showScheduledNotification(int id, String title,DateTime interval) async {

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: title,
          notificationLayout: NotificationLayout.BigText,
          wakeUpScreen: true,
          autoDismissible: false,
        ),
        schedule: NotificationCalendar.fromDate(date: interval));
  }

}
