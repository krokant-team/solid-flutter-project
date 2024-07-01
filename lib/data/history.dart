import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/data/tables.dart';

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
      var d = _sessions[mid].startDate;
      if (date.isSameAs(d) || mid == start) {
        break;
      } else if (date.isAfter(d)) {
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
    while (iStart > 0 && start.isBefore(_sessions[iStart - 1].endDate)) {
      --iStart;
    }
    return _sessions.sublist(iStart, iEnd);
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
