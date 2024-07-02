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
  T? getItemById(int id);
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
    SleepSession existing = Hive.box(name).get(item.id);
    if (existing != null) {
      if (existing.durationInSecs < item.durationInSecs) {
        Hive.box(name).put(item.id, item.toJson());
        return true;
      }
      return false;
    }
    Hive.box(name).put(item.id, item.toJson());
    return true;
  }

  @override
  bool removeItem(SleepSession item) {
    if (item.id == null) {
      return false;
    }
    Hive.box(name).delete(item.id!);
    return true;
  }

  @override
  SleepSession? getItemById(int id) {
    var box = Hive.box(name);
    var json = box.get(id);
    if (json != null) {
      return SleepSession.fromJson(json);
    }
    return null;
  }
}
