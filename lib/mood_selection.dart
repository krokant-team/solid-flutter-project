import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/dialog_windows.dart';

class RatingStars extends StatelessWidget {
  final Function(int)? onRatingChanged;
  final int initialRating;
  final String leftCaption;
  final String rightCaption;
  TextStyle captionStyle = TextStyle(
      color: Colors.purple.withOpacity(0.8), fontWeight: FontWeight.w400);
  RatingStars(
      {super.key,
      this.onRatingChanged,
      this.initialRating = 1,
      required this.leftCaption,
      required this.rightCaption});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final rating = ref.watch(ratingProvider);

      void updateRating(int newRating) {
        ref.read(ratingProvider.notifier).state = newRating;
        if (onRatingChanged != null) {
          onRatingChanged!(newRating);
        }
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mood_bad, color: Theme.of(context).primaryColor),
          const SizedBox(
            width: 20,
          ),
          Row(
            children: List.generate(5, (index) {
              int starNumber = index + 1;
              return GestureDetector(
                onTap: () => updateRating(starNumber),
                child: Icon(
                  rating >= starNumber ? Icons.circle : Icons.circle_outlined,
                  color: rating >= starNumber
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(
            width: 15,
          ),
          Icon(Icons.mood, color: Theme.of(context).primaryColor)
        ],
      );
    });
  }
}
