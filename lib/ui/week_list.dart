import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shleappy/data/date_patch.dart';
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';

const int _weekDays = 7;

class ChosenSession extends Notifier<SleepSession?> {
  @override
  SleepSession? build() {
    return null;
  }

  choose(SleepSession? session) {
    state = session;
  }
}

class _SessionButton extends ConsumerWidget {
  static const Radius _radius = Radius.circular(64);

  final SleepSession session;
  final Date weekStart;
  final Date weekEnd;
  final NotifierProvider<ChosenSession, SleepSession?> chosenProvider;

  const _SessionButton(
    this.session, {
    required this.weekStart,
    required this.weekEnd,
    required this.chosenProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChosen = session.hashCode == ref.watch(chosenProvider).hashCode;
    final style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: weekStart.pisAfter(session.startDate) ? Radius.zero : _radius,
          right: weekEnd.pisBefore(session.endDate) ? Radius.zero : _radius,
        ),
      ),
      padding: const EdgeInsets.all(2),
      elevation: isChosen ? 1.0 : 5.0,
      backgroundColor: isChosen
          ? Theme.of(context).primaryColor
          : Theme.of(context).disabledColor,
      // foregroundColor: isChosen
      //     ? Theme.of(context).focusColor
      //     : Theme.of(context).focusColor,
      foregroundColor: Colors.white,
      shadowColor: Theme.of(context).shadowColor,
    );
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: style,
        onPressed: () {
          ref.read(chosenProvider.notifier).choose(session);
        },
        child: Text('${session.durationInHours}'),
      ),
    );
  }
}

class ChosenWeek extends Notifier<SessionWeek> {
  late SleepSessionHistory _history;

  @override
  SessionWeek build() {
    _history = ref.watch(SleepSessionHistoryNotifier.provider);
    return _history.getSessionWeek(Date.now());
  }

  nextWeek() {
    state = _history.getSessionWeek(state.next().start);
  }

  previousWeek() {
    state = _history.getSessionWeek(state.previous().start);
  }
}

class _WeekGrid extends ConsumerWidget {
  final NotifierProvider<ChosenWeek, SessionWeek> weekProvider;
  final NotifierProvider<ChosenSession, SleepSession?> chosenProvider;

  const _WeekGrid({required this.weekProvider, required this.chosenProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(weekProvider);
    WidgetsBinding.instance.addPostFrameCallback((d) {
      ref.read(chosenProvider.notifier).choose(null);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildWeekDates(week),
        Expanded(
          child: Stack(
            children: [
              _buildLayoutMat(),
              _buildButtonGrid(ref, week),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDate(Date date) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          children: [
            Text(
              date.pday.toString().padRight(2),
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat.E().format(date.toDateTime()),
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDates(SessionWeek week) {
    List<Widget> widgets = [];
    for (var date = week.start;
        !date.pisAfter(week.end);
        date += const Duration(days: 1)) {
      widgets.add(Expanded(child: _buildWeekDate(date)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: widgets,
      ),
    );
  }

  Widget _buildLayoutMat() {
    List<Widget> children = [const Spacer()];
    for (int i = 1; i < _weekDays; ++i) {
      children.add(const VerticalDivider(thickness: 2, width: 0));
      children.add(const Spacer());
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget _buildButtonRow(WidgetRef ref, List<SleepSession> row,
      {required SessionWeek week}) {
    var iter = row.iterator;
    if (!iter.moveNext()) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Spacer()],
      );
    }
    List<Widget> widgets = [];
    var flex = 0;
    var space = false;
    for (Date c = week.start;
        !c.pisAfter(week.end);
        c += const Duration(days: 1)) {
      if (!c.pisBefore(iter.current.startDate) &&
          !c.pisAfter(iter.current.endDate)) {
        if (space) {
          widgets.add(Spacer(flex: flex));
          space = false;
          flex = 0;
        }
        ++flex;
        if (c.pisSameAs(iter.current.endDate) || c.pisSameAs(week.end)) {
          widgets.add(Flexible(
              fit: FlexFit.tight,
              flex: flex,
              child: _SessionButton(
                iter.current,
                weekStart: week.start,
                weekEnd: week.end,
                chosenProvider: chosenProvider,
              )));
          flex = 0;
          if (!iter.moveNext()) {
            if (c.pisBefore(week.end)) {
              widgets.add(Spacer(flex: week.end.difference(c).inDays));
              break;
            }
          }
        }
      } else {
        space = true;
        ++flex;
      }
    }
    if (space) {
      widgets.add(Spacer(flex: flex));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget _buildButtonGrid(WidgetRef ref, SessionWeek week) {
    List<List<SleepSession>> rows = [[], [], []];
    for (SleepSession session in week.sessions) {
      bool f = false;
      for (List<SleepSession> row in rows) {
        if (row.isEmpty || row.last.endDate.isBefore(session.startDate)) {
          row.add(session);
          f = true;
          break;
        }
      }
      if (!f) {
        rows.add([session]);
      }
    }
    return Column(
      children: rows
          .map((e) => Expanded(child: _buildButtonRow(ref, e, week: week)))
          .toList(),
    );
  }
}

class WeekSwitch extends ConsumerWidget {
  final NotifierProvider<ChosenWeek, SessionWeek> weekProvider;

  const WeekSwitch({required this.weekProvider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref.watch(weekProvider);
    final bool sameYear = week.start.pyear == week.end.pyear;
    final bool sameWeek = week.start.pmonth == week.end.pmonth;
    final String label = sameWeek
        ? "${DateFormat.MMMM().format(week.start.toDateTime())} ${week.start.pyear}"
        : "${DateFormat.MMMM().format(week.start.toDateTime())}${sameYear ? '' : ' ${week.start.pyear}'} — ${DateFormat.MMMM().format(week.end.toDateTime())} ${week.end.pyear}";
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              ref.read(weekProvider.notifier).previousWeek();
            },
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              ref.read(weekProvider.notifier).nextWeek();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
          {required Icon icon, required void Function()? onPressed}) =>
      OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
        ),
        child: icon,
      );
}

class SleepWeekWidget extends ConsumerWidget {
  final NotifierProvider<ChosenWeek, SessionWeek> weekProvider =
      NotifierProvider(() => ChosenWeek());
  final NotifierProvider<ChosenSession, SleepSession?> chosenProvider =
      NotifierProvider(() => ChosenSession());

  SleepWeekWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeekSwitch(weekProvider: weekProvider),
        Expanded(
          child: _WeekGrid(
              weekProvider: weekProvider, chosenProvider: chosenProvider),
        ),
      ],
    );
  }
}
