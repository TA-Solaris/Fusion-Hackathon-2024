import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final MaterialColor theme = Colors.pink;
  List<bool> daysSelected = List.filled(5, true) + List.filled(2, false);

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
    for (int i = 0; i < 7; i++) {
      daysSelected[i] = prefs.getBool('alarm_day$i') ?? daysSelected[i];
    }
    setState(() {
      alarmTime = TimeOfDay(hour: hours, minute: mins);
    });
  }

  Widget toggleDaysOfWeek(BuildContext context, int i) {
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    if (i % 2 == 0) {
      i = i ~/ 2;
      return ElevatedButton(
          onPressed: () async {
            setState(() {
              daysSelected[i] = !daysSelected[i];
            });
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('alarm_day$i', daysSelected[i]);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  daysSelected[i] ? theme.shade900 : theme.shade100),
          child: Text(
            daysOfWeek[i],
            style: TextStyle(
                color: daysSelected[i]
                    ? Colors.purple.shade100
                    : Colors.purple.shade800,
                fontSize: 13,
                decoration: TextDecoration.none,
                fontFamily: 'RobotoMono'),
          ));
    } else {
      return const SizedBox(
        width: 20,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
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
        children: [
          const Center(child: AlarmPageTime(textColor: Colors.pink)),
          ElevatedButton(
              onPressed: alarmUpdated,
              child: Text(
                "Alarm at ${formatTime()}",
                style: const TextStyle(
                    fontSize: 45,
                    decoration: TextDecoration.none,
                    fontFamily: 'RobotoMono'),
              )),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: toggleDaysOfWeek,
                scrollDirection: Axis.horizontal,
                itemCount: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
