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
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/models/time_block_model.dart';
import 'package:taskmanager/provider/user_data_provider.dart';
import 'package:taskmanager/screens/navigators/bottom_nav.dart';
import 'package:taskmanager/screens/utils/constants.dart';

import '../../api/notification_service.dart';
import '../../api/time_api.dart';
import '../../models/time_model.dart';
import '../../provider/timer_provider.dart';
import '../navigators/tabbed_bottom_nav.dart';

Future<void> showSettingDialog(BuildContext context) async {

  int hours=await SharedPrefHelper.getSeconds();
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
                            /*ListTile(
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
                            ),*/
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                onTap: (){
                                  provider.setTime(hours);
                                },
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*(provider.time!=32 && provider.time!=16)?Image.asset('assets/images/ic_radio_on.png',color: Colors.orange,):Image.asset('assets/images/ic_radio_off.png'),
                                    SizedBox(width: 20,),*/
                                    NumberPicker(
                                      zeroPad: true,
                                      value: hours,
                                      minValue: 0,
                                      itemHeight: 25,
                                      itemWidth: 50,
                                      maxValue: 48,
                                      textStyle: TextStyle(fontSize: 16),
                                      selectedTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
                                      onChanged: (value) => setState(() => hours = value),
                                    ),
                                    Text('Hours',style:TextStyle(fontSize: 20,fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      provider.setTime(hours);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TabbedBottomNavBar()));

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
  int maxHours=await SharedPrefHelper.getSeconds();
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

                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  NumberPicker(
                                    value: _currentValue,
                                    minValue: 0,
                                    itemHeight: 25,
                                    itemWidth: 50,
                                    maxValue: maxHours-1,
                                    textStyle: TextStyle(fontSize: 12),
                                    selectedTextStyle: TextStyle(fontSize: 15),
                                    onChanged: (value) => setState(() => _currentValue = value),
                                  ),
                                  Text('hours'),
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
                                  Text('minutes'),

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
                                        "createdAt":DateTime.now().millisecondsSinceEpoch,
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

Future<void> showAddScheduleDialog(BuildContext context) async {
  final provider = Provider.of<UserDataProvider>(context, listen: false);

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();



  int maxHours=await SharedPrefHelper.getSeconds();

  TimeModel alteredTime=await TimeApi.convertToAlteredTime2(DateTime.now());

  int _currentValue = alteredTime.hours;
  int _currentValue1 =  alteredTime.minutes;
  int _currentEndValue =  alteredTime.hours;
  int _currentEndValue1 =  alteredTime.minutes;

  TimeBlockModel? selectedObject;
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
              height: MediaQuery.of(context).size.height*0.68,
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
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Real World Time : ${f.format(DateTime.now())}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 17),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text('Start Time'),
                                childrenPadding: EdgeInsets.zero,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      NumberPicker(
                                        value: _currentValue,
                                        minValue: 0,
                                        itemHeight: 25,
                                        itemWidth: 50,
                                        maxValue: maxHours-1,
                                        textStyle: TextStyle(fontSize: 12),
                                        selectedTextStyle: TextStyle(fontSize: 15),
                                        onChanged: (value) => setState(() => _currentValue = value),
                                      ),
                                      Text('hours'),
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
                                      Text('minutes'),
                                    ],
                                  )
                                ],
                              ),



                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                title: Text('End Time'),


                                children: <Widget>[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      NumberPicker(
                                        value: _currentEndValue,
                                        minValue: 0,
                                        itemHeight: 25,
                                        itemWidth: 50,
                                        maxValue: maxHours-1,
                                        textStyle: TextStyle(fontSize: 12),
                                        selectedTextStyle: TextStyle(fontSize: 15),
                                        onChanged: (value) => setState(() => _currentEndValue = value),
                                      ),
                                      Text('hours'),
                                      NumberPicker(
                                        value: _currentEndValue1,
                                        minValue: 0,
                                        itemHeight: 25,
                                        itemWidth: 50,
                                        maxValue: 59,
                                        textStyle: TextStyle(fontSize: 12),
                                        selectedTextStyle: TextStyle(fontSize: 15),
                                        onChanged: (value) => setState(() => _currentEndValue1 = value),
                                      ),
                                      Text('minutes')

                                    ],
                                  )
                                ],
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
                                      if (_currentEndValue==alteredTime.hours && _currentEndValue1==alteredTime.minutes) {
                                        CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          backgroundColor: primaryColor,
                                          confirmBtnColor: primaryColor,
                                          text: "Please select end time",
                                        );
                                      }
                                      else{
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
                                          var now=DateTime.now();
                                          selectedStartDate=await TimeApi.convertBackToOriginalTime(_currentValue, _currentValue1);
                                          selectedEndDate=await TimeApi.convertBackToOriginalTime(_currentEndValue, _currentEndValue1);
                                          print('start date $selectedStartDate : end date $selectedEndDate');
                                          await FirebaseFirestore.instance.collection('reminder').add({
                                            "userId":provider.userId,
                                            "startTime":selectedStartDate.millisecondsSinceEpoch,
                                            "endTime":selectedEndDate.millisecondsSinceEpoch,
                                            "formatedStartTime":'$_currentValue:$_currentValue1',
                                            "formatedEndTime":'$_currentEndValue:$_currentEndValue1',
                                            "notificationId":notificationId,
                                            "todo":selectedObject!.todo,
                                            "todoId":selectedObject!.id,
                                            "status":'in progress',
                                          }).then((value)async{

                                            NotificationService.showAlarmNotification(
                                                title: 'Start ${selectedObject!.todo}',
                                                id: notificationId,
                                                scheduleTime: selectedStartDate
                                            );
                                            NotificationService.showAlarmNotification(
                                                title: 'End ${selectedObject!.todo}',
                                                id: int.parse('${notificationId}0101'),
                                                scheduleTime: selectedEndDate
                                            );
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
                                            backgroundColor: primaryColor,
                                            confirmBtnColor: primaryColor,
                                            text: "Please select a todo",
                                          );
                                        }
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
  final time = Provider.of<TimerProvider>(context, listen: false);
  int _currentValue1 = 0;
  int _currentValue2 = 0;
  int _currentValue=1;
  int maxHours=await SharedPrefHelper.getSeconds();
  int maxSeconds=await SharedPrefHelper.getSecondsInMinute();

  TimeBlockModel? selectedObject;
  List<TimeBlockModel> dropdownData = [];
  final provider = Provider.of<UserDataProvider>(context, listen: false);
  await FirebaseApi.getTimeBlocks(provider.userId!).then((data) {
    dropdownData = data;
    if(data.isNotEmpty)
      selectedObject=data.first;
      time.setTodo(data.first);
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
              height: MediaQuery.of(context).size.height*0.45,
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
                            DropdownButton<TimeBlockModel>(
                              value: selectedObject,
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedObject = newValue;

                                  time.setTodo(selectedObject!);
                                });
                              },
                              items: dropdownData.map((obj) {
                                return DropdownMenuItem<TimeBlockModel>(
                                  value: obj,
                                  child: Text(obj.todo),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10,),
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
                                  zeroPad: true,
                                  value: _currentValue,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 40,
                                  maxValue: maxHours,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue = value),
                                ),
                                Text('hours'),
                                NumberPicker(
                                  zeroPad: true,
                                  value: _currentValue1,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 40,
                                  maxValue: 80,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue1 = value),
                                ),
                                Text('minutes'),
                                NumberPicker(
                                  zeroPad: true,
                                  value: _currentValue2,
                                  minValue: 0,
                                  itemHeight: 25,
                                  itemWidth: 40,
                                  maxValue: maxSeconds,
                                  textStyle: TextStyle(fontSize: 12),
                                  selectedTextStyle: TextStyle(fontSize: 15),
                                  onChanged: (value) => setState(() => _currentValue2 = value),
                                ),
                                Text('seconds'),
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
                                onTap: (){
                                  final provider = Provider.of<TimerProvider>(context, listen: false);
                                  provider.setStartPlaying(true);
                                  provider.setState(0);

                                  provider.setHours(_currentValue);
                                  provider.setSelectedHours(_currentValue);

                                  provider.setMinutes(_currentValue1);
                                  provider.setSelectedMinutes(_currentValue1);

                                  provider.setSeconds(_currentValue2);
                                  provider.setSelectedSeconds(_currentValue2);

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
