import 'package:flutter/material.dart';

void showFlashError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        height: 60, // Adjust the height as needed
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      duration: Duration(seconds: 3),
    ),
  );
}

