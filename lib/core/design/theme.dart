import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'design_system.dart';

/// College Confessions App Theme Configuration
/// 
/// Provides light and dark themes with proper Material 3 theming
/// using the College Confessions design system tokens.

class CCTheme {
  CCTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CCDesignSystem.primaryBlue,
        brightness: Brightness.light,
        primary: CCDesignSystem.primaryBlue,
        onPrimary: CCDesignSystem.textWhite,
        surface: CCDesignSystem.backgroundWhite,
        onSurface: CCDesignSystem.textPrimary,
        secondary: CCDesignSystem.textSecondary,
        onSecondary: CCDesignSystem.textWhite,
        error: CCDesignSystem.error,
        onError: CCDesignSystem.textWhite,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: CCDesignSystem.backgroundWhite,
        foregroundColor: CCDesignSystem.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: CCDesignSystem.heading3,
        toolbarHeight: 56,
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CCDesignSystem.backgroundWhite,
        selectedItemColor: CCDesignSystem.primaryBlue,
        unselectedItemColor: CCDesignSystem.textSecondary,
        selectedLabelStyle: CCDesignSystem.caption,
        unselectedLabelStyle: CCDesignSystem.caption,
        elevation: 0,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: CCDesignSystem.backgroundWhite,
        surfaceTintColor: CCDesignSystem.backgroundWhite,
        elevation: 0,
        margin: const EdgeInsets.all(CCDesignSystem.space8),
        shape: RoundedRectangleBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          side: const BorderSide(
            color: CCDesignSystem.divider,
            width: 1,
          ),
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CCDesignSystem.primaryBlue,
          foregroundColor: CCDesignSystem.textWhite,
          elevation: 0,
          textStyle: CCDesignSystem.buttonMedium,
          minimumSize: const Size(
            double.infinity, 
            CCDesignSystem.buttonHeightMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: CCDesignSystem.borderRadiusLarge,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CCDesignSystem.primaryBlue,
          textStyle: CCDesignSystem.buttonMedium,
          minimumSize: const Size(
            double.infinity,
            CCDesignSystem.buttonHeightMedium,
          ),
          side: const BorderSide(
            color: CCDesignSystem.primaryBlue,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: CCDesignSystem.borderRadiusLarge,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CCDesignSystem.primaryBlue,
          textStyle: CCDesignSystem.buttonMedium,
          shape: RoundedRectangleBorder(
            borderRadius: CCDesignSystem.borderRadiusLarge,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CCDesignSystem.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          borderSide: const BorderSide(
            color: CCDesignSystem.divider,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          borderSide: const BorderSide(
            color: CCDesignSystem.divider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          borderSide: const BorderSide(
            color: CCDesignSystem.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          borderSide: const BorderSide(
            color: CCDesignSystem.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
          borderSide: const BorderSide(
            color: CCDesignSystem.error,
            width: 2,
          ),
        ),
        contentPadding: CCDesignSystem.paddingMedium,
        hintStyle: CCDesignSystem.bodyMedium.copyWith(
          color: CCDesignSystem.textSecondary,
        ),
        labelStyle: CCDesignSystem.bodyMedium.copyWith(
          color: CCDesignSystem.textSecondary,
        ),
      ),
      
      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: CCDesignSystem.textPrimary,
        unselectedLabelColor: CCDesignSystem.textSecondary,
        indicatorColor: CCDesignSystem.textPrimary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: CCDesignSystem.bodyMedium,
        unselectedLabelStyle: CCDesignSystem.bodyMedium,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: CCDesignSystem.divider,
        thickness: 1,
        space: 1,
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: CCDesignSystem.backgroundWhite,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: CCDesignSystem.heading1,
        displayMedium: CCDesignSystem.heading2,
        displaySmall: CCDesignSystem.heading3,
        headlineLarge: CCDesignSystem.heading2,
        headlineMedium: CCDesignSystem.heading3,
        headlineSmall: CCDesignSystem.heading4,
        titleLarge: CCDesignSystem.heading3,
        titleMedium: CCDesignSystem.heading4,
        titleSmall: CCDesignSystem.bodyLarge,
        bodyLarge: CCDesignSystem.bodyLarge,
        bodyMedium: CCDesignSystem.bodyMedium,
        bodySmall: CCDesignSystem.bodySmall,
        labelLarge: CCDesignSystem.buttonLarge,
        labelMedium: CCDesignSystem.buttonMedium,
        labelSmall: CCDesignSystem.buttonSmall,
      ),
    );
  }
  
  /// Dark theme configuration (for communities screen)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CCDesignSystem.primaryBlue,
        brightness: Brightness.dark,
        primary: CCDesignSystem.primaryBlue,
        onPrimary: CCDesignSystem.textWhite,
        surface: CCDesignSystem.backgroundDark,
        onSurface: CCDesignSystem.textWhite,
        secondary: CCDesignSystem.textSecondary,
        onSecondary: CCDesignSystem.textWhite,
        error: CCDesignSystem.error,
        onError: CCDesignSystem.textWhite,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: CCDesignSystem.backgroundDark,
        foregroundColor: CCDesignSystem.textWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: CCDesignSystem.textWhite,
        ),
      ),
      
      scaffoldBackgroundColor: CCDesignSystem.backgroundDark,
      
      cardTheme: CardThemeData(
        color: CCDesignSystem.backgroundDark,
        surfaceTintColor: CCDesignSystem.backgroundDark,
        elevation: 0,
        margin: const EdgeInsets.all(CCDesignSystem.space8),
        shape: RoundedRectangleBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
        ),
      ),
    );
  }
  
  /// Cupertino theme for iOS
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: CCDesignSystem.primaryBlue,
      scaffoldBackgroundColor: CCDesignSystem.backgroundWhite,
      textTheme: CupertinoTextThemeData(
        primaryColor: CCDesignSystem.textPrimary,
        textStyle: CCDesignSystem.bodyMedium,
        actionTextStyle: CCDesignSystem.buttonMedium,
        navTitleTextStyle: CCDesignSystem.heading3,
      ),
    );
  }
}