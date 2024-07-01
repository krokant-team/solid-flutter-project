import 'package:flutter/material.dart';
import 'package:hello_flutter/mood_selection_screen.dart';

class DialogWindows {
  static void showFeedbackDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 35,
                ),
                const Text("How did you sleep?",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w200)),
                const SizedBox(
                  height: 35,
                ),
                RatingStars(
                  leftCaption: "Terrible",
                  rightCaption: "Great",
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text("Leave additional comments",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            )),
          );
        });
  }
}
