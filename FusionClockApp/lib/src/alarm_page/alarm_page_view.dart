import 'package:flutter/material.dart';

class AlarmPageView extends StatelessWidget {
  const AlarmPageView({super.key});

  static const routeName = '/alarm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
      body: const Center(
        child: Text('TODO - Implement'),
      ),
    );
  }
}