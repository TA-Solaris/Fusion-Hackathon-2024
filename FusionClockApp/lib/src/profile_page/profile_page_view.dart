import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../accounts_pages/signin_page_view.dart';
import '../backend_interface/backend.dart';
import '../models/userFriend.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePageView> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePageView> with BackEnd {
  List<Widget> widgets = [];
  int maxStreak = 0;
  List<Widget> friendStuff = [];

  void checkAuth(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString("auth");
    if ((auth == null) && context.mounted) {
      Navigator.pushReplacementNamed(context, LoginPageView.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    getAlarms().then((value) {
      if (value != null) {
        maxStreak = 0;
        for (var alarm in value) {
          if (alarm.streak > maxStreak) {
            maxStreak = alarm.streak;
          }
        }
      }
    });
    // Get friends
    getFriends().then((value) => {
      if (value != null)
      {
        setState(() {
          for (var friend in value)
          {
            // wow friends lets go this is pog
            friendStuff.add(Container(
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 24, 8, 24),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            fixedSize: const Size.fromRadius(40),
                            padding: const EdgeInsets.only(left: 8, right: 8)),
                        onPressed: () {},
                        child: const Text(
                          "",
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    friend.username,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  )),
                ],
              ),
            ));
          }
        })
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text(
                "🔥",
                style: TextStyle(
                  fontSize: 140,
                ),
              ),
              Text(
                "Streak: $maxStreak days",
                style: const TextStyle(
                  fontSize: 42,
                ),
              ),
              SizedBox(height: 100),
              Text(
                "Friends",
                style: TextStyle(
                  fontSize: 32
                ),
              ),
              Divider(),
              ...friendStuff
            ],
          ),
        ),
      ),
    );
  }
}
