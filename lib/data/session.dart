enum SleepQuality {
  none;
}

class SleepSession {
  static const String fieldStarted = 'start_time';
  static const String fieldEnded = 'end_time';
  static const String fieldQuality = 'sleep_quality';

  DateTime started;
  DateTime ended;
  SleepQuality quality;

  SleepSession({
    required this.started,
    required this.ended,
    required this.quality,
  });

  factory SleepSession.copy(SleepSession another) => SleepSession(
      started: another.started, ended: another.ended, quality: another.quality);

  factory SleepSession.fromJson(Map json) => SleepSession(
        started: json[fieldStarted] ?? DateTime.fromMillisecondsSinceEpoch(0),
        ended: json[fieldEnded] ?? DateTime.fromMillisecondsSinceEpoch(0),
        quality: json[fieldQuality] ?? SleepQuality.none,
      );

  Map toJson() => {
        fieldStarted: started.millisecondsSinceEpoch,
        fieldEnded: ended.millisecondsSinceEpoch,
        fieldQuality: quality.name,
      };

  int durationInSecs() => (ended.difference(started)).inSeconds;
  int durationInMins() => (ended.difference(started)).inMinutes;
}
