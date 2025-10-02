import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/services.dart';

/// Home feed screen - exact replica of cc-web GitHub repository
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final posts = await ServiceProvider.confession.getHomeFeedConfessions();
      
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load posts: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _toggleLike(String postId) async {
    try {
      // Optimistically update UI
      setState(() {
        final postIndex = _posts.indexWhere((post) => post['id'] == postId);
        if (postIndex != -1) {
          final currentVote = _posts[postIndex]['user_vote'] ?? 0;
          final newVote = currentVote == 1 ? 0 : 1; // Toggle between 0 and 1
          
          _posts[postIndex]['user_vote'] = newVote;
          _posts[postIndex]['upvotes'] = (_posts[postIndex]['upvotes'] ?? 0) + (newVote - currentVote);
        }
      });

      // Make actual API call
      final currentVote = await ServiceProvider.confession.getUserVote(postId);
      if (currentVote == 1) {
        await ServiceProvider.confession.removeVoteFromConfession(postId);
      } else {
        await ServiceProvider.confession.voteOnConfession(postId, 1);
      }
      
      HapticFeedback.lightImpact();
    } catch (e) {
      // Revert optimistic update on error
      await _loadPosts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to vote: ${e.toString()}')),
        );
      }
    }
  }

  void _onCommentTap(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to post detail screen
    final content = post['content'] ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Comments for: ${content.length > 30 ? "${content.substring(0, 30)}..." : content}'),
        backgroundColor: const Color(0xFF262626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShareTap(Map<String, dynamic> post) {
    HapticFeedback.lightImpact();
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        backgroundColor: Color(0xFF262626),
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

  Widget _buildPostCard(Map<String, dynamic> post) {
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

  Widget _buildPostHeader(Map<String, dynamic> post) {
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
                  '${post['community'] ?? 'General'} • ${_formatTimeAgo(post['created_at'])}',
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

  Widget _buildPostContent(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildHashtagText(post['content'] ?? ''),
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

  Widget _buildPostChips(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Community chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0095F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF0095F6).withValues(alpha: 0.3)),
            ),
            child: Text(
              post['community'] ?? 'General',
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
              color: const Color(0xFF8E44AD).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF8E44AD).withValues(alpha: 0.3)),
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
                  post['university_name'] ?? 'Unknown University',
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
              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.3)),
            ),
            child: Text(
              post['confession_type'] ?? 'General',
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

  Widget _buildPostActions(Map<String, dynamic> post) {
    final isLiked = (post['user_vote'] ?? 0) == 1;
    final likesCount = post['upvotes'] ?? 0;
    final commentsCount = post['comment_count'] ?? 0;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Like button
          InkWell(
            onTap: () => _toggleLike(post['id']),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : const Color(0xFF8E8E8E),
                    size: 20,
                  ),
                  if (likesCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      likesCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isLiked ? Colors.red : const Color(0xFF8E8E8E),
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
                  if (commentsCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      commentsCount.toString(),
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

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _loadPosts();
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
