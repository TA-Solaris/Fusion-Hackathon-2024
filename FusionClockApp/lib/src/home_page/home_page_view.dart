import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';

import '../settings/settings_view.dart';
import '../alarm_page/alarm_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  static const routeName = '/';

  @override
  State<HomePageView> createState() => HomePageState();
}

class HomePageState extends State<HomePageView> {

  TimeOfDay alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('FusionClock'),
        actions: [
          IconButton(
            // TEMP BUTTON
            icon: const Icon(Icons.alarm),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, AlarmPageView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.restorablePushNamed(
                  context, RegisterPageView.routeName);
            },
          ),
          const SizedBox(
            width: 40,
          )
        ],
      ),
      body: Column(
        children: [
          const Center(
            child: AlarmPageTime()
          ),
          ElevatedButton(
            onPressed: () async {
              var tempTime = await showTimePicker(
                      context: context, initialTime: alarmTime) ??
                  alarmTime;
              setState(() {
                alarmTime = tempTime;
              });
            },
            child: Text(
              alarmTime.toString()
            )
          )
        ],
      ), 
    );
  }
}
