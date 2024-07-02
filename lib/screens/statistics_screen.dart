import 'package:flutter/material.dart';

import 'package:shleappy/bar_graph/sleep_amount_bar.dart';
import 'package:shleappy/line_graph/rating_line.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Put week dates here',
          style: TextStyle(color: Theme.of(context).focusColor),
        ), // TODO put weeks dates

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_left),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right),
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),

            Text(
              'Sleep Hours per Day',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'CupertinoSystemDisplay',
                  color: Theme.of(context).focusColor),
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),

            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child:
                  const SleepAmountBar(weeklySummary: [5, 8, 9, 7, 6, 8, 10]),
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),

            Text(
              'Sleep Rating',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'CupertinoSystemDisplay',
                  color: Theme.of(context).focusColor),
            ),

            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),

            Container(
              height: screenHeight * 0.3,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2), width: 4),
                borderRadius: BorderRadius.circular(12.0),
              ),

              padding: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                  top: screenHeight * 0.03,
                  bottom: screenHeight * 0.03),
              child: const RatingLine(
                  weeklyRatings: [3, 0, 2, -1, -5, 4, 2, 5, 0, 1]),
            ),
          ],
        ),
      ),
    );
  }
}
