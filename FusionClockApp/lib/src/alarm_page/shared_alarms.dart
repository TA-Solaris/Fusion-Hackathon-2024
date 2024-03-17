import 'dart:async';
import 'dart:math';

import 'package:fusionclock/src/backend_interface/backend.dart';

import 'package:flutter/material.dart';

class SharedAlarms extends StatefulWidget {
  const SharedAlarms({
    super.key,
    this.textColor = Colors.white,
    required this.alarmId,
  });

  final Color textColor;

  final int alarmId;

  @override
  State<StatefulWidget> createState() => AlarmPageTimeState();
}

class AlarmPageTimeState extends State<SharedAlarms> with BackEnd {
  int peopleWaking = 0;
  late Timer timer;

  void getTimeString() {
    final DateTime now = DateTime.now();

    getSharedAlarmCount(widget.alarmId)
      .then((result) => {
        setState(() {
          peopleWaking = result ?? 0;
        })
      });
  }

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    getTimeString();

    timer = Timer.periodic(
        const Duration(milliseconds: 937), (Timer t) => getTimeString());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$peopleWaking other people are waking up too!",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: widget.textColor,
          fontSize: 28,
          decoration: TextDecoration.none,
          fontFamily: 'RobotoMono'),
    );
  }
}
