import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/decorated_field.dart';
import 'package:fusionclock/src/friends/friend_widget.dart';

class FriendsPageView extends StatefulWidget {
  const FriendsPageView({
    super.key,
  });

  static const routeName = '/friends';

  @override
  State<FriendsPageView> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Row(
        children: [
          const Expanded(
            child: DecoratedField(
              text: "Search Friends",
              icon: Icons.search,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  fixedSize: const Size.fromRadius(25),
                  padding: const EdgeInsets.only(left: 10, right: 10)),
              onPressed: () {},
              child: const Text(
                "GO",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
      Divider()
    ];
    for (int i = 0; i < 4; i++) {
      widgets.add(const FriendTile(
        email: "email@email.com",
        friendRequest: true,
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            }),
      ),
    );
  }
}
