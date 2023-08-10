import 'package:flutter/cupertino.dart';

class UserDataProvider extends ChangeNotifier {
  String? userId;

  void setUserId(String value) {
    userId = value;
    notifyListeners();
  }
}
