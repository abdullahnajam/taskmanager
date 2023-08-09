import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  String id,userId;
  int startTime,endTime;

  ReminderModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        startTime = map['startTime']??DateTime.now().millisecondsSinceEpoch,
        userId = map['userId']??'',
        endTime = map['endTime']??DateTime.now().millisecondsSinceEpoch;



  ReminderModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}