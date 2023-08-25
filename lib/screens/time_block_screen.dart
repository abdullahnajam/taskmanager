import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:taskmanager/api/time_api.dart';
import 'package:taskmanager/models/time_block_model.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

import '../provider/user_data_provider.dart';

class TimeBlockScreen extends StatefulWidget {
  const TimeBlockScreen({Key? key}) : super(key: key);

  @override
  State<TimeBlockScreen> createState() => _TimeBlockScreenState();
}

class _TimeBlockScreenState extends State<TimeBlockScreen> {

  Future<void> showEditDialog(BuildContext context,TimeBlockModel model) async {

    int _currentValue = 0;
    int _currentValue1 = 0;
    int max=59;
    if((model.doneHour + (model.doneMin / 60))>=(model.maxHour + (model.maxMin / 60))){
      max=0;
    }
    else{
      if((model.doneHour + (model.doneMin / 60))<(model.maxHour + (model.maxMin / 60)) && model.maxHour-model.doneHour==0){
        double decimalHours=((model.maxHour + (model.maxMin / 60))-(model.doneHour + (model.doneMin / 60)));
        int hours = decimalHours.toInt();
        double fractionalHours = decimalHours - hours;
        max = (fractionalHours * 60).toInt();

      }
    }
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
                height: MediaQuery.of(context).size.height*0.3,
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
                                  Expanded(child: Text(model.todo,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),),
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
                              const Text('Set completed hours'),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  NumberPicker(
                                    value: _currentValue,
                                    minValue: 0,
                                    itemHeight: 25,
                                    itemWidth: 50,
                                    maxValue: model.maxHour-model.doneHour,
                                    textStyle: const TextStyle(fontSize: 12),
                                    selectedTextStyle: const TextStyle(fontSize: 15),
                                    onChanged: (value) => setState(() => _currentValue = value),
                                  ),
                                  const Text('hours'),
                                  NumberPicker(
                                    value: _currentValue1,
                                    minValue: 0,
                                    itemHeight: 25,
                                    itemWidth: 50,
                                    maxValue: max,
                                    textStyle: const TextStyle(fontSize: 12),
                                    selectedTextStyle: const TextStyle(fontSize: 15),
                                    onChanged: (value) => setState(() => _currentValue1 = value),
                                  ),
                                  const Text('minutes')

                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: ()async{
                                        final ProgressDialog pr = ProgressDialog(context: context);
                                        pr.show(max: 100, msg: 'Updating');

                                        final provider = Provider.of<UserDataProvider>(context, listen: false);
                                        /*double minutes=_currentValue1;
                                        int remainingMinutes=0;
                                        minutes=minutes+model.doneMin;
                                        //int remainingMinutes=minutes.toInt();
                                        if(minutes>1){
                                          double decimalHours=minutes;
                                          int hours = decimalHours.toInt();
                                          double fractionalHours = decimalHours - hours;
                                          remainingMinutes = (fractionalHours * 60).toInt();
                                          _currentValue=_currentValue+hours;
                                        }*/
                                        double max=(model.maxHour + (model.maxMin / 60));
                                        double updateDone=(model.doneHour + (model.doneMin / 60));
                                        double done=((model.doneHour)+_currentValue + (_currentValue1 / 60));

                                        await FirebaseFirestore.instance.collection('timeblock').doc(model.id).update({

                                          "doneHour":(done>max && done>updateDone)?model.maxHour:(model.doneHour)+_currentValue,
                                          "doneMin":_currentValue1,
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


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //TimeApi.convertBackToOriginalTime2(25,24);
          print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).millisecondsSinceEpoch);
          showAddTimeBlockDialog(context);
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360)
        ),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('timeblock')
              .where("userId",isEqualTo: provider.userId)
              .where("createdAt",isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).millisecondsSinceEpoch).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.size==0) {
              return const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(''),
                ),
              );
            }

            return GridView(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                mainAxisSpacing: 10.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between columns
                childAspectRatio: 1.12, // Width / Height ratio of grid items
              ),
              shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                TimeBlockModel model=TimeBlockModel.fromMap(data,document.reference.id);
                return timeBlock(model);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
  Widget timeBlock(TimeBlockModel model){
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.grey.shade200
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(model.todo,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              if(model.doneHour==0)
              InkWell(
                onTap: (){
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.confirm,
                    backgroundColor: primaryColor,
                    title: 'Complete Todo',
                    text: 'Are you sure you want to mark it as complete?',
                    cancelBtnText: 'No',
                    confirmBtnText: 'Yes',
                    confirmBtnColor: primaryColor,
                    onConfirmBtnTap: ()async{
                      await FirebaseFirestore.instance.collection('timeblock').doc(model.id).update({

                        "doneHour":model.maxHour,
                        "doneMin":model.maxMin,
                      });
                      //Navigator.pop(context);
                    }
                  );

                },
                child: const Icon(Icons.edit_outlined,size: 15,),
              )
              else
                Icon(Icons.check_circle,color: Colors.green,size: 15,)
            ],
          ),
          Text('Invest ${model.doneHour} Hour/ ${model.maxHour} Hours'),
          const SizedBox(height: 20,),
          DashedCircularProgressBar.aspectRatio(
            aspectRatio: 2.5, // width ÷ height
            progress: (model.doneHour + (model.doneMin / 60)).toDouble(),
            maxProgress:  (model.maxHour + (model.maxMin / 60)).toDouble(),
            startAngle: 180,
            sweepAngle: 360,
            foregroundColor: primaryColor,
            backgroundColor: Colors.white,
            foregroundStrokeWidth: 10,
            backgroundStrokeWidth: 10,
            animation: true,
            child: Center(
              child: Text('${(model.doneHour + (model.doneMin / 60)).toStringAsFixed(1)}/${(model.maxHour + (model.maxMin / 60)).toStringAsFixed(1)}',style: const TextStyle(fontSize: 10),),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
