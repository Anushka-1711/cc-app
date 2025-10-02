# 🔗 Frontend-Backend Integration Guide

## 🚀 **Quick Integration Steps**

### **Step 1: Update Home Feed Screen**

Replace the static mock data in `home_feed_screen.dart`:

```dart
// Replace this section (around line 14-16):
class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ConfessionPost> _posts = _generateMockPosts(); // ❌ Remove this
  bool _isLoading = false;

// With this:
class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize real-time connection
    ServiceProvider.confession.getHomeFeedStream().listen((posts) {
      // Handle real-time updates
    });
  }

// Replace the build method's ListView with:
StreamBuilder<List<Map<String, dynamic>>>(
  stream: ServiceProvider.confession.getHomeFeedStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    
    final posts = snapshot.data ?? [];
    return ListView.builder(
      controller: _scrollController,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ConfessionCard(
          id: post['id'],
          content: post['content'],
          timeAgo: _formatTimeAgo(DateTime.parse(post['created_at'])),
          likes: post['upvotes'] ?? 0,
          comments: post['comment_count'] ?? 0,
          community: post['communities']['name'],
          isLiked: false, // Check user's vote status
          onLike: () => _handleVote(post['id'], 1),
          onComment: () => _navigateToComments(post['id']),
        );
      },
    );
  },
)
```

### **Step 2: Connect Authentication**

Update `login_screen.dart`:

```dart
// Replace the _handleLogin method (around line 26):
Future<void> _handleLogin() async {
  setState(() => _isLoading = true);
  
  try {
    // Real Supabase authentication
    await ServiceProvider.auth.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppScreen()),
      );
    }
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

// Add anonymous login option:
Future<void> _handleAnonymousLogin() async {
  setState(() => _isLoading = true);
  
  try {
    await ServiceProvider.auth.signInAnonymously();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppScreen()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Anonymous login failed: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

### **Step 3: Connect Create Post Screen**

Update `create_post_screen.dart`:

```dart
// Add these imports at the top:
import '../services/services.dart';

// Replace the _submitPost method or add it:
Future<void> _submitPost() async {
  if (_textController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter some content')),
    );
    return;
  }
  
  setState(() => _isLoading = true);
  
  try {
    // Get community ID (you'll need to map from name to ID)
    final communityId = await _getCommunityId(_selectedCommunity);
    
    await ServiceProvider.confession.postConfession(
      content: _textController.text.trim(),
      communityId: communityId,
      isAnonymous: _isAnonymous,
    );
    
    // Clear form and show success
    _textController.clear();
    setState(() => _selectedCommunity = _communities[0]);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post submitted successfully!')),
    );
    
    // Navigate back to home
    Navigator.of(context).pop();
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to post: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

// Add helper method to get community ID:
Future<String> _getCommunityId(String communityName) async {
  final communities = await ServiceProvider.community.getCommunities();
  final community = communities.firstWhere(
    (c) => c['name'] == communityName,
    orElse: () => communities.first,
  );
  return community['id'];
}
```

### **Step 4: Connect Notifications**

Update `notifications_screen.dart`:

```dart
// Add real-time notifications:
StreamBuilder<List<Map<String, dynamic>>>(
  stream: ServiceProvider.notification.notificationStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final notifications = snapshot.data!;
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = ServiceProvider.notification
              .formatNotification(notifications[index]);
          
          return NotificationTile(
            title: notification['title'],
            message: notification['message'],
            timeAgo: notification['formatted_time'],
            isRead: notification['is_read'],
            icon: notification['icon'],
            onTap: () => _handleNotificationTap(notification),
          );
        },
      );
    }
    return const Center(child: CircularProgressIndicator());
  },
)
```

### **Step 5: Implement Communities Screen**

Replace the placeholder in `communities_screen.dart`:

```dart
class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ServiceProvider.community.getCommunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading communities: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          
          final communities = snapshot.data ?? [];
          
          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return CommunityTile(
                name: community['name'],
                description: community['description'],
                memberCount: community['member_count'] ?? 0,
                postCount: community['post_count'] ?? 0,
                iconUrl: community['icon_url'],
                onTap: () => _joinCommunity(context, community['id']),
              );
            },
          );
        },
      ),
    );
  }
  
  void _showSearch(BuildContext context) {
    // Implement search functionality
    showSearch(
      context: context,
      delegate: CommunitySearchDelegate(),
    );
  }
  
  Future<void> _joinCommunity(BuildContext context, String communityId) async {
    try {
      await ServiceProvider.community.joinCommunity(communityId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined community successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join: ${e.toString()}')),
      );
    }
  }
}
```

## 🎯 **Enhanced Features to Add**

### **Feature 1: Image Support in Posts**

Add to `create_post_screen.dart`:

```dart
// Add image picker dependency to pubspec.yaml:
// image_picker: ^1.0.4

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }
  
  // Add image upload to post submission:
  Future<void> _submitPost() async {
    String? imageUrl;
    
    if (_selectedImage != null) {
      // Upload image to Supabase Storage
      imageUrl = await ServiceProvider.confession.uploadImage(_selectedImage!);
    }
    
    await ServiceProvider.confession.postConfession(
      content: _textController.text.trim(),
      communityId: communityId,
      isAnonymous: _isAnonymous,
      imageUrl: imageUrl, // Add image support
    );
  }
}
```

### **Feature 2: Real-Time Voting**

Add to confession cards:

```dart
class ConfessionCard extends StatefulWidget {
  final String id;
  final int initialUpvotes;
  // ... other properties
  
  Future<void> _handleVote(int voteValue) async {
    try {
      await ServiceProvider.confession.voteOnConfession(widget.id, voteValue);
      // Update UI optimistically
      setState(() {
        _userVote = voteValue;
        _upvotes += voteValue;
      });
    } catch (e) {
      // Revert optimistic update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote failed: ${e.toString()}')),
      );
    }
  }
}
```

### **Feature 3: Advanced Search**

```dart
class CommunitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ServiceProvider.community.searchCommunities(query: query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final community = snapshot.data![index];
              return ListTile(
                title: Text(community['name']),
                subtitle: Text(community['description']),
                onTap: () => close(context, community['id']),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
```

## 🔧 **Testing Your Integration**

### **1. Test Authentication**
```bash
# Run the app and try:
1. Anonymous login
2. Email/password login
3. Check if user session persists
```

### **2. Test Real-Time Features**
```bash
# Open app on two devices/emulators:
1. Post a confession on device 1
2. Check if it appears on device 2 instantly
3. Vote on device 2, see vote count update on device 1
```

### **3. Test Community Features**
```bash
# Test community functionality:
1. Browse communities
2. Join a community
3. Post in that community
4. Check community-specific feeds
```

## 🚀 **Performance Tips**

### **1. Optimize Real-Time Subscriptions**
```dart
// Use proper stream management
StreamSubscription? _confessionSubscription;
StreamSubscription? _notificationSubscription;

@override
void dispose() {
  _confessionSubscription?.cancel();
  _notificationSubscription?.cancel();
  super.dispose();
}
```

### **2. Implement Caching**
```dart
// Cache frequently accessed data
final Map<String, List<Map<String, dynamic>>> _communityCache = {};

Future<List<Map<String, dynamic>>> getCachedCommunities() async {
  if (_communityCache.containsKey('all')) {
    return _communityCache['all']!;
  }
  
  final communities = await ServiceProvider.community.getCommunities();
  _communityCache['all'] = communities;
  return communities;
}
```

### **3. Add Loading States**
```dart
// Show loading indicators for better UX
class LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(height: 100, color: Colors.white),
      ),
    );
  }
}
```

## ✅ **Integration Checklist**

- [ ] Replace mock authentication with real Supabase auth
- [ ] Connect home feed to real-time confession stream
- [ ] Implement post submission with backend
- [ ] Add real-time notifications
- [ ] Complete communities screen implementation
- [ ] Add image upload functionality
- [ ] Implement search and discovery
- [ ] Add voting and commenting
- [ ] Test real-time features
- [ ] Optimize performance with caching
- [ ] Add proper error handling
- [ ] Implement offline support

## 🎯 **Result: Superior App Experience**

After integration, your app will have:

1. **Real-time updates** (better than Yik Yak)
2. **Enterprise-grade security** (better than all competitors)
3. **Institution verification** (unique feature)
4. **Advanced community system** (better than Jodel)
5. **Trust-based moderation** (prevents Yik Yak's bullying issues)
6. **Modern Flutter UI** (better than outdated competitor UIs)

Your backend is already superior to competitors - now connect it to dominate the market! 🚀