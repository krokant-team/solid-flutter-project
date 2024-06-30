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
  static const String fieldId = 'id';
  static const String fieldStarted = 'start_time';
  static const String fieldEnded = 'end_time';
  static const String fieldQuality = 'sleep_quality';
  static const String fieldComment = 'commentary';

  int? id;
  DateTime started;
  DateTime ended;
  SleepQuality quality;
  String comment;

  @override
  int get hashCode =>
      started.millisecondsSinceEpoch + ended.millisecondsSinceEpoch;
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SleepSession &&
        started == other.started &&
        ended == other.ended &&
        quality == other.quality &&
        comment == other.comment;
  }

  int get durationInSecs => (ended.difference(started)).inSeconds;
  int get durationInMins => (ended.difference(started)).inMinutes;
  int get durationInHours => (ended.difference(started)).inHours;

  SleepSession({
    this.id,
    required this.started,
    required this.ended,
    required this.quality,
    this.comment = '',
  }) {
    if (durationInMins <= 0 || durationInHours >= 24) {
      throw const FormatException("Cannot create a sleep session");
    }
  }

  factory SleepSession.copy(SleepSession other) => SleepSession(
        started: other.started,
        ended: other.ended,
        quality: other.quality,
        comment: other.comment,
      );

  factory SleepSession.fromJson(Map json) => SleepSession(
        id: json[fieldId],
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
