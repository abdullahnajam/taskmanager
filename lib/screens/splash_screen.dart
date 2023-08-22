import 'dart:async';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/navigators/bottom_nav.dart';
import 'package:taskmanager/screens/navigators/tabbed_bottom_nav.dart';

import '../provider/user_data_provider.dart';

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
    await FirebaseApi.setScheduleStatus();
    //await FirebaseApi.updateTodos();
    //print(UserApi.instance.toString());
    if(FirebaseAuth.instance.currentUser!=null){
      print('here');
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      provider.setUserId(FirebaseAuth.instance.currentUser!.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TabbedBottomNavBar()));

    }
    else if(await AuthApi.instance.hasToken()){
      print('kk');
      final provider = Provider.of<UserDataProvider>(context, listen: false);

      kakao.User user=await kakao.UserApi.instance.me();
      provider.setUserId(user.id.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TabbedBottomNavBar()));

    }
    else{
      print('else');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));

    }

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
