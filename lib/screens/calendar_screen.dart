import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:taskmanager/api/time_api.dart';
import 'package:taskmanager/models/reminder_model.dart';
import 'package:taskmanager/models/time_block_model.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

import '../api/firebase_api.dart';
import '../models/meeting_model.dart';
import '../provider/user_data_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool viewCalendar=false;
  /*Future<List<Meeting>> _getDataSource(String userId) async{
    final List<Meeting> meetings = <Meeting>[];
    DateTime today=DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await FirebaseFirestore.instance.collection('reminder').where('userId',isEqualTo: userId).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        ReminderModel model=ReminderModel.fromMap(data, doc.reference.id);
        final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(model.startTime);
        final DateTime endTime = DateTime.fromMillisecondsSinceEpoch(model.endTime);
        print('start $startTime end $endTime');

        meetings.add(Meeting(model.todo, startTime, endTime, endTime.isBefore(today)?Colors.green:Colors.yellow, false));
      });
    });



    return meetings;
  }*/

  Future<List<Meeting>> _getDataSource(String userId) async{
    final List<Meeting> meetings = <Meeting>[];
    DateTime today=DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await FirebaseFirestore.instance.collection('timeblock').where('userId',isEqualTo: userId).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        TimeBlockModel model=TimeBlockModel.fromMap(data, doc.reference.id);
        final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(model.createdAt);

        if(startTime.isBefore(today)){
          meetings.add(Meeting(model.todo, startTime, startTime, (model.doneHour==model.maxHour && model.maxMin==model.maxMin)?Colors.green:Colors.red, true));

        }
        else{
          meetings.add(Meeting(model.todo, startTime, startTime, (model.doneHour==model.maxHour && model.maxMin==model.maxMin)?Colors.green:Colors.orange, true));
        }
      });
    });



    return meetings;
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          TimeApi.convertBackToOriginalTime(23  , 5);
          showAddScheduleDialog(context);
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360)
        ),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        viewCalendar=!viewCalendar;
                      });
                    },
                    child: const Icon(Icons.calendar_month_outlined,color: Colors.black,size: 30,)
                  ),
                )
              ],
            ),

            if(viewCalendar)
              FutureBuilder<List<Meeting>>(
                  future: _getDataSource(provider.userId!),
                  builder: (context, AsyncSnapshot<List<Meeting>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
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


                      else {

                        return  Container(
                          height: MediaQuery.of(context).size.height*0.65,
                          child: SfCalendar(
                            dataSource: MeetingDataSource(snapshot.data!),
                            view: CalendarView.month,
                            initialSelectedDate: DateTime.now(),
                            initialDisplayDate: DateTime.now(),
                            monthViewSettings: const MonthViewSettings(

                              showAgenda: true,
                                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                          ),
                        );
                      }
                    }
                  }
              )

            else
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reminder')
                    .where("userId",isEqualTo: provider.userId)
                    .where("status",isNotEqualTo: 'finished').snapshots(),
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

                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      ReminderModel model=ReminderModel.fromMap(data,document.reference.id);
                      return reminderTile(model);
                    }).toList(),
                  );
                },
              ),

          ],
        ),
      ),
    );
  }
  Widget reminderTile(ReminderModel model){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Start Time'),
              Text(model.todo,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
            ],
          ),
          Text(model.formatedStartTime,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          const SizedBox(height: 10,),
          const Text('End Time'),
          Text(model.formatedEndTime,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: Divider(color: Colors.black,),
          )

        ],
      ),
    );
  }
}
