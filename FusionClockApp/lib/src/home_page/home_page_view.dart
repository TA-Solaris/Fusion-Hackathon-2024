import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';
import 'package:fusionclock/src/home_page/alarm_config_widget.dart';

import '../settings/settings_view.dart';
import '../alarm_page/alarm_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  static const routeName = '/';

  @override
  State<HomePageView> createState() => HomePageState();
}

class HomePageState extends State<HomePageView> {
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
      body: const Column(
        children: [
          Center(child: AlarmPageTime(textColor: Colors.pink)),
          AlarmConfig(id: 1),
          AlarmConfig(id: 2),
          AlarmConfig(id: 3),
        ],
      ),
    );
  }
}
