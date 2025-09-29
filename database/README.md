# College Confessions Backend - Database Setup Guide

## 🔐 Security-First Database Architecture

This database schema implements a comprehensive, secure backend for the College Confessions app with the following key security features:

### 🛡️ Security Features

1. **Row Level Security (RLS)** - Every table has granular access controls
2. **Anonymous Identity Protection** - Users have separate anonymous IDs
3. **Content Hash Tracking** - Prevents duplicate spam content
4. **Trust Score System** - User reputation based on community behavior
5. **Rate Limiting** - Prevents spam and abuse
6. **Automated Moderation** - Content flagging and user trust scoring
7. **Privacy Controls** - Users control their visibility and data sharing

### 📊 Database Tables

#### Core Tables:
- **institutions** - Verified colleges, schools, coaching centers
- **users** - User profiles with anonymous identity protection
- **communities** - Topic/institution-based discussion groups
- **confessions** - Anonymous posts with advanced privacy controls
- **comments** - Threaded replies with moderation support
- **votes** - Upvote/downvote system with anti-gaming measures

#### Security & Moderation:
- **reports** - Content reporting and moderation workflow
- **user_sessions** - Session tracking for security
- **notifications** - Real-time user notifications
- **user_communities** - Membership management with roles

### 🚀 Setup Instructions

#### 1. Supabase Project Setup

1. Go to [Supabase](https://supabase.com) and create a new project
2. Note down your:
   - Project URL
   - Public API Key (anon key)
   - Service Role Key

#### 2. Database Schema Deployment

Run the SQL files in this order:

```sql
-- 1. Core schema and tables
\i database/schema.sql

-- 2. Security policies and RLS
\i database/security_policies.sql

-- 3. Business logic and triggers
\i database/functions_triggers.sql

-- 4. Initial data and sample content
\i database/seed_data.sql
```

#### 3. Supabase Configuration

**Authentication Settings:**
- Enable email authentication
- Set up email templates for verification
- Configure JWT settings (default is fine)

**Storage Setup:**
```sql
-- Create storage bucket for user avatars and media
INSERT INTO storage.buckets (id, name, public) VALUES 
  ('avatars', 'avatars', true),
  ('confession-media', 'confession-media', true);

-- Set up storage policies
CREATE POLICY "Avatar upload for authenticated users" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.role() = 'authenticated');

CREATE POLICY "Public avatar access" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');
```

**Real-time Subscriptions:**
Enable real-time for these tables:
- `confessions`
- `comments` 
- `notifications`
- `votes`

### 🔧 Environment Variables

Add to your Flutter app's environment:

```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_KEY=your_service_key (server-side only)
```

### 📱 Flutter Integration

Update your `lib/services/` files to use the new schema:

#### 1. Update Supabase Configuration

```dart
// lib/core/config/supabase_config.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
```

#### 2. Authentication Service

```dart
// lib/services/auth_service.dart
class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Anonymous authentication for privacy
  Future<User?> signInAnonymously() async {
    final response = await _supabase.auth.signInAnonymously();
    return response.user;
  }
  
  // Email verification for institution access
  Future<void> signUpWithEmail(String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  // Institution verification
  Future<bool> verifyInstitutionEmail(String email) async {
    // Check if email domain matches verified institutions
    final domain = email.split('@').last;
    final result = await _supabase
        .from('institutions')
        .select('id')
        .eq('domain', domain)
        .eq('is_verified', true)
        .single();
    
    return result != null;
  }
}
```

#### 3. Confession Service

```dart
// lib/services/confession_service.dart
class ConfessionService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Post anonymous confession
  Future<Map<String, dynamic>> postConfession({
    required String content,
    String? title,
    required String communityId,
    List<String>? tags,
    bool isAnonymous = true,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    final confession = {
      'content': content,
      'title': title,
      'community_id': communityId,
      'author_id': user.id,
      'is_anonymous': isAnonymous,
      'tags': tags,
      'post_type': 'confession',
    };
    
    final result = await _supabase
        .from('confessions')
        .insert(confession)
        .select()
        .single();
    
    return result;
  }
  
  // Get community confessions with real-time updates
  Stream<List<Map<String, dynamic>>> getCommunityConfessions(String communityId) {
    return _supabase
        .from('confessions')
        .stream(primaryKey: ['id'])
        .eq('community_id', communityId)
        .eq('status', 'active')
        .order('created_at', ascending: false);
  }
  
  // Vote on confession
  Future<void> voteOnConfession(String confessionId, int voteValue) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    await _supabase.from('votes').upsert({
      'user_id': user.id,
      'votable_type': 'confession',
      'votable_id': confessionId,
      'vote_value': voteValue,
    });
  }
}
```

### 🔒 Security Best Practices

1. **Never expose service keys** in client-side code
2. **Use RLS policies** - All data access is controlled server-side
3. **Validate all inputs** - Use the built-in validation functions
4. **Monitor trust scores** - Low trust users get limited access
5. **Rate limiting** - Prevent spam and abuse automatically
6. **Content moderation** - Reports are automatically processed
7. **Anonymous protection** - User identities are protected by design

### 📈 Performance Optimizations

1. **Database Indexes** - All frequently queried columns are indexed
2. **Pagination** - Use `range()` for large result sets
3. **Real-time Subscriptions** - Only subscribe to active communities
4. **Content Caching** - Cache community lists and user preferences
5. **Image Optimization** - Use Supabase storage transformations

### 🛠️ Monitoring & Maintenance

#### Regular Maintenance Tasks:
```sql
-- Run weekly cleanup
SELECT cleanup_old_data();

-- Monitor trust scores
SELECT 
  trust_score_range,
  COUNT(*) as user_count
FROM (
  SELECT 
    CASE 
      WHEN trust_score < 30 THEN 'Low (0-29)'
      WHEN trust_score < 70 THEN 'Medium (30-69)'
      ELSE 'High (70-100)'
    END as trust_score_range
  FROM users
) t
GROUP BY trust_score_range;

-- Check community health
SELECT 
  c.name,
  c.member_count,
  c.post_count,
  COUNT(r.id) as report_count
FROM communities c
LEFT JOIN confessions cf ON cf.community_id = c.id
LEFT JOIN reports r ON r.reported_id = cf.id
WHERE c.is_active = true
GROUP BY c.id, c.name, c.member_count, c.post_count
ORDER BY report_count DESC;
```

### 🚀 Deployment Checklist

- [ ] Supabase project created and configured
- [ ] All SQL files executed successfully
- [ ] RLS policies enabled and tested
- [ ] Storage buckets created and configured
- [ ] Real-time subscriptions enabled
- [ ] Environment variables configured in Flutter app
- [ ] Authentication flow tested
- [ ] Basic CRUD operations tested
- [ ] Rate limiting and security features verified
- [ ] Sample data loaded successfully

### 📞 Support & Troubleshooting

Common issues and solutions:

1. **RLS Policy Errors**: Check that users are properly authenticated
2. **Rate Limiting**: Users hitting limits should wait or contact moderators
3. **Trust Score Issues**: New users start with limited privileges
4. **Community Access**: Institution verification required for private communities
5. **Real-time Updates**: Ensure proper subscription setup in Flutter

This schema provides a solid foundation for a secure, scalable anonymous confession platform with proper privacy protections and community moderation tools.