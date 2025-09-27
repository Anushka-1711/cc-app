import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformUtils {
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isWeb => kIsWeb;
  static bool get isMobile => isIOS || isAndroid;
  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  static TargetPlatform get targetPlatform => defaultTargetPlatform;

  static double get cardElevation => isIOS ? 0.5 : 2.0;
  static BorderRadius get defaultBorderRadius =>
      BorderRadius.circular(isIOS ? 10 : 8);
}
