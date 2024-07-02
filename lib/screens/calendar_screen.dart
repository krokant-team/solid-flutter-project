import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shleappy/data/date_patch.dart';
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';
import 'package:shleappy/ui/week_list.dart';

class CalendarScreen extends ConsumerWidget {
  final sleepWeekWidget = SleepWeekWidget();

  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosenProvider = sleepWeekWidget.chosenProvider;
    final SleepSession? chosen = ref.watch(chosenProvider);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: sleepWeekWidget,
          ),
          Expanded(
            flex: 5,
            child: _sessionInfoWithBorder(chosen, context, ref),
          ),
        ],
      ),
    );
  }

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

  String _formatDate(Date date) {
    String day = date.pday.toString().padLeft(2, '0');
    String month = date.pmonth.toString().padLeft(2, '0');
    String year = date.pyear.toString();

    return '$day.$month.$year';
  }

  Widget _sessionInfo(
    SleepSession? chosen,
    BuildContext context,
    WidgetRef ref,
  ) {
    String dateLabel = "";
    if (chosen != null) {
      dateLabel += " ${_formatDate(chosen.startDate)}";
      if (!chosen.startDate.pisSameAs(chosen.endDate)) {
        dateLabel += "–${_formatDate(chosen.endDate)}";
      }
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Sleep Session$dateLabel',
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
          _sessionDetailsItem(context,
              'Start time: ${chosen != null ? DateFormat.Hm().format(chosen.started) : ""}'),
          _sessionDetailsItem(context,
              'End Time: ${chosen != null ? DateFormat.Hm().format(chosen.ended) : ""}'),
          _sessionDetailsItem(context,
              'Quality rating: ${chosen != null ? chosen.quality : ""}'),
          _sessionDetailsItem(
              context, 'Comments: ${chosen != null ? chosen.comment : ""}'),
        ],
      ),
    );
  }

  Widget _sessionInfoWithBorder(
    SleepSession? chosen,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
                color: Theme.of(context).disabledColor.withOpacity(0.2),
                width: 4),
          ),
          padding: const EdgeInsets.all(16),
          child: _sessionInfo(chosen, context, ref),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Visibility.maintain(
            visible: chosen != null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                child: const Icon(Icons.delete),
                onPressed: () {
                  if (chosen != null) {
                    ref
                        .read(SleepSessionHistoryNotifier.provider.notifier)
                        .removeItem(chosen);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
