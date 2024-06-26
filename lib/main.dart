import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/sqlite_helper.dart';
import 'package:taskmanager/provider/timer_provider.dart';
import 'package:taskmanager/provider/user_data_provider.dart';
import 'package:taskmanager/screens/splash_screen.dart';

String timer='';
void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.setAppGroupId('group.fluttercounter');
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  await Firebase.initializeApp(
    /*options: const FirebaseOptions(
        apiKey: "AIzaSyDYBppmJeQuHYQ1HQvz7qvKnhk3wMgJJCY",
        authDomain: "osio-c091e.firebaseapp.com",
        projectId: "osio-c091e",
        storageBucket: "osio-c091e.appspot.com",
        messagingSenderId: "285830947753",
        appId: "1:285830947753:web:402c7dafc0144a43245ab8"
    ),*/
  );
  KakaoSdk.init(
    nativeAppKey: 'bd639476d08a32b3f0ab2fa8508f10fd',
    javaScriptAppKey: '297b1ae49caa1d59664cc44a24980c1e',
  );
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.black,
            enableVibration: true,
            playSound: true,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            ledColor: Colors.white),
        NotificationChannel(
            channelGroupKey: 'alarm_channel_group',
            channelKey: 'alarm_channel',
            channelName: 'Alarm notifications',
            channelDescription: 'Notification channel for alarm tests',
            defaultColor: Colors.black,
            enableVibration: true,
            playSound: true,
            soundSource: 'resource://raw/alarm', // Replace with the custom alarm sound file
            ledColor: Colors.white),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group'),
        NotificationChannelGroup(
            channelGroupKey: 'alarm_channel_group',
            channelGroupName: 'Alarm group')
      ],
      debug: true
  );
  await Hive.initFlutter();

  SqliteHelper sqliteHelper=SqliteHelper();
  sqliteHelper.initDatabase();
  runApp(const MyApp());
  requestNotificationPermissions();
}

Future<void> backgroundCallback(uri) async {
  if (uri.host == 'updatecounter') {
    print(uri.host);
    int _counter = 0;
    /*await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0)
        .then((value) {
      _counter = value as int;
      _counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', _counter);
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');*/
  }
}

/*Future<void> backgroundCallback(Uri uri) async {
  if (uri.host == 'addHour') {
    timer='1';
    final timer = Provider.of<TimerProvider>(context, listen: false);

  }
}*/


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(),
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),


      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',

        home: SplashScreen(),
      )
    );
  }
}

Future<void> requestNotificationPermissions() async {
  // Request permissions
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    // On Android, request permission
    if (await AwesomeNotifications().requestPermissionToSendNotifications()) {
      print('Notification permissions granted');
    } else {
      print('Notification permissions denied');
    }

    // On iOS, request permission
    if (await AwesomeNotifications().requestPermissionToSendNotifications()) {
      print('Notification permissions granted');
    } else {
      print('Notification permissions denied');
    }
  } else {
    print('Notification permissions already granted');
  }
}

