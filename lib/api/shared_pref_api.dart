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


}