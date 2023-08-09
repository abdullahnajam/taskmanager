import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:taskmanager/screens/splash_screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
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
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

