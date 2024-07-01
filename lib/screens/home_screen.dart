import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/dialog_windows.dart';

import '../main.dart';

final isSleepingProvider = StateProvider<bool>((ref) => false);
final themeProvider = StateProvider<ThemeData>((ref) => lightTheme);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  PreferredSizeWidget _homeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).splashColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _changeThemeButton(),
        ),
      ],
    );
  }

  Widget _changeThemeButton() {
    return Consumer(
      builder: (context, ref, child) {
        final currentTheme = ref.watch(themeProvider);
        return IconButton(
          alignment: Alignment.center,
          icon: Icon(
            currentTheme.focusColor == Colors.white
                ? Icons.wb_sunny
                : Icons.nightlight_round,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (currentTheme.focusColor == Colors.white) {
              ref.read(themeProvider.notifier).state = lightTheme;
            } else {
              ref.read(themeProvider.notifier).state = darkTheme;
            }
          },
        );
      },
    );
  }

  Widget _contentElevatedButton(
      BuildContext context, WidgetRef ref, double screenWidth) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Icon(
        ref.watch(isSleepingProvider)
            ? Icons.stop_rounded
            : Icons.play_arrow_rounded,
        key: ValueKey<bool>(ref.watch(isSleepingProvider)),
        size: screenWidth * 0.28,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  ButtonStyle _styleElevatedButton(BuildContext context, double screenWidth) {
    return ElevatedButton.styleFrom(
      alignment: Alignment.center,
      fixedSize: Size(screenWidth * 0.36, screenWidth * 0.36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.1),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      disabledBackgroundColor: Theme.of(context).disabledColor,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _homeAppBar(context),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (ref.read(isSleepingProvider)) {
              DialogWindows.showFeedbackDialog(context, ref);
            }
            ref.read(isSleepingProvider.notifier).state =
                !ref.watch(isSleepingProvider);
          },
          style: _styleElevatedButton(context, screenWidth),
          child: _contentElevatedButton(context, ref, screenWidth),
        ),
      ),
    );
  }
}
