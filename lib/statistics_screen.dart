import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:intl/intl.dart';

import 'bar_graph/sleep_amount_bar.dart';
import 'line_graph/rating_line.dart';
import 'data/session.dart';
import 'data/history.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  DateTime _currentStartOfWeek = _getStartOfWeek(DateTime.now());

  static DateTime _getStartOfWeek(DateTime date) {
    int daysToSubtract = date.weekday % 7;
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentStartOfWeek = _currentStartOfWeek.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentStartOfWeek = _currentStartOfWeek.add(const Duration(days: 7));
    });
  }

  List<double> getAmounts(List<SleepSession> sessions) {
    List<double> result = List.filled(7, 0);
    for (var session in sessions) {
      if (session.ended.isAfter(_currentStartOfWeek.add(const Duration(days: 6)))
          || session.ended.isBefore(_currentStartOfWeek)) continue;
      int day = session.ended.weekday % 7;
      result[day] += session.durationInMins / 60;
    }
    return result;
  }

  List<int> getRatings(List<SleepSession> sessions) {
    List<int> result = [];
    for (var session in sessions) {
      if (session.ended.isAfter(_currentStartOfWeek.add(const Duration(days: 6)))
          || session.ended.isBefore(_currentStartOfWeek)) continue;
      result.add(session.quality.index);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final endOfWeek = _currentStartOfWeek.add(const Duration(days: 6));
    final sleepSessions = ref.watch(SleepSessionHistoryNotifier.provider).intervalInDays(Date.fromDateTime(_currentStartOfWeek), Date.fromDateTime(endOfWeek));
    // sessions to test
    /* final sleepSessions = [
      SleepSession(started: DateTime(2024, 7, 6, 21), ended: DateTime(2024, 7, 7, 7), quality: SleepQuality.none),
      SleepSession(started: DateTime(2024, 6, 30, 10), ended: DateTime(2024, 6, 30, 12), quality: SleepQuality.none),
    ]; */

    return Scaffold(
      appBar: AppBar(
        title: Text('${DateFormat.MMMd().format(_currentStartOfWeek)} - ${DateFormat.MMMd().format(endOfWeek)}'),
        actions: [
          IconButton(
            onPressed: _goToPreviousWeek,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            onPressed: _goToNextWeek,
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
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: SleepAmountBar(weeklySummary: getAmounts(sleepSessions)),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: RatingLine(weeklyRatings: getRatings(sleepSessions)),
            ),
          ],
        ),
      ),
    );
  }
}
