import 'dart:async';

import 'package:flutter/material.dart';

class AlarmPageTime extends StatefulWidget {
  const AlarmPageTime({
    Key? key,
    this.textColor = Colors.white,
  }) : super(key: key);

  final Color textColor;

  @override
  State<StatefulWidget> createState() => AlarmPageTimeState();
}

class AlarmPageTimeState extends State<AlarmPageTime> {
  String timeString = "";
  late Timer timer;

  void getTimeString() {
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
    super.initState();
    getTimeString();

    timer = Timer.periodic(
      const Duration(seconds: 1), (Timer t) => getTimeString()
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeString,
      style: TextStyle(
        color: widget.textColor,
        fontSize: 80,
        decoration: TextDecoration.none,
        fontFamily: 'RobotoMono'
      ),
    );
  }
}