import 'package:flutter/material.dart';

import 'bar_graph/sleep_amount_bar.dart';
import 'line_graph/rating_line.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Put week dates here'),
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
      ),
      body: Center(
        child: Column(
          // add here some nice aligment pls
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: const SleepAmountBar(weeklySummary: [5, 8, 9, 7, 6, 8, 10]),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: const RatingLine(weeklyRatings: [3, 0, 2, -1, -5, 4, 2, 5, 0, 1]),
            ),
          ],
        ),
      ),
    );
  }
}
