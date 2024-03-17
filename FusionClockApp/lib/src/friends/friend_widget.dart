import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final String email;
  final bool friendRequest;
  final Function? onAccept;
  final Function? onReject;
  const FriendTile(
      {super.key,
      required this.email,
      required this.friendRequest,
      this.onAccept,
      this.onReject});

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [
      Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                fixedSize: const Size.fromRadius(50),
                padding: const EdgeInsets.only(left: 10, right: 10)),
            onPressed: () {},
            child: const Text(
              "",
            )),
      ),
      const SizedBox(
        width: 20,
      ),
      Expanded(
          child: Text(
        email,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 20,
        ),
      )),
    ];

    //Friend request buttons
    if (friendRequest) {
      row.addAll([
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(),
                fixedSize: const Size.fromRadius(25)),
            onPressed: () {
              onAccept!();
            },
            child: const Icon(Icons.done)),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(),
                fixedSize: const Size.fromRadius(25)),
            onPressed: () {
              onAccept!();
            },
            child: const Icon(Icons.close))
      ]);
    }

    return InkWell(
      child: Row(children: row),
    );
  }
}