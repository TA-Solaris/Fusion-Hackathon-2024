import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmLogic {
  SharedPreferences? prefs;
  BuildContext? context;
  Timer? timer;
  List<TimeOfDay>? alarmTime;
  String? currentRoute;
  List<List<bool>>? daysSelected;
  int numAlarms = 0;

  void setContext(BuildContext context) {
    this.context = context;
  }

  void checkTime(Timer t) {
    loadPrefs();

    //Alarm
    DateTime currentTime = DateTime.now();
    for (int n = 0; n < numAlarms; n++) {
      if ((currentTime.minute == alarmTime?[n].minute) &&
          (currentTime.hour == alarmTime?[n].hour) &&
          (currentTime.second < 2) &&
          (daysSelected?[n][currentTime.weekday - 1] ?? false) &&
          (currentRoute != AlarmPageView.routeName)) {
        try {
          Navigator.pushReplacementNamed(context!, AlarmPageView.routeName);
          // ignore: empty_catches
        } catch (e) {}
      }
    }
  }

  void loadPrefs() async {
    //Load alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    numAlarms = prefs.getInt('num_alarms') ?? 1;
    alarmTime = List.filled(numAlarms, TimeOfDay(hour: 7, minute: 30));
    daysSelected = List.filled(
        numAlarms, List<bool>.filled(5, true) + List<bool>.filled(2, false));
    for (int n = 0; n < numAlarms; n++) {
      int hours = prefs.getInt('alarm${n}_hour') ?? 7;
      int mins = prefs.getInt('alarm${n}_min') ?? 30;
      alarmTime?[n] = TimeOfDay(hour: hours, minute: mins);
      for (int i = 0; i < 7; i++) {
        daysSelected?[n][i] = prefs.getBool('alarm${n}_day$i') ?? false;
      }
    }
  }

  AlarmLogic() {
    timer = Timer.periodic(const Duration(seconds: 1), checkTime);
    //loadPrefs();
  }
}
