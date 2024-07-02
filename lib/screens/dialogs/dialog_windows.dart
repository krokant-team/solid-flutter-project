import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/screens/dialogs/mood_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/screens/home_screen.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart' as dtp;

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
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                          ),
                        ),
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
                        ref
                            .read(SleepSessionHistoryNotifier.provider.notifier)
                            .putItem(SleepSession(
                                started: ref.read(startSleepTimeProvider),
                                ended: ref.read(endSleepTimeProvider),
                                quality: ref.read(ratingProvider),
                                comment: text));

                        ref.read(ratingProvider.notifier).state = 1;
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //TODO dev only!!
  static void showEditorDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text("Start time"),
                    onPressed: () {
                      dtp
                          .showOmniDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                      )
                          .then((value) {
                        ref.read(startSleepTimeProvider.notifier).state =
                            value!;
                      });
                    },
                  ),
                  TextButton(
                    child: const Text("End time"),
                    onPressed: () {
                      dtp
                          .showOmniDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                      )
                          .then((value) {
                        ref.read(endSleepTimeProvider.notifier).state = value!;
                      });
                    },
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
                          ),
                        ),
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
                        ref
                            .read(SleepSessionHistoryNotifier.provider.notifier)
                            .putItem(SleepSession(
                                started: ref.read(startSleepTimeProvider),
                                ended: ref.read(endSleepTimeProvider),
                                quality: ref.read(ratingProvider),
                                comment: text));

                        ref.read(ratingProvider.notifier).state = 1;
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
