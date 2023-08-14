import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

import '../provider/user_data_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {



  String clock='';
  @override
  void initState() {
    super.initState();
    FirebaseApi.setScheduleStatus();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {




      int normalSeconds = 3600; // 1 hour in normal time
      double convertedMinutes = normalSeconds / 80;

      int hours = convertedMinutes ~/ 60;
      int minutes = convertedMinutes.toInt() % 60;
      int seconds = (convertedMinutes % 1 * 60).toInt();

      DateTime originalDateTime = DateTime.now();
      DateTime convertedDateTime= DateTime.now();
      if (mounted) {
        setState(() {



          int totalSeconds = DateTime.now().hour * 3600 +
              DateTime.now().minute * 80 +
              DateTime.now().second;
          int newMinutes = (totalSeconds / 80).floor();
          int newSeconds = (totalSeconds % 80);
          DateTime convertedDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            newMinutes ~/ 60,
            newMinutes % 60,
            newSeconds,
          );
          clock= clockFormat.format(convertedDateTime);
          print('orignal $originalDateTime - converted $convertedDateTime');
        });
      }
    });
  }


  String _getTime() {
    final now = DateTime.now();
    /*int totalSeconds = (now.hour * 3600) + (now.minute * 80) + now.second;
    int displayHour = totalSeconds ~/ 3600;
    int displayMinute = (totalSeconds % 3600) ~/ 80;
    int displaySecond = totalSeconds % 80;*/

    int totalSeconds = now.hour * 3600 + now.minute * 60 + now.second;
    int adjustedTotalSeconds = (totalSeconds * 80) ~/ 60;
    int displayHour = adjustedTotalSeconds ~/ 3600;
    int displayMinute = (adjustedTotalSeconds % 3600) ~/ 60;
    int displaySecond = adjustedTotalSeconds % 60;
    return '${displayHour.toString().padLeft(2, '0')} : ${displayMinute.toString().padLeft(2, '0')} : ${displaySecond.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    //_timer.cancel();
    super.dispose();
  }

  void updateTime() {
    DateTime now = DateTime.now();
    int totalSeconds = now.minute * 80 + now.second;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 80;
    int seconds = totalSeconds % 80;

    setState(() {
      //currentTime = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);



    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.settings,color: Colors.transparent,),
                  const Text('Home'),
                  PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      if(provider.userId!='none')
                        PopupMenuItem(
                        value: 1,

                        child: InkWell(
                          onTap: ()async{
                            Navigator.pop(context);
                            if(FirebaseAuth.instance.currentUser!=null){
                              await UserApi.instance.logout().then((value){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));

                              }).onError((error, stackTrace){
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: error.toString(),
                                );
                              });
                            }
                            else{
                              await FirebaseAuth.instance.signOut().then((value){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));

                              }).onError((error, stackTrace){
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: error.toString(),
                                );
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(

                                width: 10,
                              ),
                              Text("Logout")
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        // row has two child icon and text
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            showSettingDialog(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.access_time_rounded),
                              SizedBox(
                                // sized box with width 10
                                width: 10,
                              ),
                              Text("Change Time")
                            ],
                          ),
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.settings,color: Colors.black,),
                    color: Colors.white,
                    elevation: 2,
                  ),

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(clock,style: const TextStyle(fontFamily: 'Digital',fontWeight: FontWeight.w500,fontSize: 60),)

                ],
              ),
            ),

            Expanded(child: Container()),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(7)
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to use this app?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                  SizedBox(height: 5,),
                  Text(loremIpsum),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
