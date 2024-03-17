import 'package:fusionclock/src/backend_interface/backend.dart';

import 'package:flutter/material.dart';

class SharedAlarms extends StatefulWidget {
  const SharedAlarms({
    super.key,
    this.textColor = Colors.white,
    required this.alarmId,
    required this.peopleCount,
  });

  final Color textColor;

  final int peopleCount;

  final int alarmId;

  @override
  State<StatefulWidget> createState() => AlarmPageTimeState();
}

class AlarmPageTimeState extends State<SharedAlarms> with BackEnd {
  int peopleWaking = 0;

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    var pplCount = widget.peopleCount;
    return Text(
      "$pplCount other people are waking up too!",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: widget.textColor,
          fontSize: 28,
          decoration: TextDecoration.none,
          fontFamily: 'RobotoMono'),
    );
  }
}
