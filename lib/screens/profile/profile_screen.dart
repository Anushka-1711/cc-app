import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/utils/platform_utils.dart';

/// College Confessions profile screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
          '@alex_student',
          style: TextStyle(
            color: Color(0xFF262626),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMenu(context),
            icon: Icon(
              PlatformUtils.isIOS ? CupertinoIcons.line_horizontal_3 : Icons.more_vert,
              color: const Color(0xFF262626),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0095F6),
                          width: 2,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0095F6),
                        ),
                        child: const Center(
                          child: Text(
                            'AS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Stats
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('24', 'Confessions'),
                          _buildStatColumn('156', 'Followers'),
                          _buildStatColumn('89', 'Following'),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Name and Bio
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF262626),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Computer Science Student 💻\nLoves sharing thoughts anonymously\n🎓 University of California',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF262626),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEFEFF0),
                          foregroundColor: const Color(0xFF262626),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Edit profile',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEFEFF0),
                          foregroundColor: const Color(0xFF262626),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFDBDBDB)),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF262626),
              unselectedLabelColor: const Color(0xFF8E8E8E),
              indicatorColor: const Color(0xFF262626),
              indicatorWeight: 1,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PlatformUtils.isIOS ? CupertinoIcons.lock_shield : Icons.lock_outline, 
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const Text('Anonymous'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PlatformUtils.isIOS ? CupertinoIcons.globe : Icons.public, 
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const Text('Public'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnonymousPostsGrid(),
                _buildPublicPostsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF262626),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF262626),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymousPostsGrid() {
    final List<Map<String, dynamic>> anonymousConfessions = [
      {
        "text":
            "I'm scared of failing my final exams but I haven't started studying yet...",
        "time": "2h",
        "likes": 24,
        "comments": 8
      },
      {
        "text":
            "Sometimes I eat alone in the bathroom to avoid sitting alone in the cafeteria",
        "time": "4h",
        "likes": 156,
        "comments": 42
      },
      {
        "text": "I have a crush on my TA but I'm too shy to say anything",
        "time": "6h",
        "likes": 89,
        "comments": 23
      },
      {
        "text":
            "I lied about having friends when my parents asked about college social life",
        "time": "8h",
        "likes": 67,
        "comments": 15
      },
      {
        "text": "I cry in my dorm room every night because I miss home so much",
        "time": "12h",
        "likes": 234,
        "comments": 78
      },
      {
        "text":
            "I pretended to be sick to skip a group presentation I wasn't ready for",
        "time": "1d",
        "likes": 45,
        "comments": 12
      },
      {
        "text":
            "I've been using my meal plan money on coffee instead of actual meals",
        "time": "1d",
        "likes": 123,
        "comments": 34
      },
      {
        "text":
            "I'm jealous of everyone who seems to have their life figured out",
        "time": "2d",
        "likes": 189,
        "comments": 56
      },
      {
        "text": "I feel like an imposter in all my advanced classes",
        "time": "2d",
        "likes": 267,
        "comments": 89
      },
      {
        "text": "Sometimes I wonder if I chose the wrong major completely",
        "time": "3d",
        "likes": 145,
        "comments": 67
      },
      {
        "text": "I've never been to a college party and I feel left out",
        "time": "3d",
        "likes": 78,
        "comments": 19
      },
      {
        "text": "I'm afraid my roommate secretly hates me",
        "time": "4d",
        "likes": 56,
        "comments": 14
      },
      {
        "text": "I miss my high school friends more than I expected",
        "time": "4d",
        "likes": 198,
        "comments": 45
      },
      {
        "text":
            "I feel overwhelmed by the freedom and responsibility of college",
        "time": "5d",
        "likes": 289,
        "comments": 102
      },
      {
        "text":
            "I'm scared I'll never find my 'college best friends' like everyone else",
        "time": "5d",
        "likes": 167,
        "comments": 38
      },
      {
        "text":
            "I spend too much time on social media comparing myself to others",
        "time": "6d",
        "likes": 234,
        "comments": 67
      },
      {
        "text":
            "I'm struggling with being away from my family for the first time",
        "time": "6d",
        "likes": 145,
        "comments": 29
      },
      {
        "text": "I feel like everyone is more mature and experienced than me",
        "time": "1w",
        "likes": 178,
        "comments": 54
      },
      {
        "text":
            "I'm afraid to ask for help because I don't want to seem stupid",
        "time": "1w",
        "likes": 298,
        "comments": 87
      },
      {
        "text": "I question if I'm smart enough to be here every single day",
        "time": "1w",
        "likes": 345,
        "comments": 156
      },
      {
        "text": "I feel lost and don't know what I want to do with my life",
        "time": "1w",
        "likes": 267,
        "comments": 89
      },
      {
        "text": "I'm scared of graduating and entering the real world",
        "time": "2w",
        "likes": 189,
        "comments": 45
      },
      {
        "text": "I feel like I'm wasting my parents' money on tuition",
        "time": "2w",
        "likes": 123,
        "comments": 67
      },
      {
        "text": "I'm lonely even when I'm surrounded by people in class",
        "time": "2w",
        "likes": 234,
        "comments": 78
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: anonymousConfessions.length,
      itemBuilder: (context, index) {
        final confession = anonymousConfessions[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showConfessionDialog(confession['text'], true),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PlatformUtils.isIOS ? CupertinoIcons.lock_shield_fill : Icons.lock, 
                              color: Colors.white, 
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Anonymous',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        confession['time'],
                        style: const TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Confession text
                  Text(
                    confession['text'],
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Actions
                  Row(
                    children: [
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.heart : Icons.favorite_border,
                        '${confession['likes']}',
                        const Color(0xFF8E8E8E),
                      ),
                      const SizedBox(width: 20),
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.chat_bubble : Icons.chat_bubble_outline,
                        '${confession['comments']}',
                        const Color(0xFF8E8E8E),
                      ),
                      const SizedBox(width: 20),
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.share : Icons.share_outlined,
                        'Share',
                        const Color(0xFF8E8E8E),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPublicPostsGrid() {
    final List<Map<String, dynamic>> publicPosts = [
      {
        "text": "Just finished my first semester! Feeling accomplished 🎓",
        "time": "1h",
        "likes": 89,
        "comments": 12
      },
      {
        "text": "Coffee study session at the library ☕📚",
        "time": "3h",
        "likes": 45,
        "comments": 8
      },
      {
        "text": "Beautiful sunset from my dorm room window 🌅",
        "time": "5h",
        "likes": 123,
        "comments": 19
      },
      {
        "text": "Aced my Computer Science midterm! 💻",
        "time": "7h",
        "likes": 156,
        "comments": 25
      },
      {
        "text": "Pizza night with the roommates 🍕",
        "time": "10h",
        "likes": 67,
        "comments": 14
      },
      {
        "text": "Morning jog around campus 🏃‍♂️",
        "time": "1d",
        "likes": 34,
        "comments": 6
      },
      {
        "text": "New books for next semester 📖",
        "time": "1d",
        "likes": 78,
        "comments": 11
      },
      {
        "text": "Study group was actually fun today! 👥",
        "time": "2d",
        "likes": 92,
        "comments": 18
      },
      {
        "text": "Campus event was amazing! 🎉",
        "time": "2d",
        "likes": 145,
        "comments": 32
      },
      {
        "text": "Finally organized my desk space ✨",
        "time": "3d",
        "likes": 56,
        "comments": 9
      },
      {
        "text": "Weekend hiking trip with friends 🥾",
        "time": "3d",
        "likes": 134,
        "comments": 28
      },
      {
        "text": "Trying out the new campus restaurant 🍔",
        "time": "4d",
        "likes": 87,
        "comments": 15
      },
      {
        "text": "Late night coding session 💻",
        "time": "4d",
        "likes": 76,
        "comments": 13
      },
      {
        "text": "Joined a new club today! 🎯",
        "time": "5d",
        "likes": 98,
        "comments": 21
      },
      {
        "text": "Movie night in the common room 🍿",
        "time": "5d",
        "likes": 65,
        "comments": 10
      },
      {
        "text": "Spring break planning with friends ✈️",
        "time": "6d",
        "likes": 112,
        "comments": 24
      },
      {
        "text": "Got my first internship offer! 🎉",
        "time": "6d",
        "likes": 234,
        "comments": 45
      },
      {
        "text": "Campus workout session 💪",
        "time": "1w",
        "likes": 89,
        "comments": 16
      },
      {
        "text": "Art museum visit for class 🎨",
        "time": "1w",
        "likes": 67,
        "comments": 12
      },
      {
        "text": "Game night was competitive! 🎮",
        "time": "1w",
        "likes": 123,
        "comments": 29
      },
      {
        "text": "New semester, new goals 📝",
        "time": "2w",
        "likes": 156,
        "comments": 34
      },
      {
        "text": "Campus food truck Friday 🚚",
        "time": "2w",
        "likes": 78,
        "comments": 18
      },
      {
        "text": "Study abroad application submitted ✈️",
        "time": "2w",
        "likes": 145,
        "comments": 27
      },
      {
        "text": "Last day of finals week! 📚",
        "time": "3w",
        "likes": 198,
        "comments": 42
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: publicPosts.length,
      itemBuilder: (context, index) {
        final post = publicPosts[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showConfessionDialog(post['text'], false),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0095F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PlatformUtils.isIOS ? CupertinoIcons.globe : Icons.public, 
                              color: Colors.white, 
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Public',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        post['time'],
                        style: const TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Post text
                  Text(
                    post['text'],
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Actions
                  Row(
                    children: [
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.heart : Icons.favorite_border,
                        '${post['likes']}',
                        const Color(0xFF8E8E8E),
                      ),
                      const SizedBox(width: 20),
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.chat_bubble : Icons.chat_bubble_outline,
                        '${post['comments']}',
                        const Color(0xFF8E8E8E),
                      ),
                      const SizedBox(width: 20),
                      _buildActionButton(
                        PlatformUtils.isIOS ? CupertinoIcons.share : Icons.share_outlined,
                        'Share',
                        const Color(0xFF8E8E8E),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfessionDialog(String confession, bool isAnonymous) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      isAnonymous ? Icons.lock : Icons.public,
                      color: isAnonymous
                          ? const Color(0xFF262626)
                          : const Color(0xFF0095F6),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isAnonymous ? 'Anonymous Confession' : 'Public Post',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isAnonymous
                            ? const Color(0xFF262626)
                            : const Color(0xFF0095F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  confession,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF262626),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Add like functionality
                      },
                      icon: const Icon(Icons.favorite_border,
                          color: Color(0xFF8E8E8E)),
                      label: const Text('Like',
                          style: TextStyle(color: Color(0xFF8E8E8E))),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Add comment functionality
                      },
                      icon: const Icon(Icons.chat_bubble_outline,
                          color: Color(0xFF8E8E8E)),
                      label: const Text('Comment',
                          style: TextStyle(color: Color(0xFF8E8E8E))),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Add share functionality
                      },
                      icon: const Icon(Icons.share_outlined,
                          color: Color(0xFF8E8E8E)),
                      label: const Text('Share',
                          style: TextStyle(color: Color(0xFF8E8E8E))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xFF0095F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMenu(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF262626)),
                title: const Text('Settings'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading:
                    const Icon(Icons.privacy_tip, color: Color(0xFF262626)),
                title: const Text('Privacy'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Color(0xFF262626)),
                title: const Text('Help'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color) {
    return InkWell(
      onTap: () => HapticFeedback.lightImpact(),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
