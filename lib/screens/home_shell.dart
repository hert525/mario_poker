import 'package:flutter/material.dart';

import 'hall_screen.dart';
import 'profile_screen.dart';
import 'room_screen.dart';
import 'table_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _pages = const [
    HallScreen(),
    RoomScreen(),
    TableScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: '大厅'),
          NavigationDestination(icon: Icon(Icons.meeting_room_rounded), label: '房间'),
          NavigationDestination(icon: Icon(Icons.style_rounded), label: '牌桌'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: '我的'),
        ],
        onDestinationSelected: (value) => setState(() => _currentIndex = value),
      ),
    );
  }
}
