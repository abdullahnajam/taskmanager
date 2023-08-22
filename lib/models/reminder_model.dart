import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel{
  String id,userId,todo,todoId,status,formatedStartTime,formatedEndTime;
  int startTime,endTime;

  ReminderModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        startTime = map['startTime']??DateTime.now().millisecondsSinceEpoch,
        userId = map['userId']??'',
        todo = map['todo']??'',
        formatedStartTime = map['formatedStartTime']??'',
        formatedEndTime = map['formatedEndTime']??'',
        todoId = map['todoId']??'',
        status = map['status']??'finished',
        endTime = map['endTime']??DateTime.now().millisecondsSinceEpoch;



  ReminderModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}