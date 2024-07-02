import 'package:date_only_field/date_only_field_with_extensions.dart';

extension DatePatch on Date {
  int get pday => toDateTime().day;
  int get pmonth => toDateTime().month;
  int get pyear => toDateTime().year;
  int get pweekday => toDateTime().weekday;

  int diff(Date other) => toDateTime().difference(other.toDateTime()).inDays;
  bool pisAfter(Date other) => diff(other) > 0;
  bool pisBefore(Date other) => diff(other) < 0;
  bool pisSameAs(Date other) => diff(other) == 0;
}
