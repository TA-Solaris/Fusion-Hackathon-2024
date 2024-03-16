import 'package:flutter/material.dart';

import 'package:fusionclock/src/home_page/home_page_view.dart';

class AlarmPageView extends StatelessWidget {
  const AlarmPageView({super.key});

  static const routeName = '/alarm';

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
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const Center(
          child: Text(
            style: TextStyle(
              color: Colors.white,
              fontSize: 80,
            ),
            '10:52 AM'
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                Navigator.pushReplacementNamed(context, HomePageView.routeName);
              },
              child: const Text(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                'Swipe to dismiss ➤'
              )
            ),
          ),
        ),
      ),
    );
  }
}