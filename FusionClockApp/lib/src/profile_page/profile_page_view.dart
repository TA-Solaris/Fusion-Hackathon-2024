import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/register_page_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../accounts_pages/signin_page_view.dart';
import '../backend_interface/backend.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePageView> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePageView> with BackEnd {
  List<Widget> widgets = [];

  void checkAuth(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = await prefs.getString("auth");
    if ((auth == null) && context.mounted) {
      Navigator.pushReplacementNamed(context, LoginPageView.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(context); //TODO enable to force login
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
              const Text(
                "Streak: 7 days",
                style: TextStyle(
                  fontSize: 42,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
