import 'package:hello_flutter/data/session.dart';
import 'package:hive/hive.dart';

Future<void> initTables() async {
  await Future.wait([
    SleepSessionTable.init(),
  ]);
}

class SleepSessionTable {
  static const String name = 'sleep_session';

  SleepSessionTable._();

  static Future<void> init() async {
    Hive.openBox(name);
  }

  static List<SleepSession> getValues() {
    return Hive.box(name).values.map((e) => SleepSession.fromJson(e)).toList();
  }
}
