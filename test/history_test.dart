import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';

void main() {
  test('History should sort by start time ascending, then give a week interval',
      () {
    var starts = '03,11,06,08,13,14,15,16,17,01,12,05,04,07,18,19'
        .split(',')
        .map((e) => DateTime.parse('2024-01-$e 21:00'))
        .toList();
    var ends = '04,12,07,09,14,15,16,17,18,02,13,06,05,08,19,20'
        .split(',')
        .map((e) => DateTime.parse('2024-01-$e 08:00'))
        .toList();
    var sessionList = <SleepSession>[];
    for (int i = 0; i < starts.length; ++i) {
      sessionList.add(SleepSession(
        started: starts[i],
        ended: ends[i],
        quality: 0,
      ));
    }
    var history = SleepSessionHistory(sessionList);
    expect(history.sessions.first.started.day, 1);
    expect(history.sessions.last.started.day, 19);
    var sessionWeek = history.getSessionWeek(Date(2024, 01, 01));
    expect(sessionWeek.sessions.map((e) => e.started.day).toList(),
        [1, 3, 4, 5, 6, 7]);
  });
}
