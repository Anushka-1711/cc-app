import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';

/// Service for managing notifications and real-time updates
class NotificationService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Stream controllers for real-time notifications
  final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  RealtimeChannel? _notificationChannel;
  bool _isListening = false;
  
  /// Get stream of real-time notifications
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  
  /// Initialize real-time notification listener
  Future<void> startListening() async {
    if (_isListening) return;
    
    final userId = SupabaseConfig.userId;
    if (userId == null) return;
    
    try {
      _notificationChannel = _supabase
          .channel('notifications:$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) {
              final notification = payload.newRecord;
              _notificationController.add(notification);
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) {
              final notification = payload.newRecord;
              _notificationController.add(notification);
            },
          )
          .subscribe();
      
      _isListening = true;
    } catch (e) {
      print('Failed to start notification listener: $e');
    }
  }
  
  /// Stop listening to real-time notifications
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      await _notificationChannel?.unsubscribe();
      _notificationChannel = null;
      _isListening = false;
    } catch (e) {
      print('Failed to stop notification listener: $e');
    }
  }
  
  /// Get user's notifications with pagination
  Future<List<Map<String, dynamic>>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      var query = _supabase
          .from('notifications')
          .select('''
            id, type, title, message, data,
            is_read, created_at, expires_at,
            related_user_id, related_confession_id,
            related_comment_id, related_community_id
          ''')
          .eq('user_id', userId);
      
      if (unreadOnly) {
        query = query.eq('is_read', false);
      }
      
      final result = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load notifications: ${e.toString()}');
    }
  }
  
  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) return 0;
      
      final result = await _supabase
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .eq('is_read', false);
      
      return result.length;
    } catch (e) {
      return 0;
    }
  }
  
  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }
  
  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase
          .from('notifications')
          .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: ${e.toString()}');
    }
  }
  
  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }
  
  /// Delete all read notifications
  Future<void> deleteReadNotifications() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase
          .from('notifications')
          .delete()
          .eq('user_id', userId)
          .eq('is_read', true);
    } catch (e) {
      throw Exception('Failed to delete read notifications: ${e.toString()}');
    }
  }
  
  /// Create a notification (typically called by backend triggers)
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String? relatedUserId,
    String? relatedConfessionId,
    String? relatedCommentId,
    String? relatedCommunityId,
    DateTime? expiresAt,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'type': type,
        'title': title,
        'message': message,
        'data': data,
        'related_user_id': relatedUserId,
        'related_confession_id': relatedConfessionId,
        'related_comment_id': relatedCommentId,
        'related_community_id': relatedCommunityId,
        'expires_at': expiresAt?.toIso8601String(),
        'is_read': false,
      });
    } catch (e) {
      throw Exception('Failed to create notification: ${e.toString()}');
    }
  }
  
  /// Get notification settings for user
  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      final result = await _supabase
          .from('users')
          .select('notification_settings')
          .eq('id', userId)
          .single();
      
      return result['notification_settings'] ?? _getDefaultNotificationSettings();
    } catch (e) {
      return _getDefaultNotificationSettings();
    }
  }
  
  /// Update notification settings
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase
          .from('users')
          .update({'notification_settings': settings})
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update notification settings: ${e.toString()}');
    }
  }
  
  /// Check if user should receive notification based on settings
  Future<bool> shouldNotify(String userId, String notificationType) async {
    try {
      final settings = await getNotificationSettings();
      return settings[notificationType] ?? true;
    } catch (e) {
      return true; // Default to sending notification if we can't check settings
    }
  }
  
  /// Send push notification (placeholder for future implementation)
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // This would integrate with Firebase Cloud Messaging or another push service
    // For now, it's just a placeholder that creates an in-app notification
    await createNotification(
      userId: userId,
      type: 'push',
      title: title,
      message: body,
      data: data,
    );
  }
  
  /// Group notifications by type for better UX
  Map<String, List<Map<String, dynamic>>> groupNotificationsByType(
    List<Map<String, dynamic>> notifications,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    
    for (final notification in notifications) {
      final type = notification['type'] as String? ?? 'other';
      grouped[type] = (grouped[type] ?? [])..add(notification);
    }
    
    return grouped;
  }
  
  /// Format notification for display
  Map<String, dynamic> formatNotification(Map<String, dynamic> notification) {
    final type = notification['type'] as String;
    final createdAt = DateTime.parse(notification['created_at']);
    final timeAgo = _formatTimeAgo(createdAt);
    
    return {
      ...notification,
      'formatted_time': timeAgo,
      'icon': _getNotificationIcon(type),
      'color': _getNotificationColor(type),
      'action_label': _getActionLabel(type),
    };
  }
  
  /// Get default notification settings
  Map<String, dynamic> _getDefaultNotificationSettings() {
    return {
      'new_confession_vote': true,
      'new_comment': true,
      'comment_vote': true,
      'confession_reply': true,
      'community_join': false,
      'community_post': true,
      'trust_score_change': true,
      'system_announcements': true,
      'weekly_digest': true,
      'push_enabled': true,
      'email_enabled': false,
      'quiet_hours_enabled': true,
      'quiet_hours_start': '22:00',
      'quiet_hours_end': '08:00',
    };
  }
  
  /// Get icon for notification type
  String _getNotificationIcon(String type) {
    switch (type) {
      case 'new_confession_vote':
      case 'comment_vote':
        return 'thumb_up';
      case 'new_comment':
      case 'confession_reply':
        return 'comment';
      case 'community_join':
        return 'group_add';
      case 'community_post':
        return 'post_add';
      case 'trust_score_change':
        return 'star';
      case 'system_announcements':
        return 'announcement';
      default:
        return 'notifications';
    }
  }
  
  /// Get color for notification type
  String _getNotificationColor(String type) {
    switch (type) {
      case 'new_confession_vote':
      case 'comment_vote':
        return 'green';
      case 'new_comment':
      case 'confession_reply':
        return 'blue';
      case 'community_join':
      case 'community_post':
        return 'purple';
      case 'trust_score_change':
        return 'orange';
      case 'system_announcements':
        return 'red';
      default:
        return 'grey';
    }
  }
  
  /// Get action label for notification type
  String _getActionLabel(String type) {
    switch (type) {
      case 'new_confession_vote':
      case 'comment_vote':
        return 'View';
      case 'new_comment':
      case 'confession_reply':
        return 'Reply';
      case 'community_join':
      case 'community_post':
        return 'Open';
      case 'trust_score_change':
        return 'Check';
      case 'system_announcements':
        return 'Read';
      default:
        return 'View';
    }
  }
  
  /// Format time ago string
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
  
  /// Dispose resources
  void dispose() {
    stopListening();
    _notificationController.close();
  }
}