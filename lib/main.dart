import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shleappy/data/tables.dart';
import 'package:shleappy/screens/home_screen.dart';
import 'navigation_widget.dart';

Future<void> main() async {
  await initTables();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeProvider),
      home: const BottomNavigationWidget(),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.indigoAccent,
  disabledColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  focusColor: Colors.black,
  shadowColor: Colors.grey,
  splashColor: const Color.fromRGBO(245, 245, 245, 1),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.indigo,
  disabledColor: Colors.indigoAccent,
  scaffoldBackgroundColor: const Color.fromRGBO(26, 26, 26, 1),
  focusColor: Colors.white,
  shadowColor: Colors.grey,
  splashColor: const Color.fromRGBO(33, 33, 33, 1),
);
