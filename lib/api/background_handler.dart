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

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
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
      ?.createNotificationChannel(channel);

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
  String time='';
  SqliteHelper sqliteHelper=SqliteHelper();
  bool isPlaying=false;
  bool changed=false;
  int totalSeconds=0;
  int hour=0;
  int minute=0;
  int second=0;
  Map<String,dynamic> row={
    'id':0,
    'userId':'',
    'todoId':'',
    'todo':'',
    'state':0,
    'maxHour':0,
    'maxMin':0,
    'doneHour':0,
    'doneMin':0,
    'timerHour':0,
    'timerMin':0,
    'timerSec':0,
    'timerRemainingHour':0,
    'timerRemainingMin':0,
    'timerRemainingSec':0,
    'customHour':0,
    'customSecondsInMinute':0,
  };
  SqlDataModel sqlDataModel=SqlDataModel.fromMap(row);
  Database db = await SqliteHelper.getDatabase();
  var box = await Hive.openBox('timer');
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    print(timer.tick);
    int state=await box.get('state');
    print('hive state $state');
    //int state=0;
    /*var box = await Hive.openBox('timer');
    int state=await box.get('state');

    */if(state==1){



      if(sqlDataModel.state!=1){
        changed=false;
      }
      if(!changed){
        await db.transaction((txn) async {
          List<Map<String, dynamic>> data=await txn.query('Timer');
          sqlDataModel=SqlDataModel.fromMap(data.last);

        });
        hour=sqlDataModel.timerHour;
        minute=sqlDataModel.timerMin;
        second=sqlDataModel.timerSec;
        print('data fetched ${sqlDataModel.state}');
        totalSeconds = sqlDataModel.timerHour * 60 * sqlDataModel.customSecondsInMinute + sqlDataModel.timerMin * sqlDataModel.customSecondsInMinute + sqlDataModel.timerSec;

      }
      if(sqlDataModel.state==1){
        changed=true;
        isPlaying=true;
        if (totalSeconds > 0) {
          totalSeconds--;
          hour=totalSeconds ~/ (60 * sqlDataModel.customSecondsInMinute);
          minute=(totalSeconds % (60 * sqlDataModel.customSecondsInMinute)) ~/ sqlDataModel.customSecondsInMinute;
          second=(totalSeconds % sqlDataModel.customSecondsInMinute).toInt();
          time='$hour : $minute : $second';
          print(time);
          HomeWidget.saveWidgetData<String>('timerTextView', time);
          await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider');

          //await sqliteHelper.update(sqlDataModel);
          /*provider.setHours(totalSeconds ~/ (60 * secondsInMinutes));
          provider.setMinutes((totalSeconds % (60 * secondsInMinutes)) ~/ secondsInMinutes);
          provider.setSeconds(totalSeconds % secondsInMinutes);*/

        } else {
          isPlaying=false;
          changed=false;
          sqlDataModel.state=0;
          await sqliteHelper.update(sqlDataModel);
          print('Timer Finished');

          NotificationService.showAlarmNotification(id: 1, title: 'Timer Finished', scheduleTime: DateTime.now().add(Duration(seconds: 5)));
          await SharedPrefHelper.setStartCountDown(false);
          if (service is AndroidServiceInstance) {
            if (await service.isForegroundService()) {
              print('foreground service');
            }
            else{
              FirebaseApi.updateTimeBlockInBackground(sqlDataModel);
            }
          }

          //timerSubscription!.cancel();
        }
      }
    }


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
      Database db = await SqliteHelper.getDatabase();



      Map<String,dynamic> row={
        'id':0,
        'userId':sqlDataModel.userId,
        'todoId':sqlDataModel.id,
        'todo':sqlDataModel.todo,
        'state':0,
        'maxHour':sqlDataModel.maxHour,
        'maxMin':sqlDataModel.maxMin,
        'doneHour':sqlDataModel.doneHour,
        'doneMin':sqlDataModel.doneMin,
        'timerHour':0,
        'timerMin':0,
        'timerSec':0,
        'timerRemainingHour':0,
        'timerRemainingMin':0,
        'timerRemainingSec':0,
        'customHour':sqlDataModel.customHour,
        'customSecondsInMinute':sqlDataModel.customSecondsInMinute,
      };
      await db.insert('Timer', row);
      service.stopSelf();
    });

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    Timer.periodic(const Duration(seconds: 1), (timer) async {
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
    });

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