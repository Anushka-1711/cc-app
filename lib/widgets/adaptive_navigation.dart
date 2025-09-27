import 'package:flutter/material.dart';

class AdaptiveNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const AdaptiveNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class AdaptiveBottomNavigation extends StatelessWidget {
  final List<AdaptiveNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdaptiveBottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFF0095F6),
      unselectedItemColor: const Color(0xFF8E8E8E),
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              ))
          .toList(),
    );
  }
}
