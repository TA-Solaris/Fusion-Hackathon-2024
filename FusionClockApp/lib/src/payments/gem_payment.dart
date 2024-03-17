import 'dart:async';

import 'package:flutter/material.dart';


class GemPayment extends StatefulWidget {
  const GemPayment({
    super.key,
    this.textColor = Colors.white,
  });

  final Color textColor;

  @override
  State<StatefulWidget> createState() => GemPaymentState();
}

class GemPaymentState extends State<GemPayment> {
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
        const Duration(seconds: 1), (Timer t) => getTimeString());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 110,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.diamond, // Use the diamond-shaped icon
            color: Colors.white, // Customize the color as needed
            size: 30.0,
          ),
          Text(
            '100',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
