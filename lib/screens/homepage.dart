import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  String currentTime = '';

  @override
  void initState() {
    super.initState();
    updateTime();
    Timer.periodic(Duration(seconds: 80), (timer) {
      updateTime();
    });
  }

  void updateTime() {
    DateTime now = DateTime.now();
    int totalSeconds = now.minute * 80 + now.second;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 80;
    int seconds = totalSeconds % 80;

    setState(() {
      currentTime = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  String _getTime(int hourDuration) {
    final now = DateTime.now();
    int totalMinutes = (now.hour * hourDuration) + now.minute;
    int displayHour = totalMinutes ~/ hourDuration;
    int displayMinute = totalMinutes % hourDuration;
    return '${displayHour.toString().padLeft(2, '0')}:${displayMinute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings,color: Colors.transparent,),
                  Text('Home'),
                  InkWell(
                    onTap: (){
                      showSettingDialog(context);
                    },
                    child: Icon(Icons.settings,color: Colors.black,),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('32 : 41 : 80',style: TextStyle(fontFamily: 'Digital',fontWeight: FontWeight.w500,fontSize: 60),)

                ],
              ),
            ),

            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Column(
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
