import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/models/reminder_model.dart';
import 'package:taskmanager/models/time_block_model.dart';

class FirebaseApi{

  static Future<List<TimeBlockModel>> getTimeBlocks(String userId) async {
    List<TimeBlockModel> dataList = [];

    await FirebaseFirestore.instance.collection('timeblock').where('userId',isEqualTo: userId).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        TimeBlockModel model=TimeBlockModel.fromMap(data, doc.reference.id);
        dataList.add(model);
      });
    });

    return dataList;
  }

  static Future<TimeBlockModel> getTimeBlock(String id)async{
    TimeBlockModel? timeBlockModel;
    await FirebaseFirestore.instance.collection('timeblock')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        timeBlockModel=TimeBlockModel.fromMap(data, documentSnapshot.reference.id);
      }
    });
    return timeBlockModel!;
  }

  static Future<List<ReminderModel>> getReminders(String userId) async {
    List<ReminderModel> dataList = [];

    await FirebaseFirestore.instance.collection('reminder').where('userId',isEqualTo: userId).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        ReminderModel model=ReminderModel.fromMap(data, doc.reference.id);
        dataList.add(model);
      });
    });

    return dataList;
  }

  static Future<List<TimeBlockModel>> setScheduleStatus() async {
    List<TimeBlockModel> dataList = [];

    await FirebaseFirestore.instance.collection('reminder').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        ReminderModel model=ReminderModel.fromMap(data, doc.reference.id);
        DateTime date=DateTime.fromMillisecondsSinceEpoch(model.startTime);

        if(date.isBefore(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))){
          FirebaseFirestore.instance.collection('reminder').doc(model.id).update({
            'status':'finished',
          });
        }
      });
    });

    return dataList;
  }

  static Future<void> updateTodos() async {


    await FirebaseFirestore.instance.collection('reminder').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async{
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        ReminderModel model=ReminderModel.fromMap(data, doc.reference.id);

        TimeBlockModel timeBlockModel=await getTimeBlock(model.todoId);


        DateTime date=DateTime.fromMillisecondsSinceEpoch(model.endTime);
        DateTime start=DateTime.fromMillisecondsSinceEpoch(model.startTime);
        Duration difference = date.difference(start);
        double hoursDifference = difference.inHours.toDouble();
        int updateHours=0;
        int updateMin=0;
        if(hoursDifference<(timeBlockModel.maxHour + (timeBlockModel.maxMin / 60)).toDouble()){
          updateHours = hoursDifference.floor();
          updateMin = ((hoursDifference - updateHours) * 60).round();
        }
        else{
          updateHours=timeBlockModel.maxHour-timeBlockModel.doneHour;

        }
        if(date.isBefore(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))){
          FirebaseFirestore.instance
              .collection('timeblock')
              .doc(model.id)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              FirebaseFirestore.instance.collection('timeblock').doc(model.id).update({
                "doneHour":updateHours,
                "doneMin":updateMin,
              });
            }
          });

        }
      });
    });


  }


}