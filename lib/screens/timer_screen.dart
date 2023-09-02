import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/api/notification_service.dart';
import 'package:taskmanager/api/sqlite_helper.dart';
import 'package:taskmanager/provider/user_data_provider.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../api/shared_pref_api.dart';
import '../api/time_api.dart';
import '../models/time_block_model.dart';
import '../provider/timer_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  


  //SqliteHelper sqliteHelper=SqliteHelper();

  void startCountdown(int hours, int minutes, int seconds) {
    final provider = Provider.of<TimerProvider>(context, listen: false);

    int totalSeconds = hours * 60 * secondsInMinutes + minutes * secondsInMinutes + seconds;

    StreamSubscription? timerSubscription;
    void updateTimer(Timer timer) async{
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
            provider.setState(0);

            NotificationService.showAlarmNotification(id: 1, title: 'Timer Finished', scheduleTime: DateTime.now().add(Duration(seconds: 5)));
            await FirebaseApi.updateTimeBlock(context);
            provider.setTodo(null);
          }
          //timerSubscription!.cancel();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      print(uri.host);
      /*showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
            title: Text('App started from HomeScreenWidget'),
            content: Text('Here is the URI: $uri | ${uri.host}'),
          ));*/
      if(uri.host=='homeone'){
        final provider = Provider.of<TimerProvider>(context, listen: false);
        provider.setSelectedHours(1);
        provider.setHours(1);
        provider.setStartPlaying(true);
      }
      else if(uri.host=='hometwo'){
        final provider = Provider.of<TimerProvider>(context, listen: false);
        provider.setSelectedHours(2);
        provider.setHours(2);
        provider.setStartPlaying(true);
      }
      else if(uri.host=='homethree'){
        final provider = Provider.of<TimerProvider>(context, listen: false);
        provider.setSelectedHours(3);
        provider.setHours(3);
        provider.setStartPlaying(true);
      }

      else if(uri.host=='homefour'){
        final provider = Provider.of<TimerProvider>(context, listen: false);
        provider.setSelectedHours(4);
        provider.setHours(4);
        provider.setStartPlaying(true);
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          HomeWidget.getWidgetData<String>('homeOne');
          _checkForWidgetLaunch();
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
                          if(provider.remainingHours==0 && provider.remainingMinutes==0 && provider.remainingSeconds==0){
                            //print('selected todo ${provider.model!.id}');
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              backgroundColor: primaryColor,
                              title: 'Set Time',
                              text: 'Please set a time for timer either from the presets or from the add dialog',

                              confirmBtnColor: primaryColor,

                            );
                          }
                          else{
                            if(provider.model==null){
                              showSelectTodoDialog(context);
                            }
                            else{
                              setState(() {
                                provider.setState(1);
                                ////sqliteHelper.insert(context,provider.model!);
                                startCountdown(provider.remainingHours, provider.remainingMinutes, provider.remainingSeconds);

                              });
                            }

                          }


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
                            provider.setTodo(null);
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
          provider.setTodo(null);
          /*startPlaying=true;
          state=0;*/

          /*remainingHours=selectedHours;
          remainingMinutes=0;
          remainingSeconds=0;*/

          provider.setHours(selectedHours);
          provider.setSelectedHours(selectedHours);
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

  Future<void> showSelectTodoDialog(BuildContext context) async {
    final user = Provider.of<UserDataProvider>(context, listen: false);

    TimeBlockModel? selectedTodo;
    List<TimeBlockModel> timeBlocks=[];

    await FirebaseApi.getTimeBlocks(user.userId!).then((data) {
      timeBlocks = data;
      if(data.isNotEmpty)
        selectedTodo=data.first;

    });


    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){

            return Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                height: MediaQuery.of(context).size.height*0.35,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Consumer<TimerProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(10),
                            children: [
                              Row(
                                children: [
                                  const Expanded(child: Text('Select Todo',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),),
                                  InkWell(
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black,
                                      child: Icon(Icons.close,color: greyColor,size: 12,),
                                    ),
                                    onTap: ()=>Navigator.pop(context),
                                  ),
                                ],
                              ),
                              if(timeBlocks.length==0)
                                Container(
                                  height: MediaQuery.of(context).size.height*0.2,
                                  child: Center(
                                    child: Text('No Time Block Found'),
                                  ),
                                )
                              else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: timeBlocks.length,
                                itemBuilder: (BuildContext context,int index){
                                  return ListTile(
                                    onTap: (){
                                      setState(() {
                                        selectedTodo=timeBlocks[index];
                                      });
                                    },
                                    title: Text(timeBlocks[index].todo),
                                    trailing: selectedTodo!=null?
                                    selectedTodo!.id==timeBlocks[index].id?const Icon(Icons.check_circle,color: primaryColor,):const SizedBox(height: 1,width: 1,):const SizedBox(height: 1,width: 1,),
                                  );
                                },
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        if(selectedTodo!=null){
                                          provider.setTodo(selectedTodo!);
                                          provider.setState(1);
                                          setState(() {

                                            startCountdown(provider.remainingHours, provider.remainingMinutes, provider.remainingSeconds);

                                          });
                                          Navigator.pop(context);
                                        }
                                        else{
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            backgroundColor: primaryColor,
                                            title: 'Todo Not Selected',
                                            text: 'Please select a todo from list to continue',
                                            confirmBtnColor: primaryColor,

                                          );
                                        }


                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: primaryColor,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Select",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){

                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Cancel",style: Theme.of(context).textTheme.button!.apply(color: Colors.grey.shade700),),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                        )



                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
