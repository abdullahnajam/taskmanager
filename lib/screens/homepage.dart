import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/api/time_api.dart';
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
  double secondsInMinutes=0;
  Future<void> getHours()async{
    int hours=await SharedPrefHelper.getSeconds();
    setState(() {
      secondsInMinutes= (hours/24)*60;
      print('hour $hours seconds $secondsInMinutes');
      //secondsInMinutes=hours==16?40:80;
    });
  }
  @override
  void initState() {
    super.initState();

    getHours().then((value)async{
      int hour=await SharedPrefHelper.getSeconds();


      double newMinutesInHour=(24/hour) * 60;

      Timer.periodic(const Duration(milliseconds: 200), (Timer t) {
        if(mounted){
          setState(() {
            DateTime now = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second
            );
            if(hour==24){
              clock= '${now.hour} : ${now.minute} : ${now.second}';
            }
            else{

              //print(now);
              double totalSeconds = (now.hour * 3600 + now.minute * 60 + now.second)/(newMinutesInHour*60);



              //double decimalValue = totalSeconds/(newMinutesInHour*60);
              int hours = totalSeconds.floor();
              //print('total $totalSeconds');
              double remainingMinutesDecimal = (totalSeconds - hours) * 60;
              int minutes = remainingMinutesDecimal.floor();
              double seconds = ((remainingMinutesDecimal - minutes) * 60);

              clock= '$hours : $minutes : ${seconds.toInt()}';
            }
          });
        }
      });
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
                            if(FirebaseAuth.instance.currentUser==null){
                              await UserApi.instance.logout().then((value){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));

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
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()));

                              }).onError((error, stackTrace){
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: error.toString(),
                                );
                              });
                            }
                          },
                          child: const Row(
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
                          child: const Row(
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
