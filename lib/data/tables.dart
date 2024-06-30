import 'package:shleappy/data/session.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initTables() async {
  await Future.wait([
    SleepSessionTable.init(),
  ]);
}

abstract interface class Table<T> {
  List<T> getItems();
  putItem(T item);
  removeItem(T item);
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
  List<SleepSession> getItems() {
    return Hive.box(name).values.map((e) => SleepSession.fromJson(e)).toList();
  }

  @override
  bool putItem(SleepSession item) {
    Hive.box(name).add(item.toJson());
    return true;
  }

  @override
  bool removeItem(SleepSession item) {
    if (item.id == null || item != Hive.box(name).getAt(item.id!)) {
      return false;
    }
    Hive.box(name).deleteAt(item.id!);
    return true;
  }
}
