import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/data/history.dart';
import 'package:hello_flutter/data/session.dart';

void main() {
  test('History should sort by start time ascending, then give a week interval',
      () {
    var starts = '03,01,12,05,04,07,11,06,08'
        .split(',')
        .map((e) => DateTime.parse('2024-01-$e 21:00'))
        .toList();
    var ends = '04,02,13,06,05,08,12,07,09'
        .split(',')
        .map((e) => DateTime.parse('2024-01-$e 08:00'))
        .toList();
    var sessionList = <SleepSession>[];
    for (int i = 0; i < starts.length; ++i) {
      sessionList.add(SleepSession(
        started: starts[i],
        ended: ends[i],
        quality: SleepQuality.none,
      ));
    }
    var history = SleepSessionHistory(sessionList);
    expect(history.sessions.first.started.day, 1);
    expect(history.sessions.last.started.day, 12);
    var interval =
        history.intervalInDays(DateTime(2024, 01, 01), DateTime(2024, 01, 07));
    expect(interval.map((e) => e.started.day).toList(), [1, 3, 4, 5, 6, 7]);
  });
}
