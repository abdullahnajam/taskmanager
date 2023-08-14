import 'package:flutter/cupertino.dart';
import 'package:taskmanager/api/shared_pref_api.dart';

class UserDataProvider extends ChangeNotifier {
  String? userId;
  int time=32;

  void setUserId(String value) {
    userId = value;
    notifyListeners();
  }

  void setTime(int value) {
    SharedPrefHelper.setSeconds(value);
    time = value;
    notifyListeners();
  }

  void getTime()async{
    time = await SharedPrefHelper.getSeconds();
    notifyListeners();
  }
}
