import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'todo_screen.dart';
import 'journal_screen.dart';
import 'community_screen.dart';
import '../shared_widgets.dart'; // Points to lib/shared_widgets.dart

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    TodoScreen(),
    JournalScreenContent(),
    CommunityScreenContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        index: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        onAdd: () {},
      ),
    );
  }
}