enum SleepQuality {
  none;

  static SleepQuality? parse(String string) {
    for (SleepQuality value in SleepQuality.values) {
      if (string == value.name) return value;
    }
    return null;
  }
}

class SleepSession {
  static const String fieldStarted = 'start_time';
  static const String fieldEnded = 'end_time';
  static const String fieldQuality = 'sleep_quality';
  static const String fieldComment = 'commentary';

  DateTime started;
  DateTime ended;
  SleepQuality quality;
  String comment;

  int get durationInSecs => (ended.difference(started)).inSeconds;
  int get durationInMins => (ended.difference(started)).inMinutes;
  int get durationInHours => (ended.difference(started)).inHours;

  SleepSession({
    required this.started,
    required this.ended,
    required this.quality,
    required this.comment,
  }) {
    if (durationInMins <= 0 || durationInHours >= 24) {
      throw FormatException("Cannot create a sleep session");
    }
  }

  factory SleepSession.copy(SleepSession another) => SleepSession(
        started: another.started,
        ended: another.ended,
        quality: another.quality,
        comment: another.comment,
      );

  factory SleepSession.fromJson(Map json) => SleepSession(
        started: DateTime.fromMillisecondsSinceEpoch(json[fieldStarted] ?? 0),
        ended: DateTime.fromMillisecondsSinceEpoch(json[fieldEnded] ?? 0),
        quality:
            SleepQuality.parse(json[fieldQuality] ?? '') ?? SleepQuality.none,
        comment: json[fieldComment] ?? '',
      );

  Map toJson() => {
        fieldStarted: started.millisecondsSinceEpoch,
        fieldEnded: ended.millisecondsSinceEpoch,
        fieldQuality: quality.name,
        fieldComment: comment,
      };
}
