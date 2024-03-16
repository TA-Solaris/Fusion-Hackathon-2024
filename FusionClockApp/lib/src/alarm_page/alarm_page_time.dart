import 'dart:async';

import 'package:flutter/material.dart';

class AlarmPageTime extends StatefulWidget {
  const AlarmPageTime({super.key});
  
  @override
  State<StatefulWidget> createState() => AlarmPageTimeState();
}

class AlarmPageTimeState extends State<AlarmPageTime> {

  String timeString = "";

  getTimeString() {
    final DateTime now = DateTime.now();
    final String formattedTime = formatTime(now);

    setState(() {
      timeString = formattedTime;
    });
  }

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    getTimeString();

    Timer.periodic(const Duration(seconds: 1), (Timer t) => getTimeString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 80,
        decoration: TextDecoration.none,
        fontFamily: 'RobotoMono'
      ),
      timeString
    );
  }
}