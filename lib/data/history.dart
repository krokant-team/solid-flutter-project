import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/data/tables.dart';

class SessionWeek {
  static const int weekDays = 7;

  List<SleepSession> sessions = [];
  Date start;
  Date end;

  SessionWeek(Date anyDate)
      : start = getWeekStart(anyDate),
        end = getWeekEnd(anyDate);

  static Date getWeekStart(Date date) =>
      date - Duration(days: date.weekday - DateTime.monday);
  static Date getWeekEnd(Date date) =>
      date + Duration(days: DateTime.sunday - date.weekday);
  SessionWeek next() => SessionWeek(start + const Duration(days: weekDays));
  SessionWeek previous() => SessionWeek(start - const Duration(days: weekDays));
}

class SleepSessionHistory {
  List<SleepSession> _sessions;

  List<SleepSession> get sessions => _sessions;

  SleepSessionHistory(List<SleepSession> sessions) : _sessions = sessions {
    _sessions.sort((a, b) => a.started.compareTo(b.started));
  }

  factory SleepSessionHistory.fromTable() =>
      SleepSessionHistory(SleepSessionTable.instance.getItems());

  int _findStartingDate(Date date) {
    if (_sessions.isEmpty) return -1;
    var start = 0, end = _sessions.length;
    var mid = (end + start) ~/ 2;
    while (true) {
      var d = _sessions[mid].startDate.difference(date).inDays;
      if (d == 0 || mid == start) {
        break;
      } else if (d < 0) {
        start = mid;
        mid = (end + start) ~/ 2;
      } else {
        end = mid;
        mid = (end + start) ~/ 2;
      }
    }
    do {
      ++mid;
    } while (mid < end && date.isSameAs(_sessions[mid].startDate));
    return mid;
  }

  List<SleepSession> intervalInDays(Date start, Date end) {
    if (_sessions.isEmpty) return [];
    var iEnd = _findStartingDate(end);
    var iStart = iEnd;
    while (iStart > 0 && !start.toDateTime().isAfter(_sessions[iStart - 1].endDate.toDateTime())) {
      --iStart;
    }
    return _sessions.sublist(iStart, iEnd);
  }

  SessionWeek getSessionWeek(Date date) {
    var sessionWeek = SessionWeek(date);
    sessionWeek.sessions = intervalInDays(sessionWeek.start, sessionWeek.end);
    return sessionWeek;
  }
}

class SleepSessionHistoryNotifier extends Notifier<SleepSessionHistory> {
  static final provider =
      NotifierProvider<SleepSessionHistoryNotifier, SleepSessionHistory>(
          () => SleepSessionHistoryNotifier());

  bool _isListened = false;

  @override
  SleepSessionHistory build() {
    _isListened = true;
    ref.onCancel(() {
      _isListened = false;
    });
    // TODO check whether onResume method is called on ref.read(...)
    ref.onResume(() {
      _isListened = true;
      update();
    });
    return SleepSessionHistory.fromTable();
  }

  update() {
    if (_isListened) {
      state = SleepSessionHistory.fromTable();
    }
  }

  putItem(SleepSession item) {
    SleepSessionTable.instance.putItem(item);
    update();
  }

  removeItem(SleepSession item) {
    SleepSessionTable.instance.removeItem(item);
    update();
  }
}
