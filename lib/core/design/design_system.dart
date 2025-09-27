import 'package:flutter/material.dart';

/// College Confessions App Design System
/// 
/// This file contains all design tokens, colors, typography, spacing, and theme
/// definitions used throughout the College Confessions app. It ensures visual
/// consistency and makes it easy for contributors to maintain the design language.

class CCDesignSystem {
  CCDesignSystem._();

  // ==========================================================================
  // COLORS
  // ==========================================================================
  
  /// Primary brand color - Instagram blue
  static const Color primaryBlue = Color(0xFF0095F6);
  
  /// Background colors
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundDark = Color(0xFF1A1A1B);
  static const Color backgroundGray = Color(0xFFFAFAFA);
  static const Color backgroundCard = Color(0xFFF8F8F8);
  
  /// Text colors
  static const Color textPrimary = Color(0xFF262626);
  static const Color textSecondary = Color(0xFF8E8E8E);
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF1A1A1B);
  
  /// State colors
  static const Color success = Color(0xFF00C851);
  static const Color error = Color(0xFFFF4444);
  static const Color warning = Color(0xFFFF8800);
  static const Color info = primaryBlue;
  
  /// Privacy/Community colors
  static const Color anonymous = textPrimary; // Dark for anonymous posts
  static const Color publicPost = primaryBlue; // Blue for public posts
  
  /// Interactive colors
  static const Color divider = Color(0xFFE1E1E1);
  static const Color shadow = Color(0x1A000000);
  
  // ==========================================================================
  // TYPOGRAPHY
  // ==========================================================================
  
  /// Heading styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  /// Body text styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  /// Button text styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  /// Caption and label styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.3,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.2,
  );
  
  // ==========================================================================
  // SPACING
  // ==========================================================================
  
  /// Base spacing unit (8px)
  static const double spaceUnit = 8.0;
  
  /// Spacing scale based on 8px grid
  static const double space4 = spaceUnit * 0.5;   // 4px
  static const double space8 = spaceUnit;         // 8px
  static const double space12 = spaceUnit * 1.5;  // 12px
  static const double space16 = spaceUnit * 2;    // 16px
  static const double space20 = spaceUnit * 2.5;  // 20px
  static const double space24 = spaceUnit * 3;    // 24px
  static const double space32 = spaceUnit * 4;    // 32px
  static const double space40 = spaceUnit * 5;    // 40px
  static const double space48 = spaceUnit * 6;    // 48px
  static const double space56 = spaceUnit * 7;    // 56px
  static const double space64 = spaceUnit * 8;    // 64px
  
  /// Padding constants
  static const EdgeInsets paddingSmall = EdgeInsets.all(space8);
  static const EdgeInsets paddingMedium = EdgeInsets.all(space16);
  static const EdgeInsets paddingLarge = EdgeInsets.all(space24);
  
  static const EdgeInsets paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: space8);
  static const EdgeInsets paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: space16);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: space24);
  
  static const EdgeInsets paddingVerticalSmall = EdgeInsets.symmetric(vertical: space8);
  static const EdgeInsets paddingVerticalMedium = EdgeInsets.symmetric(vertical: space16);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: space24);
  
  // ==========================================================================
  // BORDER RADIUS
  // ==========================================================================
  
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusCircle = 999.0;
  
  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius borderRadiusMedium = BorderRadius.all(Radius.circular(radiusMedium));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusXLarge = BorderRadius.all(Radius.circular(radiusXLarge));
  
  // ==========================================================================
  // SHADOWS
  // ==========================================================================
  
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: shadow,
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: shadow,
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
  
  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: shadow,
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];
  
  // ==========================================================================
  // DURATIONS
  // ==========================================================================
  
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // ==========================================================================
  // BREAKPOINTS
  // ==========================================================================
  
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // ==========================================================================
  // COMPONENT SIZES
  // ==========================================================================
  
  /// Button heights
  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 44;
  static const double buttonHeightLarge = 56;
  
  /// Input field heights
  static const double inputHeightSmall = 36;
  static const double inputHeightMedium = 48;
  static const double inputHeightLarge = 56;
  
  /// Icon sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;
  static const double iconSizeXLarge = 48;
  
  /// Avatar sizes
  static const double avatarSizeSmall = 32;
  static const double avatarSizeMedium = 48;
  static const double avatarSizeLarge = 64;
  static const double avatarSizeXLarge = 86;
}