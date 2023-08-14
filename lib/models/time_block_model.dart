import 'package:cloud_firestore/cloud_firestore.dart';

class TimeBlockModel{
  String id,userId,todo;
  int maxHour,maxMin,maxSec,doneHour,doneMin,doneSec;

  TimeBlockModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        maxHour = map['maxHour']??0,
        maxMin = map['maxMin']??0,
        maxSec = map['maxSec']??0,
        doneHour = map['doneHour']??0,
        doneMin = map['doneMin']??0,
        doneSec = map['doneSec']??0,
        todo = map['todo']??'',
        userId = map['userId']??'';



  TimeBlockModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}