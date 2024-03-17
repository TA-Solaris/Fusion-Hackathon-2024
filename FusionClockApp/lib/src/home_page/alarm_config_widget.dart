import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmConfig extends StatefulWidget {
  final int id;
  final Function? deleteAlarm;

  const AlarmConfig({super.key, required this.id, this.deleteAlarm});

  @override
  State<AlarmConfig> createState() => _AlarmConfigState();
}

class _AlarmConfigState extends State<AlarmConfig> with BackEnd {
  TimeOfDay alarmTime = TimeOfDay.fromDateTime(DateTime.now());
  List<bool> daysSelected = List.filled(5, true) + List.filled(2, false);
  final MaterialColor theme = Colors.pink;

  void alarmUpdated() async {
    var tempTime =
        await showTimePicker(context: context, initialTime: alarmTime) ??
            alarmTime;
    setState(() {
      alarmTime = tempTime;
    });

    //Save alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarm${widget.id}_hour', alarmTime.hour);
    await prefs.setInt('alarm${widget.id}_min', alarmTime.minute);
  }

  String formatTime() {
    return "${alarmTime.hour.toString().padLeft(2, '0')}:${alarmTime.minute.toString().padLeft(2, '0')}";
  }

  void loadPrefs() async {
    //Load alarm time
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int hours = prefs.getInt('alarm${widget.id}_hour') ?? 7;
    int mins = prefs.getInt('alarm${widget.id}_min') ?? 30;
    for (int i = 0; i < 7; i++) {
      daysSelected[i] =
          prefs.getBool('alarm${widget.id}_day$i') ?? daysSelected[i];
    }
    int numAlarms = prefs.getInt('num_alarms') ?? 0;
    await prefs.setInt(
        'num_alarms', widget.id >= numAlarms ? widget.id : numAlarms);
    updateAlarmTime(widget.id, TimeOfDay(hour: hours, minute: mins));
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
            await prefs.setBool('alarm${widget.id}_day$i', daysSelected[i]);
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor:
                  daysSelected[i] ? theme.shade900 : theme.shade100),
          child: Text(
            daysOfWeek[i],
            style: TextStyle(
                color: daysSelected[i]
                    ? Colors.purple.shade100
                    : Colors.purple.shade800,
                fontSize: 12,
                decoration: TextDecoration.none,
                fontFamily: 'RobotoMono'),
          ));
    } else {
      return const SizedBox(
        width: 10,
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.deleteAlarm != null)
                SizedBox(
                  width: 110,
                ),
              ElevatedButton(
                  onPressed: alarmUpdated,
                  child: Text(
                    "Alarm at ${formatTime()}",
                    style: const TextStyle(
                        fontSize: 35,
                        decoration: TextDecoration.none,
                        fontFamily: 'RobotoMono'),
                  )),
              if (widget.deleteAlarm != null)
                SizedBox(
                  width: 30,
                ),
              if (widget.deleteAlarm != null)
                ElevatedButton(
                    onPressed: () {
                      widget.deleteAlarm!();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.red,
                    ),
                    child: const Icon(Icons.close))
            ],
          ),
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
