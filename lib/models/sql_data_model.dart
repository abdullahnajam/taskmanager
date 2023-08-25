

class SqlDataModel{

  int id,state,maxHour,maxMin,doneHour,doneMin,timerHour,timerMin,timerSec,timerRemainingHour,timerRemainingMin;
  int timerRemainingSec,customHour,customSecondsInMinute;
  String userId,todoId,todo;


  SqlDataModel.fromMap(Map<String,dynamic> map)
      : id = map['id']??0,
        maxHour = map['maxHour']??0,
        state = map['state']??0,
        maxMin = map['maxMin']??0,
        timerHour = map['timerHour']??0,
        doneHour = map['doneHour']??0,
        doneMin = map['doneMin']??0,
        timerMin = map['timerMin']??0,
        timerSec = map['timerSec']??'',
        timerRemainingHour = map['timerRemainingHour']??'',
        timerRemainingMin = map['timerRemainingMin']??'',
        timerRemainingSec = map['timerRemainingSec']??'',
        customHour = map['customHour']??'',
        customSecondsInMinute = map['customSecondsInMinute']??'',
        todoId = map['todoId']??'',
        todo = map['todo']??'',
        userId = map['userId']??'';


}