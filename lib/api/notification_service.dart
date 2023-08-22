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

  static Future<void> showAlarmNotification({required int id,required String title, required DateTime scheduleTime}) async {



    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          channelKey: 'basic_channel',
          wakeUpScreen: true,
          category: NotificationCategory.Alarm,
          id: id,
          displayOnBackground: true,
          displayOnForeground: true,

          title: title,
          body: 'Tap to dismiss',
          backgroundColor: primaryColor,
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar.fromDate(date: scheduleTime, repeats: true,allowWhileIdle:true,preciseAlarm: true));



  }


}
