import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';

import 'package:fusionclock/src/home_page/home_page_view.dart';
import 'package:fusionclock/src/alarm_page/alarm_page_time.dart';

import 'shared_alarms.dart';

class AlarmPageView extends StatefulWidget with BackEnd {
  final int alarmId;
  AlarmPageView({super.key, required this.alarmId});
  static const routeName = '/alarm';

  @override
  State<AlarmPageView> createState() => _AlarmPageViewState();
}

class _AlarmPageViewState extends State<AlarmPageView> with BackEnd {
  final player = AudioPlayer();
  List<Widget> emojis = [];

  void playSong() async {
    await player.play(AssetSource('sounds/alarms/theelevatorbossanova.mp3'));
  }
  
  late Timer timer;

  int peopleWaking = 0;
  List<dynamic> emojiCounts = [];

  @override
  void dispose() {
    player.dispose();
    stopAlarm(widget.alarmId);
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    playSong();
    ringAlarm(widget.alarmId);
    timer = Timer.periodic(
        const Duration(milliseconds: 937), (Timer t) => getTimeString());
  }

  void getTimeString() {
    final DateTime now = DateTime.now();

    getSharedAlarmCount(widget.alarmId)
      .then((result) => {
        setState(() {
          peopleWaking = result?.fellows ?? 0;
          emojiCounts = result?.emojis ?? [];
          if (emojiCounts.length < 5)
            return;
          // Display emojis
          int previousCount0 = 0;
          int previousCount1 = 0;
          int previousCount2 = 0;
          int previousCount3 = 0;
          int previousCount4 = 0;
          for (int i = 0; i < 30; i++)
          {
            Timer(Duration(milliseconds: (1000 / 30 * i).round()), () {
              int emojisToSend0 = (emojiCounts[0] * (i / 30.0)).round();
              int emojisToSend1 = (emojiCounts[1] * (i / 30.0)).round();
              int emojisToSend2 = (emojiCounts[2] * (i / 30.0)).round();
              int emojisToSend3 = (emojiCounts[3] * (i / 30.0)).round();
              int emojisToSend4 = (emojiCounts[4] * (i / 30.0)).round();
              for (int i = previousCount0; i < emojisToSend0; i++)
                addEmoji(0, true);
              for (int i = previousCount1; i < emojisToSend1; i++)
                addEmoji(1, true);
              for (int i = previousCount2; i < emojisToSend2; i++)
                addEmoji(2, true);
              for (int i = previousCount3; i < emojisToSend3; i++)
                addEmoji(3, true);
              for (int i = previousCount4; i < emojisToSend4; i++)
                addEmoji(4, true);
              previousCount0 = emojisToSend0;
              previousCount1 = emojisToSend1;
              previousCount2 = emojisToSend2;
              previousCount3 = emojisToSend3;
              previousCount4 = emojisToSend4;
            });
          }
        })
      });
  }

  void addEmoji(int emojiId, bool silent) {
    String emoji;
    switch (emojiId) {
      case 0:
        emoji = "😀";
        break;
      case 1:
        emoji = "😂";
        break;
      case 2:
        emoji = "😍";
        break;
      case 3:
        emoji = "😎";
        break;
      case 4:
        emoji = "🥳";
        break;
      default:
        return;
    }
    if (!silent)
    { 
      sendEmoji(emojiId);
    }
    setState(() {
      emojis.add(
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 25,
          bottom: 80,
          child: TweenAnimationBuilder(
            duration: Duration(seconds: 3),
            tween: Tween(begin: Offset(0, 0), end: Offset(Random.secure().nextDouble() * 100 - 50, -300)),
            builder: (BuildContext context, Offset offset, Widget? child) {
              return Transform.translate(
                offset: offset,
                child: Opacity(
                  opacity: max(0, 1 - offset.dy.abs() / 100),
                  child: Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(builder: (BuildContext context) {
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AlarmPageTime(),
                SharedAlarms(alarmId: widget.alarmId, peopleCount: peopleWaking),
                const SizedBox(height: 100),
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (DismissDirection direction) {
                    Navigator.pushReplacementNamed(
                        context, HomePageView.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(59, 179, 179, 179),
                    ),
                    child: Text(
                      'Swipe to dismiss ➤',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        decoration: TextDecoration.none,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        OverlayEntry(builder: (BuildContext context) {
          return Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        width: 320,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                        ),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                addEmoji(0, false);
                                Navigator.pop(context);
                              },
                              child: Text("😀"),
                            ),
                            TextButton(
                              onPressed: () {
                                addEmoji(1, false);
                                Navigator.pop(context);
                              },
                              child: Text("😂"),
                            ),
                            TextButton(
                              onPressed: () {
                                addEmoji(2, false);
                                Navigator.pop(context);
                              },
                              child: Text("😍"),
                            ),
                            TextButton(
                              onPressed: () {
                                addEmoji(3, false);
                                Navigator.pop(context);
                              },
                              child: Text("😎"),
                            ),
                            TextButton(
                              onPressed: () {
                                addEmoji(4, false);
                                Navigator.pop(context);
                              },
                              child: Text("🥳"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.white,
                  ),
                ),
              ),
          );
        }),
        OverlayEntry(builder: (BuildContext builder) {
          return IgnorePointer(
            ignoring: true,
            child: Stack(
              children: emojis
            )
          );
        })
      ],
    );
  }
}
