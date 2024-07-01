import 'package:date_only_field/date_only_field_with_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/data/history.dart';
import 'package:shleappy/data/session.dart';

class _ChosenSession extends Notifier<SleepSession?> {
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
  final NotifierProvider<_ChosenSession, SleepSession?> chosenProvider;

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

class _WeekGrid extends ConsumerWidget {
  static const int days = 7;
  static const double _rowheight = 75;

  final chosenProvider =
      NotifierProvider<_ChosenSession, SleepSession?>(() => _ChosenSession());
  final Date start;
  final Date end;

  _WeekGrid(this.start) : end = start + const Duration(days: days - 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final week = ref
        .watch(SleepSessionHistoryNotifier.provider)
        .intervalInDays(start, end);
    return Stack(
      fit: StackFit.expand,
      children: [
        buildLayoutMat(),
        SingleChildScrollView(child: buildButtonGrid(ref, week)),
      ],
    );
  }

  Widget buildLayoutMat() {
    List<Widget> children = [const Spacer()];
    for (int i = 1; i < days; ++i) {
      children.add(const VerticalDivider(thickness: 2, width: 0));
      children.add(const Spacer());
    }
    return Row(mainAxisSize: MainAxisSize.max, children: children);
  }

  Widget buildButtonRow(WidgetRef ref, List<SleepSession> row) {
    var iter = row.iterator;
    if (!iter.moveNext()) {
      return const Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Spacer()],
      );
    }
    List<Widget> widgets = [];
    var flex = 0;
    var space = false;
    for (Date c = start; !c.isAfter(end); c += const Duration(days: 1)) {
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
                weekStart: start,
                weekEnd: end,
                chosenProvider: chosenProvider,
              )));
          flex = 0;
          if (!iter.moveNext()) {
            if (c.isBefore(end)) {
              widgets.add(Spacer(flex: end.difference(c).inDays));
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
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }

  Widget buildButtonGrid(WidgetRef ref, List<SleepSession> week) {
    List<List<SleepSession>> rows = [[], [], []];
    for (SleepSession session in week) {
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
      mainAxisSize: MainAxisSize.min,
      children: rows
          .map((e) => SizedBox.fromSize(
              size: const Size.fromHeight(_rowheight),
              child: buildButtonRow(ref, e)))
          .toList(),
    );
  }
}
