import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_flutter/data/session.dart';
import 'package:hello_flutter/data/tables.dart';

class SleepSessionHistory {
  List<SleepSession> _sessions;

  List<SleepSession> get sessions => _sessions;

  SleepSessionHistory(List<SleepSession> sessions) : _sessions = sessions {
    _sessions.sort((a, b) => a.started.compareTo(b.started));
  }

  factory SleepSessionHistory.fromTable() =>
      SleepSessionHistory(SleepSessionTable.instance.getItems());

  List<SleepSession> intervalInDays(DateTime start, DateTime end) {
    if (_sessions.isEmpty) return [];
    var iEnd = _sessions.lowerBoundBy<DateTime>(
      SleepSession.copy(_sessions[0])..started = start,
      (e) => e.started,
    );
    do {
      ++iEnd;
    } while (iEnd < _sessions.length &&
        _sessions[iEnd].started.difference(end).inDays <= 0);
    var iStart = iEnd;
    while (iStart > 0 &&
        _sessions[iStart - 1].ended.difference(start).inDays >= 0) {
      --iStart;
    }
    return _sessions.sublist(iStart, iEnd);
  }
}

class SleepSessionHistoryNotifier extends Notifier<SleepSessionHistory> {
  bool _isListened = false;

  @override
  SleepSessionHistory build() {
    _isListened = true;
    ref.onCancel(() {
      _isListened = false;
    });
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
