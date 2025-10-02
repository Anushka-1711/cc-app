import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/services.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  List<Map<String, dynamic>> _communities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final communities = await ServiceProvider.community.getCommunities(
        publicOnly: true,
        limit: 50,
      );
      
      setState(() {
        _communities = communities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load communities: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1B),
        elevation: 0,
        title: const Text(
          'Communities',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // TODO: Search communities
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0095F6),
              ),
            )
          : _communities.isEmpty
              ? const Center(
                  child: Text(
                    'No communities found',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadCommunities,
                  color: const Color(0xFF0095F6),
                  backgroundColor: const Color(0xFF1A1A1B),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _communities.length,
                    itemBuilder: (context, index) {
                      return _buildCommunityCard(_communities[index]);
                    },
                  ),
                ),
    );
  }

  Widget _buildCommunityCard(Map<String, dynamic> community) {
    final memberCount = community['member_count'] ?? 0;
    final postCount = community['post_count'] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF404040),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onCommunityTap(community),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Community icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF0095F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: community['icon_url'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          community['icon_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultIcon(community['name']);
                          },
                        ),
                      )
                    : _buildDefaultIcon(community['name']),
              ),
              const SizedBox(width: 12),
              
              // Community info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      community['name'] ?? 'Unknown Community',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      community['description'] ?? 'No description available',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$memberCount members',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.article,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$postCount posts',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Join button
              ElevatedButton(
                onPressed: () => _onJoinCommunity(community),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0095F6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'C',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onCommunityTap(Map<String, dynamic> community) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to community detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${community['name']} community'),
        backgroundColor: const Color(0xFF262626),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onJoinCommunity(Map<String, dynamic> community) async {
    try {
      HapticFeedback.lightImpact();
      
      // TODO: Implement join community functionality
      // await ServiceProvider.community.joinCommunity(community['id']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joined ${community['name']} community!'),
          backgroundColor: const Color(0xFF0095F6),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Refresh the list to update member count
      _loadCommunities();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join community: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
