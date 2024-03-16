import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmLogic {
  SharedPreferences? prefs;
  BuildContext? context;
  Timer? timer;
  TimeOfDay alarmTime = TimeOfDay.fromDateTime(DateTime.now());
  String? currentRoute;

  void setContext(BuildContext context) {
    this.context = context;
  }

  void checkTime(Timer t) {
    loadPrefs();

    //Alarm
    DateTime currentTime = DateTime.now();
    if ((currentTime.minute == alarmTime.minute) &&
        (currentTime.hour == alarmTime.hour) &&
        (currentTime.second < 2) &&
        currentRoute != AlarmPageView.routeName) {
      try {
        Navigator.pushReplacementNamed(context!, AlarmPageView.routeName);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void loadPrefs() async {
    //Load alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int hours = prefs.getInt('alarm_hour') ?? 7;
    int mins = prefs.getInt('alarm_min') ?? 30;
    alarmTime = TimeOfDay(hour: hours, minute: mins);
  }

  AlarmLogic() {
    timer = Timer.periodic(const Duration(seconds: 1), checkTime);
    loadPrefs();
  }
}
