import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  _loadWidget() async {

    var _duration = Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async{
    await FirebaseApi.updateTodos();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/splash.gif',height: 300,fit: BoxFit.cover,),
      ),
    );
  }
}
