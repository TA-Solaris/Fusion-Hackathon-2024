import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../settings/settings_view.dart';
import 'home_page_stat.dart';

/// Displays a list of SampleItems.
class HomePageView extends StatelessWidget {
  const HomePageView({
    super.key,
    this.items = const [HomePageStatItem(1), HomePageStatItem(2)],
  });

  static const routeName = '/';

  final List<HomePageStatItem> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> topWidgets = [
      Container(
        child: Text('14:19:23'),
      ),
      const Text('Alarm Time')
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('FusionClock'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
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
