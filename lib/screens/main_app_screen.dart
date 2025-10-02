import 'package:flutter/material.dart';
import 'communities/communities_screen.dart';
import 'create_post/create_post_screen.dart';
import 'home/home_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';
import '../core/utils/adaptive_icons.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CommunitiesScreen(),
    const CreatePostScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF0095F6),
        unselectedItemColor: const Color(0xFF8E8E8E),
        items: [
          BottomNavigationBarItem(
            icon: Icon(AdaptiveIcons.home),
            activeIcon: Icon(AdaptiveIcons.homeActive),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(AdaptiveIcons.groups),
            activeIcon: Icon(AdaptiveIcons.groupsActive),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(AdaptiveIcons.add),
            activeIcon: Icon(AdaptiveIcons.addActive),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(AdaptiveIcons.notifications),
            activeIcon: Icon(AdaptiveIcons.notificationsActive),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(AdaptiveIcons.person),
            activeIcon: Icon(AdaptiveIcons.personActive),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
