import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:taskmanager/models/reminder_model.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:taskmanager/screens/utils/custom_dialog.dart';

import '../provider/user_data_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool viewCalendar=false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddTodoDialog(context);
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
                    child: Image.asset('assets/images/switch_calendar.png',height: 30,),
                  ),
                )
              ],
            ),

            if(viewCalendar)
              Container(
                height: MediaQuery.of(context).size.height*0.65,
                child: SfCalendar(
                  view: CalendarView.month,
                ),
              )
            else
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('reminder')
                    .where("userId",isEqualTo: provider.userId).snapshots(),
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
                        child: Text('No Schedule Found'),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Time'),
              Text('Thing to do',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
            ],
          ),
          Text(dtf.format(DateTime.fromMillisecondsSinceEpoch(model.startTime)),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          const SizedBox(height: 10,),
          const Text('End Time'),
          Text(dtf.format(DateTime.fromMillisecondsSinceEpoch(model.endTime)),style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
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
