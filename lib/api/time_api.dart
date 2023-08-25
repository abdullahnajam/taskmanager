import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/models/time_model.dart';

class TimeApi{
  static Future<DateTime> convertToStandardTime(DateTime convertedDateTime) async{
    int prefData=await SharedPrefHelper.getSeconds();
    int seconds=((prefData/24)*60).toInt();
    int totalSeconds = convertedDateTime.hour * 60 * seconds + convertedDateTime.minute * seconds + convertedDateTime.second;
    int newHours = (totalSeconds ~/ 3600);
    int remainingSeconds = totalSeconds % 3600;
    int newMinutes = (remainingSeconds ~/ seconds);


    DateTime originalDateTime = DateTime(
        convertedDateTime.year,
        convertedDateTime.month,
        convertedDateTime.day,
        newHours,
        newMinutes
    );

    return originalDateTime;
  }

  static Future<DateTime> convertScheduleTime(int hour,int min) async{
    int prefData=await SharedPrefHelper.getSeconds();
    int seconds24=86400;
    int seconds=((prefData/24)*60).toInt();
    int totalSecondsOfDayInNewTime=(prefData*60) * seconds;
    int totalMinutes=(hour * 60) + min;
    int totalSeconds = totalMinutes * seconds;
    double diff=totalSecondsOfDayInNewTime/seconds24;
    print('total minutes $totalMinutes total seconds $totalSeconds : prefSec $seconds');
    double newSeconds=totalSeconds/diff;
    print('new $newSeconds : dff $diff');

    int totalSecondsInAlteredTime=((hour*60) + min) * seconds;
    print('totalSecondsInAlteredTime $totalSecondsInAlteredTime');

    int hours = totalSecondsInAlteredTime ~/ 3600;
    int minutes = (totalSecondsInAlteredTime % 3600) ~/ 60;


    /*
        24 hours : ((24 * 60) + minutes) * 60; 86400
        32 hours : ((32 * 60) + minutes) * 80; 153600

    */





    DateTime originalDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        hours,
        minutes
    );
    print('original date $originalDateTime');
    return originalDateTime;
  }



  static Future<DateTime> convertToAlteredTime(DateTime convertedDateTime) async{


    int differentInSeconds=await SharedPrefHelper.getSecondDiff();

    int totalSeconds =
        ( DateTime.now().hour * 3600) +
            (DateTime.now().minute * 60) +
            DateTime.now().second;

    totalSeconds=totalSeconds+differentInSeconds;

    int newMinutes = (totalSeconds / 60).floor();
    double newSeconds = (totalSeconds % 60);
    DateTime convertedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      newMinutes ~/ 60,
      newMinutes % 60,
      newSeconds.truncate(),
    );

    return convertedDateTime;
  }

  static Future<TimeModel> convertToAlteredTime2(DateTime convertedDateTime) async{


    int timeHours=await SharedPrefHelper.getSeconds();
    double newMinutesInHour=(24/timeHours) * 60;

    int totalSeconds =
        ( DateTime.now().hour * (3600)) +
            (DateTime.now().minute * 60) +
            DateTime.now().second;
    print('1 $totalSeconds');

    //totalSeconds=totalSeconds+differentInSeconds;

    double decimalValue = totalSeconds/(newMinutesInHour*60);
    int hours = decimalValue.floor();
    double remainingMinutesDecimal = (decimalValue - hours) * 60;
    int minutes = remainingMinutesDecimal.floor();
    int seconds = ((remainingMinutesDecimal - minutes) * 60).floor();

    TimeModel model=TimeModel(hours: hours, minutes: minutes, seconds: seconds);
    print('$hours : $minutes : $seconds');
    return model;
  }

  /*static Future<DateTime> convertBackToOriginalTime(DateTime convertedDateTime) async{
    int hours=await SharedPrefHelper.getSeconds();
    int newSecondsInMinute=((hours/24)*60).toInt();

    int differentInSeconds=await SharedPrefHelper.getSecondDiff();
    int diff=(hours-24)*(3600);
   // diff=diff*3600;

    int totalSeconds =
        ( convertedDateTime.hour * 3600) +
            (convertedDateTime.minute * 60) +
            convertedDateTime.second;


    print('total before $totalSeconds : $diff');
    totalSeconds=totalSeconds+diff;
    print('total after $totalSeconds');

    int newMinutes = (totalSeconds / 60).floor();
    double newSeconds = (totalSeconds % 60).toDouble();
    DateTime originalTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      newMinutes ~/ 60,
      newMinutes % 60,
      newSeconds.truncate(),
    );
    print('converted Time = $convertedDateTime | original Time = $originalTime');
    return originalTime;
  }*/


  static Future<DateTime> convertBackToOriginalTime(int hour,int minute) async{
    int newHours=await SharedPrefHelper.getSeconds();



    //( 24 / selected time ) *60 = total minutes in 1 hour of new time
    double newMinutesInHour=(((hour+(minute/60))*24)/newHours);


    /*double totalSeconds =
        ( hour * (60*60)) +
            (minute * 60) +
            0;
    print('1 $totalSeconds');*/


    double decimalValue = newMinutesInHour;
    print(decimalValue);
    int hours = decimalValue.floor();
    double remainingMinutesDecimal = (decimalValue - hours) * 60;
    int minutes = remainingMinutesDecimal.floor();
    int seconds = ((remainingMinutesDecimal - minutes) * 60).floor();
    DateTime originalTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hours,
      minutes,
      seconds,
    );
    print('original Time = $originalTime');
    return originalTime;
  }


  static Future<DateTime> convertTimeTo24Hours(int hour,int min) async{
    int prefData=await SharedPrefHelper.getSeconds();
    int seconds=((prefData/24)*60).toInt();
    int totalSeconds = hour * 60 * seconds + min * seconds;
    int newHours = (totalSeconds ~/ 3600);
    int remainingSeconds = totalSeconds % 3600;
    int newMinutes = (remainingSeconds ~/ seconds);


    DateTime originalDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        newHours,
        newMinutes
    );

    return originalDateTime;
  }
}