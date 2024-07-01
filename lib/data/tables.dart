import 'package:shleappy/data/session.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initTables() async {
  await Hive.initFlutter();
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

  const SleepSessionTable._();

  static Future<void> init() async {
    await Hive.openBox<Map>(name);
    _instance = const SleepSessionTable._();
  }

  @override
  List<SleepSession> getItems() {
    return Hive.box<Map>(name)
        .values
        .map((e) => SleepSession.fromJson(e))
        .toList();
  }

  @override
  bool putItem(SleepSession item) {
    Hive.box<Map>(name).add(item.toJson());
    return true;
  }

  @override
  bool removeItem(SleepSession item) {
    final box = Hive.box<Map>(name);
    if (item.id == null ||
        item != SleepSession.fromJson(box.getAt(item.id!)!)) {
      return false;
    }
    box.deleteAt(item.id!);
    return true;
  }
}
