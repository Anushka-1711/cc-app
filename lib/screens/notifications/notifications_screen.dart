import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../core/utils/platform_utils.dart';

/// Instagram-style notifications/activity screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotifications(),
          _buildFollowRequests(),
        ],
      ),
    );
  }

  Widget _buildAllNotifications() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNotificationItem(
          avatarColor: const Color(0xFF0095F6),
          initial: 'J',
          title: 'john_doe liked your post',
          time: '2m',
          hasPostImage: true,
        ),
        _buildNotificationItem(
          avatarColor: const Color(0xFFE1306C),
          initial: 'S',
          title: 'sarah_wilson started following you',
          time: '5m',
          hasFollowButton: true,
        ),
        _buildNotificationItem(
          avatarColor: const Color(0xFF4CAF50),
          initial: 'M',
          title: 'mike_chen commented: "Great content! 👏"',
          time: '10m',
          hasPostImage: true,
        ),
        _buildNotificationItem(
          avatarColor: const Color(0xFF9C27B0),
          initial: 'A',
          title: 'alex_smith liked your comment',
          time: '1h',
        ),
        _buildNotificationItem(
          avatarColor: const Color(0xFFFF9800),
          initial: 'L',
          title: 'lisa_park mentioned you in a comment',
          time: '3h',
          hasPostImage: true,
        ),
      ],
    );
  }

  Widget _buildFollowRequests() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Follow Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
        ),
        _buildFollowRequestItem(
          avatarColor: const Color(0xFFE91E63),
          initial: 'K',
          username: 'kate_johnson',
          mutualFriends: '3 mutual connections',
        ),
        _buildFollowRequestItem(
          avatarColor: const Color(0xFF673AB7),
          initial: 'D',
          username: 'david_brown',
          mutualFriends: '1 mutual connection',
        ),
      ],
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
}
