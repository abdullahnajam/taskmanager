import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:taskmanager/api/firebase_api.dart';
import 'package:taskmanager/models/time_block_model.dart';
import 'package:taskmanager/provider/user_data_provider.dart';
import 'package:taskmanager/screens/utils/constants.dart';

import '../../api/notification_service.dart';

Future<void> showSettingDialog(BuildContext context) async {


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
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Consumer<UserDataProvider>(
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
                                Expanded(child: Text('Time Setting',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),),
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
                            const SizedBox(height: 10,),
                            const Text(loremIpsum),
                            const SizedBox(height: 10,),
                            ListTile(
                              onTap:(){
                                provider.setTime(16);
                              },
                              leading: provider.time==16?Image.asset('assets/images/ic_radio_on.png',color: Colors.orange,):Image.asset('assets/images/ic_radio_off.png'),
                              title: const Text('16 Hours'),
                            ),
                            ListTile(
                              onTap:(){
                                provider.setTime(32);
                              },
                              leading: provider.time==32?Image.asset('assets/images/ic_radio_on.png',color: Colors.orange,):Image.asset('assets/images/ic_radio_off.png'),
                              title: const Text('32 Hours'),
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: primaryColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text("Save",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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

Future<void> showAddTimeBlockDialog(BuildContext context) async {
  var _todoController=TextEditingController();
  int _currentValue = 0;
  int _currentValue1 = 0;
  final _formKey = GlobalKey<FormState>();
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
              height: MediaQuery.of(context).size.height*0.47,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        //color: Color(0xffC3C1C1).withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),

                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:const Text('Add Timeblock',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                              ),
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
                          const SizedBox(height: 10,),

                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text('Thing to do:'),

                            children: <Widget>[
                              TextFormField(
                                controller: _todoController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a time';
                                  }
                                  return null;
                                },
                                decoration: new InputDecoration(
                                    hintText: "Enter Todos",
                                ),
                              )
                            ],
                          ),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text('Time to invest'),


                            children: <Widget>[
                              /*Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('hh : mm :ss',style: TextStyle(color: Colors.grey.shade700),),
                                  ),
                                ],
                              ),*/
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  NumberPicker(
                                    value: _currentValue,
                                    minValue: 0,
                                    itemHeight: 25,
                                    itemWidth: 50,
                                    maxValue: 32,
                                    textStyle: TextStyle(fontSize: 12),
                                    selectedTextStyle: TextStyle(fontSize: 15),
                                    onChanged: (value) => setState(() => _currentValue = value),
                                  ),
                                  NumberPicker(
                                    value: _currentValue1,
                                    minValue: 0,
                                    itemHeight: 25,
                                    itemWidth: 50,
                                    maxValue: 59,
                                    textStyle: TextStyle(fontSize: 12),
                                    selectedTextStyle: TextStyle(fontSize: 15),
                                    onChanged: (value) => setState(() => _currentValue1 = value),
                                  ),

                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: ()async{
                                    if(_formKey.currentState!.validate()){

                                      final ProgressDialog pr = ProgressDialog(context: context);
                                      pr.show(max: 100, msg: 'Adding');

                                      final provider = Provider.of<UserDataProvider>(context, listen: false);

                                      await FirebaseFirestore.instance.collection('timeblock').add({
                                        "userId":provider.userId,
                                        "todo":_todoController.text,
                                        "maxHour":_currentValue,
                                        "maxMin":_currentValue1,
                                        //"maxSec":_currentValue2,
                                        "doneHour":0,
                                        "doneMin":0,
                                        //"doneSec":0,
                                      }).then((value){
                                        pr.close();
                                        Navigator.pop(context);
                                      }).onError((error, stackTrace){
                                        pr.close();
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: error.toString(),
                                        );
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: primaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("Save",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showAddTodoDialog(BuildContext context) async {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  var _startController=TextEditingController();
  var _endController=TextEditingController();


  Future<void> _selectStartDate(BuildContext context) async {

    DatePicker.showTimePicker(context,
        showTitleActions: true,

        currentTime: DateTime.now(),
        onChanged: (date) {
          print('change $date');
          selectedStartDate=date;
          _startController.text=dtf.format(date);
        }, onConfirm: (date) {
        selectedStartDate=date;
        _startController.text=dtf.format(date);
        },

    );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DatePicker.showTimePicker(context,
      showTitleActions: true,
      currentTime: DateTime.now(),
      onChanged: (date) {
        print('change $date');
        selectedEndDate=date;
        _endController.text=dtf.format(date);
      }, onConfirm: (date) {
        selectedEndDate=date;
        _endController.text=dtf.format(date);
      },

    );
  }
  TimeBlockModel? selectedObject;
  final provider = Provider.of<UserDataProvider>(context, listen: false);
  List<TimeBlockModel> dropdownData = [];
  await FirebaseApi.getTimeBlocks(provider.userId!).then((data) {
    dropdownData = data;
    if(data.isNotEmpty)
      selectedObject=data.first;
  });


  final _formKey = GlobalKey<FormState>();
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
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   /* Container(
                      decoration: const BoxDecoration(
                        //color: Color(0xffC3C1C1).withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )
                      ),
                      child: Stack(
                        children: [

                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.only(top: 5,right: 10,bottom: 5),
                              child: InkWell(
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.close,color: greyColor,size: 12,),
                                ),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),*/
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(10),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: const Text('Add things to do with notification',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                              ),
                              Container(
                                //padding: const EdgeInsets.only(top: 5,right: 5,bottom: 5),
                                child: InkWell(
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.close,color: greyColor,size: 12,),
                                  ),
                                  onTap: ()=>Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Text('Which thing to do'),

                            children: <Widget>[
                              /*FutureBuilder<List<TimeBlockModel>>(
                                  future: FirebaseApi.getTimeBlocks(provider.userId!),
                                  builder: (context, AsyncSnapshot<List<TimeBlockModel>> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    else {
                                      if (snapshot.hasError) {
                                        print("error ${snapshot.error}");
                                        return const Center(
                                          child: Text("Something went wrong"),
                                        );
                                      }
                                      else if(snapshot.data!.isEmpty){
                                        return const Center(
                                          child: Text("No Workshops"),
                                        );
                                      }

                                      else {

                                        return  DropdownButton<TimeBlockModel>(
                                          value: selectedObject,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedObject = newValue;
                                            });
                                          },
                                          items: snapshot.data!.map((obj) {
                                            return DropdownMenuItem<TimeBlockModel>(
                                              value: obj,
                                              child: Text(obj.todo),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    }
                                  }
                              ),*/
                              DropdownButton<TimeBlockModel>(
                                value: selectedObject,
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedObject = newValue;
                                  });
                                },
                                items: dropdownData.map((obj) {
                                  return DropdownMenuItem<TimeBlockModel>(
                                    value: obj,
                                    child: Text(obj.todo),
                                  );
                                }).toList(),
                              ),
                              TextFormField(
                                onTap: (){
                                  _selectStartDate(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a time';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                controller: _startController,
                                decoration: new InputDecoration(
                                  hintText: "Start Time",

                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                onTap: (){
                                  _selectEndDate(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a time';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                controller: _endController,
                                decoration: new InputDecoration(
                                  hintText: "End Time",

                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10,),
                          Row(
                            children: [


                              Expanded(

                                child: InkWell(
                                  onTap: ()async{
                                    if(_formKey.currentState!.validate()){
                                      if(selectedObject!=null){
                                        int notificationId=0;
                                        final ProgressDialog pr = ProgressDialog(context: context);
                                        pr.show(max: 100, msg: 'Adding Reminder');
                                        await FirebaseFirestore.instance.collection('reminder').get().then((QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                            notificationId++;
                                          });
                                        });
                                        final provider = Provider.of<UserDataProvider>(context, listen: false);

                                        await FirebaseFirestore.instance.collection('reminder').add({
                                          "userId":provider.userId,
                                          "startTime":selectedStartDate.millisecondsSinceEpoch,
                                          "endTime":selectedEndDate.millisecondsSinceEpoch,
                                          "notificationId":notificationId,
                                          "todo":selectedObject!.todo,
                                          "todoId":selectedObject!.id,
                                          "status":'in progress',
                                        }).then((value)async{
                                          DateTime start=await FirebaseApi.convertToStandardTime(selectedStartDate);
                                          DateTime end=await FirebaseApi.convertToStandardTime(selectedEndDate);
                                          await Alarm.init();
                                          final alarmSettings = AlarmSettings(
                                            id: notificationId,
                                            dateTime: selectedStartDate,
                                            assetAudioPath: 'assets/audio/alarm.mp3',
                                            loopAudio: true,
                                            vibrate: true,
                                            volumeMax: true,
                                            notificationTitle: selectedObject!.todo,
                                            enableNotificationOnKill: true,
                                          );
                                          final alarmSettings2 = AlarmSettings(
                                            id: notificationId,
                                            dateTime: selectedEndDate,
                                            assetAudioPath: 'assets/audio/alarm.mp3',
                                            loopAudio: true,
                                            vibrate: true,
                                            volumeMax: true,
                                            notificationTitle: selectedObject!.todo,
                                            enableNotificationOnKill: true,
                                          );
                                          await Alarm.set(alarmSettings: alarmSettings);
                                          await Alarm.set(alarmSettings: alarmSettings2);
                                          NotificationService().showScheduledNotification(notificationId, "Pelvic Reminder",  selectedEndDate);
                                          pr.close();
                                          Navigator.pop(context);
                                        }).onError((error, stackTrace){
                                          pr.close();
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: error.toString(),
                                          );
                                        });
                                      }
                                      else{
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Please select a todo",
                                        );
                                      }
                                    }


                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: primaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("Save",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
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
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> showStartTimerDialog(BuildContext context) async {

  int _currentValue = 22;
  int _currentValue1 = 3;
  int _currentValue2 = 3;
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
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: const Text('Start Timer',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                            ),
                            Container(
                              //padding: const EdgeInsets.only(top: 5,right: 5,bottom: 5),
                              child: InkWell(
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.close,color: greyColor,size: 12,),
                                ),
                                onTap: ()=>Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10,),
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text('Which thing to do'),

                          children: <Widget>[
                            TextField(
                              decoration: new InputDecoration(
                                hintText: "Enter Todos",

                              ),
                            )
                          ],
                        ),
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text('How much to invest'),


                          children: <Widget>[
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text('hh : mm :ss',style: TextStyle(color: Colors.grey.shade700),),
                                ),
                              ],
                            ),*/
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                NumberPicker(
                                  value: _currentValue,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 50,
                                  maxValue: 32,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue = value),
                                ),
                                NumberPicker(
                                  value: _currentValue1,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 50,
                                  maxValue: 80,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue1 = value),
                                ),
                                NumberPicker(
                                  value: _currentValue2,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 50,
                                  maxValue: 80,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue2 = value),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container()
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Save",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                ),
                              )
                            ),

                          ],
                        )
                      ],
                    ),
                  )



                ],
              ),
            ),
          );
        },
      );
    },
  );
}
