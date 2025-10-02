import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../core/utils/platform_utils.dart';
import '../../services/services.dart';

/// Instagram-style notifications/activity screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _allNotifications = [];
  List<Map<String, dynamic>> _requestNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load all notifications
      final allNotifications = await ServiceProvider.notification.getNotifications(
        limit: 50,
      );
      
      // Filter request-type notifications
      final requestNotifications = allNotifications.where((notification) {
        final type = notification['type'] ?? '';
        return type == 'follow_request' || type == 'community_invite';
      }).toList();

      setState(() {
        _allNotifications = allNotifications;
        _requestNotifications = requestNotifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
            color: Color(0xFF262626),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF262626),
          unselectedLabelColor: const Color(0xFF8E8E8E),
          indicatorColor: const Color(0xFF262626),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Requests'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0095F6),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAllNotifications(),
                _buildFollowRequests(),
              ],
            ),
    );
  }

  Widget _buildAllNotifications() {
    if (_allNotifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Color(0xFF8E8E8E),
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: const Color(0xFF0095F6),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allNotifications.length,
        itemBuilder: (context, index) {
          final notification = _allNotifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildFollowRequests() {
    if (_requestNotifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_disabled,
              size: 64,
              color: Color(0xFF8E8E8E),
            ),
            SizedBox(height: 16),
            Text(
              'No requests',
              style: TextStyle(
                color: Color(0xFF8E8E8E),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: const Color(0xFF0095F6),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requestNotifications.length,
        itemBuilder: (context, index) {
          final notification = _requestNotifications[index];
          return _buildRequestCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final title = notification['title'] ?? 'Notification';
    final message = notification['message'] ?? '';
    final type = notification['type'] ?? '';
    final isRead = notification['is_read'] ?? false;
    final createdAt = notification['created_at'];
    final timeAgo = _formatTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onNotificationTap(notification),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Notification icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNotificationColor(type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                        color: const Color(0xFF262626),
                      ),
                    ),
                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E8E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0095F6),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> notification) {
    final title = notification['title'] ?? 'Request';
    final message = notification['message'] ?? '';
    final createdAt = notification['created_at'];
    final timeAgo = _formatTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE1E5E9),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // User avatar placeholder
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF0095F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // Request content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF262626),
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                ],
              ),
            ),
            
            // Action buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _acceptRequest(notification),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0095F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _declineRequest(notification),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8E8E8E),
                    side: const BorderSide(color: Color(0xFFE1E5E9)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required Color avatarColor,
    required String initial,
    required String title,
    required String time,
    bool hasPostImage = false,
    bool hasFollowButton = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF262626),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),

          // Action area
          if (hasPostImage)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFE1E1E1),
                  width: 1,
                ),
              ),
              child: Icon(
                PlatformUtils.isIOS ? CupertinoIcons.photo : Icons.image,
                color: const Color(0xFF8E8E8E),
                size: 20,
              ),
            ),

          if (hasFollowButton)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0095F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Follow'),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestItem({
    required Color avatarColor,
    required String initial,
    required String username,
    required String mutualFriends,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mutualFriends,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0095F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF262626),
                  side: const BorderSide(color: Color(0xFFE1E1E1)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(String? createdAt) {
    if (createdAt == null) return 'Unknown time';
    
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return '${(difference.inDays / 7).floor()}w';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return const Color(0xFF0095F6);
      case 'follow':
      case 'follow_request':
        return const Color(0xFF8E44AD);
      case 'mention':
        return const Color(0xFFFF9800);
      case 'community_invite':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF8E8E8E);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.chat_bubble;
      case 'follow':
      case 'follow_request':
        return Icons.person_add;
      case 'mention':
        return Icons.alternate_email;
      case 'community_invite':
        return Icons.group_add;
      default:
        return Icons.notifications;
    }
  }

  Future<void> _onNotificationTap(Map<String, dynamic> notification) async {
    try {
      HapticFeedback.lightImpact();
      
      // Mark as read if not already
      if (!(notification['is_read'] ?? false)) {
        await ServiceProvider.notification.markAsRead(notification['id']);
        // Refresh the list to update read status
        _loadNotifications();
      }
      
      // TODO: Navigate to relevant screen based on notification type
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opened: ${notification['title']}'),
          backgroundColor: const Color(0xFF262626),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening notification: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _acceptRequest(Map<String, dynamic> notification) async {
    try {
      HapticFeedback.lightImpact();
      
      // TODO: Implement accept request logic based on notification type
      await ServiceProvider.notification.markAsRead(notification['id']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request accepted'),
          backgroundColor: const Color(0xFF0095F6),
          duration: const Duration(seconds: 2),
        ),
      );
      
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept request: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _declineRequest(Map<String, dynamic> notification) async {
    try {
      HapticFeedback.lightImpact();
      
      // TODO: Implement decline request logic
      await ServiceProvider.notification.deleteNotification(notification['id']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request declined'),
          backgroundColor: const Color(0xFF8E8E8E),
          duration: const Duration(seconds: 2),
        ),
      );
      
      _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decline request: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
