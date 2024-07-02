import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/data/tables.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class CalendarScreen extends ConsumerWidget {
  CalendarScreen({super.key});
  SleepSession? session;
  Widget _sessionDetailsItem(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).disabledColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'CupertinoSystemDisplay'),
    );
  }

  String _formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    return '$day.$month.$year';
  }

  Widget _calendar(BuildContext context, WidgetRef ref,
      {void Function(DateTime, DateTime)? onDaySelected}) {
    DateTime time = ref.read(focusedDayProvider);
    int id = int.parse(DateFormat('ddMMyyyy').format(time));
    session = SleepSessionTable.instance.getItemById(id);
    return TableCalendar(
      focusedDay: ref.watch(focusedDayProvider),
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2029, 12, 31),
      headerStyle: _calendarHeaderStyle(context),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) =>
          isSameDay(day, ref.watch(focusedDayProvider)),
      onDaySelected: onDaySelected,
      calendarStyle: _calendarStyle(context),
      daysOfWeekStyle: _daysOfWeekStyle(),
    );
  }

  HeaderStyle _calendarHeaderStyle(BuildContext context) {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w900,
          fontFamily: 'CupertinoSystemDisplay',
          color: Theme.of(context).focusColor),
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: Theme.of(context).focusColor,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: Theme.of(context).focusColor,
      ),
    );
  }

  CalendarStyle _calendarStyle(BuildContext context) {
    return CalendarStyle(
      selectedDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor, shape: BoxShape.circle),
      todayDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.8),
          shape: BoxShape.circle),
      defaultTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).focusColor),
      weekendTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).disabledColor),
      selectedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).scaffoldBackgroundColor),
      outsideTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Theme.of(context).shadowColor),
      todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).scaffoldBackgroundColor),
    );
  }

  DaysOfWeekStyle _daysOfWeekStyle() {
    return const DaysOfWeekStyle(
      weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
      weekendStyle: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _sessionInfo(
      BuildContext context, WidgetRef ref, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Sleep Session ${_formatDate(ref.watch(focusedDayProvider))}',
            style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontFamily: 'CupertinoSystemDisplay'),
          ),
        ),
        Divider(
          color: Theme.of(context).disabledColor.withOpacity(0.2),
          thickness: 3,
        ),
        SizedBox(
          height: screenHeight * 0.005,
        ),
        _sessionDetailsItem(context,
            'Start time: ${session != null ? DateFormat("HH:mm").format(session!.started) : ""}'),
        _sessionDetailsItem(context,
            'End Time: ${session != null ? DateFormat("HH:mm").format(session!.ended) : ""}'),
        _sessionDetailsItem(context,
            'Quality rating: ${session != null ? session!.quality : ""}'),
        _sessionDetailsItem(
            context, 'Comments: ${session != null ? session!.comment : ""}'),
      ],
    );
  }

  Widget _sessionInfoWithBorder(BuildContext context, WidgetRef ref,
      double screenHeight, double screenWidth) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Theme.of(context).disabledColor.withOpacity(0.2),
              width: 4),
        ),
        width: screenWidth * 0.84,
        padding: EdgeInsets.only(
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
            top: screenHeight * 0.01,
            bottom: screenHeight * 0.01),
        child: _sessionInfo(context, ref, screenHeight));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void onDaySelected(DateTime day, DateTime focusedDay) {
      ref.read(focusedDayProvider.notifier).state = day;
    }

    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                top: screenHeight * 0.04,
                bottom: screenHeight * 0.04),
            child: _calendar(context, ref, onDaySelected: onDaySelected),
          ),
          Expanded(
              child: _sessionInfoWithBorder(
                  context, ref, screenHeight, screenWidth)),
          SizedBox(
            height: screenHeight * 0.005,
          ),
        ],
      ),
    );
  }
}
