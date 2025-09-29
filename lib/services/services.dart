import 'auth_service.dart';
import 'confession_service.dart';
import 'community_service.dart';
import 'notification_service.dart';

// Service exports for easy importing
export 'auth_service.dart';
export 'confession_service.dart';
export 'community_service.dart';
export 'notification_service.dart';

/// Service provider for dependency injection
class ServiceProvider {
  static AuthService? _authService;
  static ConfessionService? _confessionService;
  static CommunityService? _communityService;
  static NotificationService? _notificationService;
  
  /// Get singleton instance of AuthService
  static AuthService get auth {
    _authService ??= AuthService();
    return _authService!;
  }
  
  /// Get singleton instance of ConfessionService
  static ConfessionService get confession {
    _confessionService ??= ConfessionService();
    return _confessionService!;
  }
  
  /// Get singleton instance of CommunityService
  static CommunityService get community {
    _communityService ??= CommunityService();
    return _communityService!;
  }
  
  /// Get singleton instance of NotificationService
  static NotificationService get notification {
    _notificationService ??= NotificationService();
    return _notificationService!;
  }
  
  /// Initialize all services
  static Future<void> initialize() async {
    // Services are initialized lazily, so just ensure notification listener starts
    await notification.startListening();
  }
  
  /// Dispose all services (call when app is closing)
  static void dispose() {
    _notificationService?.dispose();
    _authService = null;
    _confessionService = null;
    _communityService = null;
    _notificationService = null;
  }
}