import 'package:flutter/cupertino.dart';
import 'package:taskmanager/api/shared_pref_api.dart';

class TimerProvider extends ChangeNotifier {
  /*int hour=0, minute=0, second=0;*/
  int remainingHours=0, remainingMinutes=0, remainingSeconds=0;
  int state=0; //0 stop : 1 play : 2 pause
  bool startPlaying=false;

  void setHours(int value) {
    remainingHours = value;
    notifyListeners();
  }
  void setMinutes(int value) {
    remainingMinutes = value;
    notifyListeners();
  }
  void setSeconds(int value) {
    remainingSeconds = value;
    notifyListeners();
  }

  void setState(int value) {
    state = value;
    notifyListeners();
  }
  void setStartPlaying(bool value) {
    startPlaying = value;
    notifyListeners();
  }

  void reset() {
    remainingHours=0; remainingMinutes=0; remainingSeconds=0;
    state=0;
    startPlaying=false;
    notifyListeners();
  }




}
