import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';
import 'package:fusionclock/src/home_page/alarm_config_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../friends/friends_page_view.dart';
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

  @override
  void initState() {
    super.initState();
    getAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fusion Clock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.restorablePushNamed(context, FriendsPageView.routeName);
            },
          ),
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
        ],
      ),
      body: const SingleChildScrollView(
        child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(child: AlarmPageTime(textColor: Colors.pink)),
              AlarmConfig(id: 1),
              AlarmConfig(id: 2),
              AlarmConfig(id: 3),
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
        ],
      ),),
    );
  }
}
