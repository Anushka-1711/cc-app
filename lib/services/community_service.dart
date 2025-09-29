import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';

/// Service for managing communities and user memberships
class CommunityService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Cache for frequently accessed community data
  final Map<String, Map<String, dynamic>> _communityCache = {};
  final Map<String, bool> _membershipCache = {};
  
  /// Get all communities with optional filtering
  Future<List<Map<String, dynamic>>> getCommunities({
    String? institutionId,
    String? type,
    bool publicOnly = false,
    int limit = 50,
  }) async {
    try {
      var query = _supabase
          .from('communities')
          .select('''
            id, name, description, type, privacy_level,
            member_count, post_count, created_at,
            institution_id, cover_image_url, icon_url,
            institutions(id, name, type)
          ''')
          .eq('status', 'active');
      
      if (institutionId != null) {
        query = query.eq('institution_id', institutionId);
      }
      
      if (type != null) {
        query = query.eq('type', type);
      }
      
      if (publicOnly) {
        query = query.eq('privacy_level', 'public');
      }
      
      final result = await query
          .order('member_count', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load communities: ${e.toString()}');
    }
  }
  
  /// Get a single community with detailed information
  Future<Map<String, dynamic>?> getCommunity(String communityId) async {
    try {
      // Check cache first
      if (_communityCache.containsKey(communityId)) {
        return _communityCache[communityId];
      }
      
      final result = await _supabase
          .from('communities')
          .select('''
            id, name, description, type, privacy_level,
            member_count, post_count, created_at, updated_at,
            institution_id, cover_image_url, icon_url,
            rules, moderator_ids, settings,
            institutions(id, name, type, domain)
          ''')
          .eq('id', communityId)
          .eq('status', 'active')
          .maybeSingle();
      
      if (result != null) {
        _communityCache[communityId] = result;
      }
      
      return result;
    } catch (e) {
      throw Exception('Failed to load community: ${e.toString()}');
    }
  }
  
  /// Get user's joined communities
  Future<List<Map<String, dynamic>>> getUserCommunities() async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      final result = await _supabase
          .from('user_communities')
          .select('''
            role, joined_at, is_favorite,
            communities!inner(
              id, name, description, type, privacy_level,
              member_count, post_count, icon_url,
              institutions(name)
            )
          ''')
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('joined_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load user communities: ${e.toString()}');
    }
  }
  
  /// Join a community
  Future<void> joinCommunity(String communityId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Check if community exists and user can join
      final community = await getCommunity(communityId);
      if (community == null) {
        throw Exception('Community not found');
      }
      
      // Check if user is already a member
      final existingMembership = await _supabase
          .from('user_communities')
          .select('id, status')
          .eq('user_id', userId)
          .eq('community_id', communityId)
          .maybeSingle();
      
      if (existingMembership != null) {
        if (existingMembership['status'] == 'active') {
          throw Exception('Already a member of this community');
        } else {
          // Reactivate membership
          await _supabase
              .from('user_communities')
              .update({'status': 'active', 'joined_at': DateTime.now().toIso8601String()})
              .eq('id', existingMembership['id']);
        }
      } else {
        // Create new membership
        await _supabase.from('user_communities').insert({
          'user_id': userId,
          'community_id': communityId,
          'role': 'member',
          'status': 'active',
          'joined_at': DateTime.now().toIso8601String(),
        });
      }
      
      // Clear caches
      _clearUserCaches(userId, communityId);
    } catch (e) {
      throw Exception('Failed to join community: ${e.toString()}');
    }
  }
  
  /// Leave a community
  Future<void> leaveCommunity(String communityId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase
          .from('user_communities')
          .update({'status': 'left', 'left_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('community_id', communityId);
      
      // Clear caches
      _clearUserCaches(userId, communityId);
    } catch (e) {
      throw Exception('Failed to leave community: ${e.toString()}');
    }
  }
  
  /// Check if user is a member of a community
  Future<bool> isMember(String communityId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) return false;
      
      final cacheKey = '${userId}_$communityId';
      if (_membershipCache.containsKey(cacheKey)) {
        return _membershipCache[cacheKey]!;
      }
      
      final result = await _supabase
          .from('user_communities')
          .select('id')
          .eq('user_id', userId)
          .eq('community_id', communityId)
          .eq('status', 'active')
          .maybeSingle();
      
      final isMember = result != null;
      _membershipCache[cacheKey] = isMember;
      
      return isMember;
    } catch (e) {
      return false;
    }
  }
  
  /// Get user's role in a community
  Future<String?> getUserRole(String communityId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) return null;
      
      final result = await _supabase
          .from('user_communities')
          .select('role')
          .eq('user_id', userId)
          .eq('community_id', communityId)
          .eq('status', 'active')
          .maybeSingle();
      
      return result?['role'];
    } catch (e) {
      return null;
    }
  }
  
  /// Set community as favorite/unfavorite
  Future<void> toggleFavoriteCommunity(String communityId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Get current favorite status
      final membership = await _supabase
          .from('user_communities')
          .select('is_favorite')
          .eq('user_id', userId)
          .eq('community_id', communityId)
          .eq('status', 'active')
          .single();
      
      final currentFavorite = membership['is_favorite'] ?? false;
      
      await _supabase
          .from('user_communities')
          .update({'is_favorite': !currentFavorite})
          .eq('user_id', userId)
          .eq('community_id', communityId);
      
    } catch (e) {
      throw Exception('Failed to update favorite status: ${e.toString()}');
    }
  }
  
  /// Search communities
  Future<List<Map<String, dynamic>>> searchCommunities({
    required String query,
    String? institutionId,
    String? type,
    int limit = 20,
  }) async {
    try {
      var searchQuery = _supabase
          .from('communities')
          .select('''
            id, name, description, type, privacy_level,
            member_count, post_count, icon_url,
            institutions(name)
          ''')
          .eq('status', 'active')
          .or('name.ilike.%$query%,description.ilike.%$query%');
      
      if (institutionId != null) {
        searchQuery = searchQuery.eq('institution_id', institutionId);
      }
      
      if (type != null) {
        searchQuery = searchQuery.eq('type', type);
      }
      
      final result = await searchQuery
          .order('member_count', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Community search failed: ${e.toString()}');
    }
  }
  
  /// Get trending communities
  Future<List<Map<String, dynamic>>> getTrendingCommunities({
    String? institutionId,
    int limit = 10,
    Duration timeFrame = const Duration(days: 7),
  }) async {
    try {
      var query = _supabase
          .from('communities')
          .select('''
            id, name, description, type, privacy_level,
            member_count, post_count, icon_url,
            institutions(name)
          ''')
          .eq('status', 'active');
      
      if (institutionId != null) {
        query = query.eq('institution_id', institutionId);
      }
      
      final result = await query
          .order('member_count', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load trending communities: ${e.toString()}');
    }
  }
  
  /// Get community members
  Future<List<Map<String, dynamic>>> getCommunityMembers(
    String communityId, {
    String? role,
    int limit = 50,
  }) async {
    try {
      var query = _supabase
          .from('user_communities')
          .select('''
            role, joined_at, is_favorite,
            users!inner(id, display_name, avatar_url, trust_score)
          ''')
          .eq('community_id', communityId)
          .eq('status', 'active');
      
      if (role != null) {
        query = query.eq('role', role);
      }
      
      final result = await query
          .order('joined_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load community members: ${e.toString()}');
    }
  }
  
  /// Get recommended communities for user
  Future<List<Map<String, dynamic>>> getRecommendedCommunities({
    int limit = 10,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        // Return popular public communities for non-authenticated users
        return getTrendingCommunities(limit: limit);
      }
      
      // Get user's institution
      final userProfile = await _supabase
          .from('users')
          .select('institution_id')
          .eq('id', userId)
          .single();
      
      final institutionId = userProfile['institution_id'];
      
      // Get communities from user's institution that they haven't joined
      var query = _supabase
          .from('communities')
          .select('''
            id, name, description, type, privacy_level,
            member_count, post_count, icon_url,
            institutions(name)
          ''')
          .eq('status', 'active');
      
      if (institutionId != null) {
        query = query.eq('institution_id', institutionId);
      }
      
      final result = await query
          .order('member_count', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load recommended communities: ${e.toString()}');
    }
  }
  
  /// Get community statistics
  Future<Map<String, dynamic>> getCommunityStats(String communityId) async {
    try {
      final community = await getCommunity(communityId);
      if (community == null) {
        throw Exception('Community not found');
      }
      
      // Get recent activity stats
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
      
      final recentPosts = await _supabase
          .from('confessions')
          .select('id')
          .eq('community_id', communityId)
          .eq('status', 'active')
          .gte('created_at', sevenDaysAgo);
      
      final recentComments = await _supabase
          .from('comments')
          .select('id')
          .eq('confession_id', communityId) // This would need a proper join
          .eq('status', 'active')
          .gte('created_at', sevenDaysAgo);
      
      return {
        'member_count': community['member_count'] ?? 0,
        'post_count': community['post_count'] ?? 0,
        'recent_posts': recentPosts.length,
        'recent_comments': recentComments.length,
        'activity_level': _calculateActivityLevel(
          recentPosts.length,
          recentComments.length,
          community['member_count'] ?? 0,
        ),
      };
    } catch (e) {
      throw Exception('Failed to load community stats: ${e.toString()}');
    }
  }
  
  /// Calculate activity level based on recent posts and comments
  String _calculateActivityLevel(int recentPosts, int recentComments, int memberCount) {
    if (memberCount == 0) return 'inactive';
    
    final postsPerMember = recentPosts / memberCount;
    final commentsPerMember = recentComments / memberCount;
    final totalActivity = postsPerMember + commentsPerMember;
    
    if (totalActivity > 0.1) return 'very_active';
    if (totalActivity > 0.05) return 'active';
    if (totalActivity > 0.01) return 'moderate';
    return 'low';
  }
  
  /// Clear user-specific caches
  void _clearUserCaches(String userId, String communityId) {
    _membershipCache.remove('${userId}_$communityId');
    _communityCache.remove(communityId);
  }
  
  /// Clear all caches
  void clearCache() {
    _communityCache.clear();
    _membershipCache.clear();
  }
}