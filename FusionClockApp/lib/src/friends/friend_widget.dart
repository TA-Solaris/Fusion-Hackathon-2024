import 'package:flutter/material.dart';
import 'package:fusionclock/src/models/userFriend.dart';

class FriendTile extends StatelessWidget {
  final UserFriend userFriend;
  final bool friendRequest;
  final Function? onAccept;
  final Function? onReject;
  const FriendTile(
      {super.key,
      required this.userFriend,
      required this.friendRequest,
      this.onAccept,
      this.onReject});

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [
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
        userFriend.username,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 20,
        ),
      )),
    ];

    //Friend request buttons
    if (friendRequest) {
      row.add(
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(),
                fixedSize: const Size.fromRadius(15)),
              onPressed: () {
                if (onAccept != null) onAccept!();
              },
              child: const Icon(Icons.done)),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(),
                fixedSize: const Size.fromRadius(15)),
              onPressed: () {
                if (onReject != null) onReject!();
              },
              child: const Icon(Icons.close))
          ]
        )
      );
    }

    return InkWell(
      child: Row(children: row),
    );
  }
}
