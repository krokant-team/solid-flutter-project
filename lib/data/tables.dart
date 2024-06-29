import 'dart:async';

import 'package:hello_flutter/data/session.dart';
import 'package:hive/hive.dart';

Future<void> initTables() async {
  await Future.wait([
    SleepSessionTable.init(),
  ]);
}

abstract interface class Table<T> {
  List<T> getValues();
  putValue(T value);
}

class SleepSessionTable implements Table<SleepSession> {
  static const String name = 'sleep_session';

  static SleepSessionTable? _instance;

  static SleepSessionTable get instance {
    if (_instance == null) {
      init();
      throw Exception('SleepSessionTable was not initialized');
    }
    return _instance!;
  }

  SleepSessionTable._();

  static Future<void> init() async {
    await Hive.openBox(name);
    _instance = SleepSessionTable._();
  }

  @override
  List<SleepSession> getValues() {
    return Hive.box(name).values.map((e) => SleepSession.fromJson(e)).toList();
  }

  @override
  putValue(SleepSession value) {
    Hive.box(name).add(value.toJson());
  }
}
