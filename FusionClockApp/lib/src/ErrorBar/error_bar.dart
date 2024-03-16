import 'package:flutter/material.dart';

void showFlashError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 60, // Adjust the height as needed
          padding: const EdgeInsets.all(8),
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
            ],
          ),
        ),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(24),
        ),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          backgroundColor: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
}