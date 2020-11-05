import 'package:flutter/material.dart';

class TrainingTimer extends ChangeNotifier {
  int _timer = 20;

  int get timer => _timer;

  set timer(int newTimer) {
    _timer = newTimer;
    notifyListeners();
  }
}
