import 'package:flutter/cupertino.dart';
import 'package:taskmanager/api/shared_pref_api.dart';
import 'package:taskmanager/models/time_block_model.dart';

class TimerProvider extends ChangeNotifier {
  /*int hour=0, minute=0, second=0;*/
  int remainingHours=0, remainingMinutes=0, remainingSeconds=0;
  int selectedHours=0, selectedMinutes=0, selectedSeconds=0;
  int state=0; //0 stop : 1 play : 2 pause
  bool startPlaying=false;
  TimeBlockModel? model;

  void setHours(int value) {
    remainingHours = value;
    notifyListeners();
  }
  void setTodo(TimeBlockModel value) {
    model = value;
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

  void setSelectedHours(int value) {
    selectedHours = value;
    notifyListeners();
  }

  void setSelectedMinutes(int value) {
    selectedMinutes = value;
    notifyListeners();
  }
  void setSelectedSeconds(int value) {
    selectedSeconds = value;
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
    selectedHours=0; selectedMinutes=0; selectedSeconds=0;
    state=0;
    startPlaying=false;
    model=null;
    notifyListeners();
  }




}
