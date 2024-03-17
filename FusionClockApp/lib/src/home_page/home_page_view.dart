import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_view.dart';
import '../alarm_page/alarm_page_view.dart';
import '../backend_interface/backend.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  static const routeName = '/';

  @override
  State<HomePageView> createState() => HomePageState();
}

class HomePageState extends State<HomePageView> with BackEnd {
  TimeOfDay alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  String formatTime() {
    return "${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}";
  }

  void alarmUpdated() async {
    var tempTime =
        await showTimePicker(context: context, initialTime: alarmTime) ??
            alarmTime;
    setState(() {
      alarmTime = tempTime;
    });

    //Save alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarm_hour', alarmTime.hour);
    await prefs.setInt('alarm_min', alarmTime.minute);
  }

  void loadPrefs() async {
    //Load alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int hours = prefs.getInt('alarm_hour') ?? 7;
    int mins = prefs.getInt('alarm_min') ?? 30;

    setState(() {
      alarmTime = TimeOfDay(hour: hours, minute: mins);
    });
  }

  Future<String?> loadAlarms() async {
    await getAlarms();
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
    loadAlarms();
  }

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
              Navigator.pushReplacementNamed(context, AlarmPageView.routeName);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              const Center(child: AlarmPageTime(textColor: Colors.pink)), // TODO - make this follow theme
              ElevatedButton(
                  onPressed: alarmUpdated,
                  child: Text(
                    "Alarm at ${formatTime()}",
                    style: const TextStyle(
                        fontSize: 45,
                        decoration: TextDecoration.none,
                        fontFamily: 'RobotoMono'),
                  )),
            ],
          ),
          Column(
            children: [
              Text(
                "🔥",
                style: const TextStyle(
                  fontSize: 140,
                )
              ),
              Text(
                "Streak: 7 days",
                style: const TextStyle(
                  fontSize: 42,
                )
              )
            ],
          ),
          SizedBox(height: 300),
        ],
      ),
    );
  }
}
