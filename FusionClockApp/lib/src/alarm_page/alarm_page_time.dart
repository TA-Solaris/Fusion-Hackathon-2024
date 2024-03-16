import 'package:flutter/material.dart';

class AlarmPageTime extends StatelessWidget {
  const AlarmPageTime({super.key});

  @override
  Widget build(BuildContext context) {

    // Getting the current time
    DateTime now = DateTime.now();
    String formattedDate = "${now.hour}:${now.minute}:${now.second}";

    return Text(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 80,
        decoration: TextDecoration.none,
        fontFamily: 'RobotoMono'
      ),
      formattedDate
    );
  }
}