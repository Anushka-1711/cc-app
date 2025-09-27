import 'package:flutter/material.dart';
import 'core/design/theme.dart';
import 'screens/main_app_screen.dart';

class CollegeConfessionsApp extends StatelessWidget {
  const CollegeConfessionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Confessions',
      theme: CCTheme.lightTheme,
      home: const MainAppScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
