import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
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
              child: Column(
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
                        RadioListTile(
                          value: true,
                          groupValue: true,
                          onChanged: (value){

                          },
                          title: const Text('16 Hours'),
                        ),
                        RadioListTile(
                          value: true,
                          groupValue: true,
                          onChanged: (value){

                          },
                          title: const Text('32 Hours'),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
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
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: InkWell(
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
          );
        },
      );
    },
  );
}

Future<void> showAddTimeBlockDialog(BuildContext context) async {

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
              height: MediaQuery.of(context).size.height*0.55,
              width: MediaQuery.of(context).size.width*0.9,
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.circular(10)
              ),
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
                            TextField(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text('hh : mm :ss',style: TextStyle(color: Colors.grey.shade700),),
                                ),
                              ],
                            ),
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
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: InkWell(
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

    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime(2019, 6, 7),
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
    DatePicker.showDateTimePicker(context,
      showTitleActions: true,
      minTime: DateTime(2018, 3, 5),
      maxTime: DateTime(2019, 6, 7),
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
                                flex: 1,
                                child: Container()
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: ()async{
                                    if(_formKey.currentState!.validate()){
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
                                      }).then((value){
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
