import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Home feed screen - exact replica of cc-web GitHub repository
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ConfessionPost> _posts = _generateMockPosts();
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static List<ConfessionPost> _generateMockPosts() {
    return [
      ConfessionPost(
        id: '1',
        content:
            'I have a huge crush on someone in my CS class but I\'m too shy to talk to them. Every time they walk by, my heart starts racing #crush #college #anonymous',
        timeAgo: '2h',
        likes: 23,
        comments: 8,
        community: 'Computer Science',
        universityName: 'MIT',
        isLiked: false,
        confessionType: 'Relationship',
      ),
      ConfessionPost(
        id: '2',
        content:
            'I pretend to understand everything in lectures but honestly I\'m lost 80% of the time. Anyone else feeling like they\'re drowning in coursework? #academics #struggle #help',
        timeAgo: '4h',
        likes: 156,
        comments: 42,
        community: 'General',
        universityName: 'Stanford University',
        isLiked: true,
        confessionType: 'Academic',
      ),
      ConfessionPost(
        id: '3',
        content:
            'My roommate leaves their dirty dishes everywhere and never cleans up. I\'ve started doing their dishes just to avoid confrontation. Am I being a doormat? #roommate #dormlife',
        timeAgo: '6h',
        likes: 89,
        comments: 28,
        community: 'Dorm Life',
        universityName: 'Harvard University',
        isLiked: false,
        confessionType: 'Living',
      ),
      ConfessionPost(
        id: '4',
        content:
            'I spent my entire weekend binge-watching shows instead of studying for my midterm that\'s tomorrow. Why do I do this to myself every single time? #procrastination #midterm #regret #studentlife',
        timeAgo: '8h',
        likes: 234,
        comments: 67,
        community: 'Study Tips',
        universityName: 'UC Berkeley',
        isLiked: true,
        confessionType: 'Academic',
      ),
      ConfessionPost(
        id: '5',
        content:
            'Sometimes I eat alone in my car instead of the cafeteria because I feel awkward sitting by myself in public. College social life is harder than I expected. #anxiety #social #lonely #mentalhealth',
        timeAgo: '1d',
        likes: 312,
        comments: 91,
        community: 'Mental Health',
        universityName: 'UCLA',
        isLiked: false,
        confessionType: 'Personal',
      ),
    ];
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].isLiked = !_posts[postIndex].isLiked;
        _posts[postIndex].likes += _posts[postIndex].isLiked ? 1 : -1;
      }
    });
    HapticFeedback.lightImpact();
  }

  void _onCommentTap(ConfessionPost post) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to post detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Comments for: ${post.content.length > 30 ? post.content.substring(0, 30) + "..." : post.content}'),
        backgroundColor: const Color(0xFF262626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShareTap(ConfessionPost post) {
    HapticFeedback.lightImpact();
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: const Color(0xFF262626),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF0095F6),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stories section
            _buildStoriesSection(),

            // Posts list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _posts.length) return null;
                  return _buildPostCard(_posts[index]);
                },
                childCount: _posts.length,
              ),
            ),

            // Loading indicator
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0095F6),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0095F6),
                  Color(0xFF8E44AD),
                  Color(0xFFE91E63),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'C',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Confess',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF262626),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // TODO: Show search
          },
          icon: const Icon(
            Icons.search,
            color: Color(0xFF262626),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xFF0095F6)
                          : const Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      index == 0 ? Icons.add : Icons.person,
                      color:
                          index == 0 ? Colors.white : const Color(0xFF8E8E8E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    index == 0 ? 'Your Story' : 'Story ${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8E8E8E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(ConfessionPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF0F0F0)),
          bottom: BorderSide(color: Color(0xFFF0F0F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          _buildPostHeader(post),

          // Post content with hashtags
          _buildPostContent(post),

          // Community and university chips
          _buildPostChips(post),

          // Post actions
          _buildPostActions(post),
        ],
      ),
    );
  }

  Widget _buildPostHeader(ConfessionPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Anonymous avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF8E8E8E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Post info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anonymous',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                Text(
                  '${post.community} • ${post.timeAgo}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Show post options
            },
            icon: const Icon(
              Icons.more_horiz,
              color: Color(0xFF8E8E8E),
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(ConfessionPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildHashtagText(post.content),
    );
  }

  Widget _buildHashtagText(String text) {
    final RegExp hashtagRegex = RegExp(r'#[a-zA-Z0-9_]+');
    final List<InlineSpan> spans = [];

    int lastEnd = 0;
    for (final match in hashtagRegex.allMatches(text)) {
      // Add regular text before hashtag
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF262626),
            height: 1.4,
          ),
        ));
      }

      // Add hashtag with Instagram-like styling
      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0095F6), // Instagram blue
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
        // TODO: Add tap gesture to search hashtag
      ));

      lastEnd = match.end;
    }

    // Add remaining text after last hashtag
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF262626),
          height: 1.4,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildPostChips(ConfessionPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Community chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF0095F6).withOpacity(0.3)),
            ),
            child: Text(
              post.community,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0095F6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // University chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8E44AD).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF8E44AD).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.school,
                  size: 12,
                  color: Color(0xFF8E44AD),
                ),
                const SizedBox(width: 4),
                Text(
                  post.universityName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E44AD),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Confession type chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
            ),
            child: Text(
              post.confessionType,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFE91E63),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostActions(ConfessionPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Like button
          InkWell(
            onTap: () => _toggleLike(post.id),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : const Color(0xFF8E8E8E),
                    size: 20,
                  ),
                  if (post.likes > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      post.likes.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            post.isLiked ? Colors.red : const Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Comment button
          InkWell(
            onTap: () => _onCommentTap(post),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF8E8E8E),
                    size: 20,
                  ),
                  if (post.comments > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      post.comments.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E8E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Spacer(),

          // Share button
          InkWell(
            onTap: () => _onShareTap(post),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(
                Icons.share_outlined,
                color: Color(0xFF8E8E8E),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: Refresh posts from API
  }
}

/// Confession post model matching GitHub repository structure
class ConfessionPost {
  final String id;
  final String content;
  final String timeAgo;
  int likes;
  final int comments;
  final String community;
  final String universityName;
  bool isLiked;
  final String confessionType;

  ConfessionPost({
    required this.id,
    required this.content,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    required this.community,
    required this.universityName,
    required this.isLiked,
    required this.confessionType,
  });
}
