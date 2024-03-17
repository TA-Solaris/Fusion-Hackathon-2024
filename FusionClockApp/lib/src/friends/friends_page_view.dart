import 'package:flutter/material.dart';
import 'package:fusionclock/src/accounts_pages/decorated_field.dart';
import 'package:fusionclock/src/backend_interface/backend.dart';
import 'package:fusionclock/src/friends/friend_widget.dart';
import 'package:fusionclock/src/models/userFriend.dart';

class FriendsPageView extends StatefulWidget {
  const FriendsPageView({
    super.key,
  });

  static const routeName = '/friends';

  @override
  State<FriendsPageView> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPageView> with BackEnd {
  final TextEditingController searchController = TextEditingController();
  List<UserFriend> users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Row(
        children: [
          Expanded(
            child: DecoratedField(
              text: "Search Friends",
              icon: Icons.search,
              controller: searchController,
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
              onPressed: () async {
                List<UserFriend> foundUsers =
                    await searchUsers(searchController.text) ?? [];
                setState(() {
                  users = foundUsers;
                });
              },
              child: const Text(
                "GO",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
      const Divider()
    ];
    for (int i = 0; i < users.length; i++) {
      widgets.add(FriendTile(
        userFriend: users[i],
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
