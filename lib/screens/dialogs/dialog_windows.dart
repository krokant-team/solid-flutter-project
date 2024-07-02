import 'package:flutter/material.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/data/tables.dart';
import 'package:shleappy/screens/dialogs/mood_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/screens/home_screen.dart';
import 'package:intl/intl.dart';

final ratingProvider = StateProvider<int>((ref) => 1);

class DialogWindows {
  static void showFeedbackDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 35,
                ),
                Text("How did you sleep?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).focusColor)),
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
                Text("Leave additional comments",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        color: Theme.of(context).shadowColor)),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: Theme.of(context).focusColor),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).shadowColor,
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 60,
                  width: 170,
                  child: OutlinedButton(
                      onPressed: () {
                        String text = controller.text;

                        int id = int.parse(
                            DateFormat('ddMMyyyy').format(DateTime.now()));
                        SleepSessionTable.instance.putItem(SleepSession(
                            id: id,
                            started: ref.read(startSleepTimeProvider),
                            ended: ref.read(endSleepTimeProvider),
                            quality: ref.read(ratingProvider),
                            comment: text));

                        ref.read(ratingProvider.notifier).state = 1;
                        Navigator.of(context).pop();
                      },
                      child: Text("Proceed",
                          style:
                              TextStyle(color: Theme.of(context).focusColor))),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            )),
          );
        });
  }
}
