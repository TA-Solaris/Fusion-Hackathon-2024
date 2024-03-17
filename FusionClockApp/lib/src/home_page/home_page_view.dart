import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_logic.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';
import 'package:fusionclock/src/home_page/alarm_config_widget.dart';
import 'package:fusionclock/src/payments/gem_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../accounts_pages/signin_page_view.dart';
import '../friends/friends_page_view.dart';
import '../models/alarm.dart';
import '../settings/settings_view.dart';
import '../alarm_page/alarm_page_view.dart';
import '../backend_interface/backend.dart';
import '../profile_page/profile_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  static const routeName = '/home';

  @override
  State<HomePageView> createState() => HomePageState();
}

class HomePageState extends State<HomePageView> with BackEnd {
  List<Widget> widgets = [];

  void checkAuth(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if ((auth == null) && context.mounted) {
      Navigator.pushReplacementNamed(context, LoginPageView.routeName);
    }
  }

  void fetchAlarms() async {
    await getAlarms().then((value) => {
          if (value != null)
          {
            setState(() {
              widgets.clear();
              widgets.add(
              const Center(child: AlarmPageTime(textColor: Colors.pink)));
              for (var alarm in value) {
                widgets.add(AlarmConfig(
                  key: Key("${alarm.id}"),
                  id: alarm.id,
                  deleteAlarm: () {
                    deleteAlarm(alarm.id)
                      .then((value) => {
                        fetchAlarms()
                      });
                    }
                ));
              }
            })
          }
          else
          {
            setState(() {
              widgets.clear();
              widgets.add(const Center(child: AlarmPageTime(textColor: Colors.pink)));
            })
          }
        });
  }

  @override
  void initState() {
    super.initState();
    fetchAlarms();
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(context); //TODO enable to force login
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
              Navigator.restorablePushNamed(context, ProfilePageView.routeName);
            },
          ),
        ],
      ),
      body: Overlay(
        initialEntries: [
          OverlayEntry(builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: widgets,
                  ),
                  Column(
                    children: [
                      if (widgets.length < 5)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade200),
                            onPressed: () {
                              createAlarm(DateTime.now()).then((value) => {
                                    getAlarms().then((value) => {
                                      fetchAlarms()
                                    })
                                  });
                            },
                            child: const SizedBox(
                                width: 400,
                                height: 50,
                                child: Icon(Icons.add))),
                    ],
                  ),
                ],
              ),
            );
          }),
          OverlayEntry(builder: (BuildContext context) {
            return const Positioned(
              top: 15,
              right: 30,
              child: GemPayment(),
            );
          }),
        ],
      ),
    );
  }
}
