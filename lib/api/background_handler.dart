import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/api/sqlite_helper.dart';
import 'package:taskmanager/models/sql_data_model.dart';
import 'package:home_widget/home_widget.dart';
import '../provider/user_data_provider.dart';
import 'firebase_api.dart';
import 'notification_service.dart';



Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /*const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings()//IOSInitializationSettings(),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);*/

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  int hours=await SharedPrefHelper.getSeconds();
  double newMinutesInHour=(24/hours) * 60;
  Timer.periodic(const Duration(seconds: 1), (timer) async {

    String time='';


    int totalSeconds =
        ( DateTime.now().hour * (3600)) +
            (DateTime.now().minute * 60) +
            DateTime.now().second;
    print('1 $totalSeconds');


    double decimalValue = totalSeconds/(newMinutesInHour*60);
    int hour = decimalValue.floor();
    double remainingMinutesDecimal = (decimalValue - hour) * 60;
    int minutes = remainingMinutesDecimal.floor();
    int seconds = ((remainingMinutesDecimal - minutes) * 60).floor();



    time= '$hour : $minutes : $seconds';

    HomeWidget.saveWidgetData<String>('timerTextView', time);
    await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider');


    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        print('foreground 123');
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        print('background 123');
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) async{

      service.stopSelf();
    });

    /*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();*/

    /*Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          flutterLocalNotificationsPlugin.show(
            notificationId,
            'Timer',
            time,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );

          // if you don't using custom notification, uncomment this
          // service.setForegroundNotificationInfo(
          //   title: "My App Service",
          //   content: "Updated at ${DateTime.now()}",
          // );
        }
      }


      //await accelerometerEvents.drain();



      /// you can see this log in logcat
      //print('BACKGROUND SERVICE: $liveStepCount');

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });*/

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}