import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{

  static Future setSeconds(int seconds)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('SECONDS', seconds);
  }

  static Future<int> getSeconds()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('SECONDS')??32;
  }

  static Future setStartCountDown(bool value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('TIMER', value);
  }

  static Future<bool> getStartCountdown()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('TIMER')??false;
  }

  static Future<int> getSecondsInMinute()async{
    final prefs = await SharedPreferences.getInstance();
    int hours= prefs.getInt('SECONDS')??32;
    return  ((hours/24)*60).toInt();
  }

  static Future<int> getSecondDiff()async{
    int hours = await SharedPrefHelper.getSeconds();
    int diff=24-hours;
    return diff*3600;
  }

  static Future<String> setUUID()async{
    final prefs = await SharedPreferences.getInstance();
    String uuid="user_${DateTime.now().millisecondsSinceEpoch}";
    await prefs.setString('UUID', uuid);
    return uuid;
  }

  static Future<String> getUUID()async{
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('UUID')??"none";
    return id;
  }

}