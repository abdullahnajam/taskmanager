import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/notification_service.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../api/shared_pref_api.dart';
import '../provider/timer_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  


  void runAlarm()async{
    await Alarm.init();

    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: DateTime.now(),
      assetAudioPath: 'assets/audio/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeMax: true,
      notificationTitle: 'Timer finished',
      enableNotificationOnKill: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  void startCountdown(int hours, int minutes, int seconds) {
    final provider = Provider.of<TimerProvider>(context, listen: false);

    int totalSeconds = hours * 60 * secondsInMinutes + minutes * secondsInMinutes + seconds;

    StreamSubscription? timerSubscription;
    void updateTimer(Timer timer) {
      if(provider.state==1){
        if (totalSeconds > 0) {
          totalSeconds--;
          setState(() {
            provider.setHours(totalSeconds ~/ (60 * secondsInMinutes));
            provider.setMinutes((totalSeconds % (60 * secondsInMinutes)) ~/ secondsInMinutes);
            provider.setSeconds(totalSeconds % secondsInMinutes);
            
            /*remainingHours = totalSeconds ~/ (60 * secondsInMinutes);
            remainingMinutes = (totalSeconds % (60 * secondsInMinutes)) ~/ secondsInMinutes;
            remainingSeconds = totalSeconds % secondsInMinutes;*/
          });

        } else {
          print('Countdown Finished!');
          if(provider.startPlaying){
            setState(() {
              provider.setStartPlaying(false);
            });
            NotificationService.showAlarmNotification(id: 1, title: 'Timer Finished', scheduleTime: DateTime.now());

          }
          timerSubscription!.cancel();
        }
      }
      else if(provider.state==0){
        timer.cancel();

      }
    }


    const oneSecond = Duration(seconds: 1);
    if(provider.state==1){
      Timer.periodic(oneSecond, updateTimer);
    }

  }


  int secondsInMinutes=0;
  Future<void> getHours()async{
    int hours=await SharedPrefHelper.getSeconds();
    setState(() {
      secondsInMinutes=((hours/24)*60).toInt();
    });
  }
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<TimerProvider>(context, listen: false);
      if(provider.state==1 && provider.startPlaying){
        provider.setState(2);
        //startCountdown(provider.remainingHours, provider.remainingMinutes, provider.remainingSeconds);

      }

      getHours();
    });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WakelockPlus.disable();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showStartTimerDialog(context);
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360)
        ),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: SafeArea(
        child: Consumer<TimerProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${provider.remainingHours} : ${provider.remainingMinutes} : ${provider.remainingSeconds}',style: const TextStyle(fontFamily: 'Digital',fontWeight: FontWeight.w500,fontSize: 60),),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            provider.setState(1);
                            startCountdown(provider.remainingHours, provider.remainingMinutes, provider.remainingSeconds);

                          });

                        },
                        child: Image.asset('assets/images/play.png',height: 30,color: provider.state==1?Colors.grey:Colors.black,),

                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            provider.setState(2);
                          });
                        },
                        child: Image.asset('assets/images/pause.png',height: 30,color: provider.state==2?Colors.grey:Colors.black,),

                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            provider.setState(0);
                            provider.setHours(0);
                            provider.setMinutes(0);
                            provider.setSeconds(0);
                            /*remainingHours=0;
                            remainingMinutes=0;
                            remainingSeconds=0;*/
                          });

                        },
                        child: Image.asset('assets/images/stop.png',height: 30,color: provider.state==0?Colors.grey:Colors.black,),

                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  children: [
                    Expanded(
                        child: hourWidget(1)
                    ),
                    Expanded(
                        child: hourWidget(2)
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                        child: hourWidget(3)
                    ),
                    Expanded(
                        child: hourWidget(5)
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  Widget hourWidget(int selectedHours){
    return InkWell(
      onTap: (){
        final provider = Provider.of<TimerProvider>(context, listen: false);

        setState(() {
          provider.setStartPlaying(true);
          provider.setState(0);
          /*startPlaying=true;
          state=0;*/

          /*remainingHours=selectedHours;
          remainingMinutes=0;
          remainingSeconds=0;*/

          provider.setHours(selectedHours);
          provider.setMinutes(0);
          provider.setSeconds(0);


        });
      },
      child: Container(
          height: MediaQuery.of(context).size.height*0.15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black)
          ),
          child: Center(
            child: Text('$selectedHours Hour',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
          )
      ),
    );
  }
}
