import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';

import '../settings/settings_view.dart';
import 'home_page_stat.dart';
import '../alarm_page/alarm_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  static const routeName = '/';

  @override
  State<HomePageView> createState() => HomePageState();
}

class HomePageState extends State<HomePageView> {
  List<HomePageStatItem> items = const [
    HomePageStatItem(1),
    HomePageStatItem(2)
  ];

  TimeOfDay alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    List<Widget> topWidgets = [
      const AlarmPageTime(),
      ElevatedButton(
          onPressed: () async {
            var tempTime = await showTimePicker(
                    context: context, initialTime: alarmTime) ??
                alarmTime;
            setState(() {
              alarmTime = tempTime;
            });
          },
          child: Text(alarmTime.toString()))
    ];

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
        body: ListView.builder(
          restorationId: 'homePageStatsView',
          itemCount: items.length + topWidgets.length,
          itemBuilder: (BuildContext context, int index) {
            if (index < topWidgets.length) return topWidgets[index];

            //Statistics
            final item = items[index - topWidgets.length];

            return ListTile(
                title: Text('SampleItem ${item.id}'),
                leading: const CircleAvatar(
                  // Display the Flutter Logo image asset.
                  foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                ),
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    HomePageView
                        .routeName, //TODO make clickable to different route
                  );
                });
          },
        ));
  }
}
