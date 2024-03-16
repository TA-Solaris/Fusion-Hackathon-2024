import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:fusionclock/src/home_page/home_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';

class AlarmPageView extends StatefulWidget {
  const AlarmPageView({super.key});
  static const routeName = '/alarm';

  @override
  State<AlarmPageView> createState() => _AlarmPageViewState();
}

class _AlarmPageViewState extends State<AlarmPageView> {
  final player = AudioPlayer();

  void playSong() async {
    await player.play(AssetSource('sounds/alarms/theelevatorbossanova.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    playSong();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomRight,
        colors: [
          Color.fromARGB(255, 56, 9, 60),
          Color.fromARGB(255, 121, 24, 139),
          Colors.pink,
          Color.fromARGB(255, 219, 186, 127),
        ],
        stops: [
          0.0,
          0.2,
          0.8,
          1.0,
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AlarmPageTime(),
          const SizedBox(height: 100),
          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              Navigator.pushReplacementNamed(context, HomePageView.routeName);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(59, 179, 179, 179)),
              child: const Text(
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      decoration: TextDecoration.none,
                      fontFamily: 'RobotoMono'),
                  'Swipe to dismiss ➤'),
            ),
          ),
        ],
      ),
    );
  }
}
