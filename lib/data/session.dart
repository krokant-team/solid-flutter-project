class SleepSession {
  static const String fieldId = 'id';
  static const String fieldStarted = 'start_time';
  static const String fieldEnded = 'end_time';
  static const String fieldQuality = 'sleep_quality';
  static const String fieldComment = 'commentary';

  int id;
  DateTime started;
  DateTime ended;
  int quality;
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
    required this.id,
    required this.started,
    required this.ended,
    required this.quality,
    this.comment = '',
  }) {
    if (durationInHours >= 24) {
      throw const FormatException("Cannot create a sleep session");
    }
  }

  factory SleepSession.copy(SleepSession other) => SleepSession(
        id: other.id,
        started: other.started,
        ended: other.ended,
        quality: other.quality,
        comment: other.comment,
      );

  factory SleepSession.fromJson(Map json) => SleepSession(
        id: json[fieldId] ?? 0,
        started: DateTime.fromMillisecondsSinceEpoch(json[fieldStarted] ?? 0),
        ended: DateTime.fromMillisecondsSinceEpoch(json[fieldEnded] ?? 0),
        quality: json[fieldQuality] ?? 0,
        comment: json[fieldComment] ?? '',
      );

  Map toJson() => {
        fieldStarted: started.millisecondsSinceEpoch,
        fieldEnded: ended.millisecondsSinceEpoch,
        fieldQuality: quality,
        fieldComment: comment,
      };
}
