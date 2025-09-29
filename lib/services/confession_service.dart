import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';

/// Service for managing confessions and community interactions
class ConfessionService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Cache for community data
  final Map<String, Map<String, dynamic>> _communityCache = {};
  
  /// Post a new confession
  Future<Map<String, dynamic>> postConfession({
    required String content,
    String? title,
    required String communityId,
    List<String>? tags,
    bool isAnonymous = true,
    String postType = 'confession',
    String visibility = 'public',
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Get user's anonymous ID
      final userProfile = await _supabase
          .from('users')
          .select('anonymous_id, institution_id')
          .eq('id', userId)
          .single();
      
      final confession = {
        'content': content,
        'title': title,
        'community_id': communityId,
        'author_id': userId,
        'anonymous_author_id': userProfile['anonymous_id'],
        'author_institution_id': userProfile['institution_id'],
        'is_anonymous': isAnonymous,
        'post_type': postType,
        'visibility': visibility,
        'tags': tags,
        'status': 'active',
      };
      
      final result = await _supabase
          .from('confessions')
          .insert(confession)
          .select('''
            id, title, content, created_at, updated_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, visibility, tags,
            anonymous_author_id, author_institution_id,
            communities!inner(id, name, type)
          ''')
          .single();
      
      return result;
    } catch (e) {
      throw Exception('Failed to post confession: ${e.toString()}');
    }
  }
  
  /// Get confessions for a specific community with real-time updates
  Stream<List<Map<String, dynamic>>> getCommunityConfessions(
    String communityId, {
    int limit = 20,
    int offset = 0,
    String orderBy = 'created_at',
    bool ascending = false,
  }) {
    return _supabase
        .from('confessions')
        .stream(primaryKey: ['id'])
        .eq('community_id', communityId)
        .eq('status', 'active');
  }
  
  /// Get all confessions for home feed (public and user's communities)
  Future<List<Map<String, dynamic>>> getHomeFeedConfessions({
    int limit = 20,
    String orderBy = 'last_activity_at',
  }) async {
    try {
      final result = await _supabase
          .from('confessions')
          .select('''
            id, title, content, created_at, updated_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, visibility, tags,
            anonymous_author_id, author_institution_id,
            communities!inner(id, name, type)
          ''')
          .eq('status', 'active')
          .or('visibility.eq.public,visibility.eq.community')
          .order(orderBy, ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load home feed: ${e.toString()}');
    }
  }
  
  /// Get real-time updates for home feed
  Stream<List<Map<String, dynamic>>> getHomeFeedStream() {
    return _supabase
        .from('confessions')
        .stream(primaryKey: ['id'])
        .eq('status', 'active');
  }
  
  /// Get a single confession with details
  Future<Map<String, dynamic>?> getConfession(String confessionId) async {
    try {
      final result = await _supabase
          .from('confessions')
          .select('''
            id, title, content, created_at, updated_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, visibility, tags,
            anonymous_author_id, author_institution_id,
            communities!inner(id, name, type, institution_id),
            institutions(id, name, type)
          ''')
          .eq('id', confessionId)
          .eq('status', 'active')
          .maybeSingle();
      
      return result;
    } catch (e) {
      throw Exception('Failed to load confession: ${e.toString()}');
    }
  }
  
  /// Vote on a confession
  Future<void> voteOnConfession(String confessionId, int voteValue) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Check user's trust score
      await _checkUserCanVote(userId);
      
      // Upsert vote (insert or update existing)
      await _supabase.from('votes').upsert({
        'user_id': userId,
        'votable_type': 'confession',
        'votable_id': confessionId,
        'vote_value': voteValue,
      });
    } catch (e) {
      throw Exception('Failed to vote: ${e.toString()}');
    }
  }
  
  /// Remove vote from confession
  Future<void> removeVoteFromConfession(String confessionId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase
          .from('votes')
          .delete()
          .eq('user_id', userId)
          .eq('votable_type', 'confession')
          .eq('votable_id', confessionId);
    } catch (e) {
      throw Exception('Failed to remove vote: ${e.toString()}');
    }
  }
  
  /// Get user's vote on a confession
  Future<int?> getUserVote(String confessionId) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) return null;
      
      final result = await _supabase
          .from('votes')
          .select('vote_value')
          .eq('user_id', userId)
          .eq('votable_type', 'confession')
          .eq('votable_id', confessionId)
          .maybeSingle();
      
      return result?['vote_value'];
    } catch (e) {
      return null;
    }
  }
  
  /// Add comment to confession
  Future<Map<String, dynamic>> addComment({
    required String confessionId,
    required String content,
    String? parentId,
    bool isAnonymous = true,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Get user's anonymous ID
      final userProfile = await _supabase
          .from('users')
          .select('anonymous_id')
          .eq('id', userId)
          .single();
      
      // Calculate thread depth if this is a reply
      int threadDepth = 0;
      if (parentId != null) {
        final parentComment = await _supabase
            .from('comments')
            .select('thread_depth')
            .eq('id', parentId)
            .single();
        threadDepth = (parentComment['thread_depth'] ?? 0) + 1;
        
        // Limit nesting depth
        if (threadDepth > 5) {
          throw Exception('Maximum reply depth reached');
        }
      }
      
      final comment = {
        'confession_id': confessionId,
        'parent_id': parentId,
        'content': content,
        'author_id': userId,
        'anonymous_author_id': userProfile['anonymous_id'],
        'is_anonymous': isAnonymous,
        'thread_depth': threadDepth,
        'status': 'active',
      };
      
      final result = await _supabase
          .from('comments')
          .insert(comment)
          .select('''
            id, content, created_at, updated_at,
            upvotes, downvotes, thread_depth,
            is_anonymous, anonymous_author_id,
            parent_id
          ''')
          .single();
      
      return result;
    } catch (e) {
      throw Exception('Failed to add comment: ${e.toString()}');
    }
  }
  
  /// Get comments for a confession
  Future<List<Map<String, dynamic>>> getConfessionComments(
    String confessionId, {
    int limit = 50,
    String orderBy = 'created_at',
  }) async {
    try {
      final result = await _supabase
          .from('comments')
          .select('''
            id, content, created_at, updated_at,
            upvotes, downvotes, thread_depth,
            is_anonymous, anonymous_author_id,
            parent_id
          ''')
          .eq('confession_id', confessionId)
          .eq('status', 'active')
          .order(orderBy)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load comments: ${e.toString()}');
    }
  }
  
  /// Vote on a comment
  Future<void> voteOnComment(String commentId, int voteValue) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Check user's trust score
      await _checkUserCanVote(userId);
      
      await _supabase.from('votes').upsert({
        'user_id': userId,
        'votable_type': 'comment',
        'votable_id': commentId,
        'vote_value': voteValue,
      });
    } catch (e) {
      throw Exception('Failed to vote on comment: ${e.toString()}');
    }
  }
  
  /// Report content (confession or comment)
  Future<void> reportContent({
    required String contentType, // 'confession' or 'comment'
    required String contentId,
    required String reason,
    String? description,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _supabase.from('reports').insert({
        'reporter_id': userId,
        'reported_type': contentType,
        'reported_id': contentId,
        'reason': reason,
        'description': description,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Failed to report content: ${e.toString()}');
    }
  }
  
  /// Search confessions
  Future<List<Map<String, dynamic>>> searchConfessions({
    required String query,
    List<String>? communities,
    List<String>? tags,
    String? postType,
    int limit = 20,
  }) async {
    try {
      var searchQuery = _supabase
          .from('confessions')
          .select('''
            id, title, content, created_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, tags,
            communities!inner(id, name)
          ''')
          .eq('status', 'active')
          .textSearch('content', query);
      
      if (communities != null && communities.isNotEmpty) {
        searchQuery = searchQuery.inFilter('community_id', communities);
      }
      
      if (postType != null) {
        searchQuery = searchQuery.eq('post_type', postType);
      }
      
      final result = await searchQuery
          .order('created_at', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Search failed: ${e.toString()}');
    }
  }
  
  /// Get trending confessions
  Future<List<Map<String, dynamic>>> getTrendingConfessions({
    int limit = 20,
    Duration timeFrame = const Duration(days: 7),
  }) async {
    try {
      final since = DateTime.now().subtract(timeFrame).toIso8601String();
      
      final result = await _supabase
          .from('confessions')
          .select('''
            id, title, content, created_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, tags,
            communities!inner(id, name)
          ''')
          .eq('status', 'active')
          .gte('created_at', since)
          .order('upvotes', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load trending confessions: ${e.toString()}');
    }
  }
  
  /// Get user's confessions
  Future<List<Map<String, dynamic>>> getUserConfessions({
    bool includeAnonymous = true,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      final result = await _supabase
          .from('confessions')
          .select('''
            id, title, content, created_at,
            upvotes, downvotes, comment_count,
            is_anonymous, post_type, status,
            communities!inner(id, name)
          ''')
          .eq('author_id', userId)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
      
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw Exception('Failed to load user confessions: ${e.toString()}');
    }
  }
  
  /// Check if user can vote (trust score requirement)
  Future<void> _checkUserCanVote(String userId) async {
    final userProfile = await _supabase
        .from('users')
        .select('trust_score')
        .eq('id', userId)
        .single();
    
    final trustScore = userProfile['trust_score'] ?? 0;
    if (trustScore < 10) {
      throw Exception('Minimum trust score required to vote');
    }
  }
  
  /// Clear community cache
  void clearCache() {
    _communityCache.clear();
  }
}