import 'package:flutter/material.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/map/presentation/map_page.dart';
import '../../features/guide/presentation/guide_page.dart';
import '../../features/bot/presentation/bot_page.dart';
import '../../features/accessibility/presentation/accessibility_page.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MapPage(),
    GuidePage(),
    BotPage(),
    AccessibilityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Guía',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'EcoBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_outlined),
            activeIcon: Icon(Icons.accessibility_new),
            label: 'Accesible',
          ),
        ],
      ),
    );
  }
}