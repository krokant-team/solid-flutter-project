import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';

const int _weekDays = 7;

class ChosenSession extends Notifier<SleepSession?> {
  @override
  SleepSession? build() {
    return null;
  }

  choose(SleepSession session) {
    state = session;
  }
}

class _SessionButton extends ConsumerWidget {
  static const Radius _radius = Radius.circular(32);

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
          left: weekStart.isAfter(session.startDate) ? Radius.zero : _radius,
          right: weekEnd.isBefore(session.endDate) ? Radius.zero : _radius,
        ),
      ),
      elevation: isChosen ? 1.0 : 5.0,
      backgroundColor: isChosen
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: isChosen
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onPrimaryContainer,
    );
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
  late final SleepSessionHistory _history;

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
              date.formatDay,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              DateFormat.E().format(date.toDateTime()),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDates(SessionWeek week) {
    List<Widget> widgets = [];
    for (var date = week.start;
        !date.isAfter(week.end);
        date += const Duration(days: 1)) {
      widgets.add(Expanded(child: _buildWeekDate(date)));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
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
        !c.isAfter(week.end);
        c += const Duration(days: 1)) {
      if (!c.isBefore(iter.current.startDate) &&
          !c.isAfter(iter.current.endDate)) {
        if (space) {
          widgets.add(Spacer(flex: flex));
          space = false;
          flex = 0;
        }
        ++flex;
        if (c.isSameAs(iter.current.endDate)) {
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
            if (c.isBefore(week.end)) {
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
    final bool sameYear =
        week.start.toDateTime().year == week.end.toDateTime().year;
    final bool sameWeek =
        week.start.toDateTime().month == week.end.toDateTime().month;
    final String label = sameWeek
        ? "${DateFormat.MMMM().format(week.start.toDateTime())} ${week.start.toDateTime().year}"
        : "${DateFormat.MMMM().format(week.start.toDateTime())}${sameYear ? '' : ' ${week.start.toDateTime().year}'} — ${DateFormat.MMMM().format(week.end.toDateTime())} ${week.end.toDateTime().year}";
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              ref.read(weekProvider.notifier).previousWeek();
            },
          ),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
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
        child: icon,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
        ),
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WeekSwitch(weekProvider: weekProvider),
            Expanded(
              child: _WeekGrid(
                  weekProvider: weekProvider, chosenProvider: chosenProvider),
            ),
          ],
        ),
      ),
    );
  }
}
