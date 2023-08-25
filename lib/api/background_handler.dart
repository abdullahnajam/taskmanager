import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/api/sqlite_helper.dart';
import 'package:taskmanager/models/sql_data_model.dart';

import '../provider/user_data_provider.dart';
import 'notification_service.dart';



Future<void> initializeService(BuildContext context) async {
  final service = FlutterBackgroundService();

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

  SqliteHelper sqliteHelper=SqliteHelper();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    List<Map<String, dynamic>> data=await sqliteHelper.queryAll();
    SqlDataModel sqlDataModel=SqlDataModel.fromMap(data.last);
    int totalSeconds = sqlDataModel.timerHour * 60 * sqlDataModel.customSecondsInMinute + sqlDataModel.timerMin * sqlDataModel.customSecondsInMinute + sqlDataModel.timerSec;

    if(sqlDataModel.state==1){
      if (totalSeconds > 0) {
        totalSeconds--;
        /*provider.setHours(totalSeconds ~/ (60 * secondsInMinutes));
        provider.setMinutes((totalSeconds % (60 * secondsInMinutes)) ~/ secondsInMinutes);
        provider.setSeconds(totalSeconds % secondsInMinutes);*/

      } else {
        NotificationService.showAlarmNotification(id: 1, title: 'Timer Finished', scheduleTime: DateTime.now().add(Duration(seconds: 5)));
        //FirebaseApi.updateTimeBlock(context);
        //timerSubscription!.cancel();
      }
    }

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
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