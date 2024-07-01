import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shleappy/screens/calendar_screen.dart';
import 'package:shleappy/screens/home_screen.dart';
import 'package:shleappy/screens/statistics_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  static const List<Widget> _pagesOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    StatisticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pagesOptions.elementAt(_currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).splashColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistics',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.indigoAccent,
          unselectedItemColor: Colors.indigo,
          selectedLabelStyle: const TextStyle(color: Colors.indigoAccent),
          unselectedLabelStyle: const TextStyle(color: Colors.indigo),
        ));
  }
}
