# College Confessions Backend Setup

This document guides you through setting up the complete backend infrastructure for the College Confessions app using Supabase.

## 🚀 Quick Start

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new account
2. Create a new project
3. Wait for the project to be fully provisioned
4. Note down your project URL and anon key from the project settings

### 2. Configure Environment

1. Copy `.env.example` to `.env`
2. Fill in your Supabase credentials:
   ```
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

### 3. Set Up Database

Execute the SQL files in this order in your Supabase SQL Editor:

1. **Schema Creation**: Run `database/schema.sql`
   - Creates all tables, indexes, and constraints
   - Sets up UUID extensions and triggers

2. **Security Policies**: Run `database/security_policies.sql`
   - Implements Row Level Security (RLS)
   - Ensures users can only access authorized data

3. **Business Logic**: Run `database/functions_triggers.sql`
   - Adds automated vote counting
   - Sets up notification triggers
   - Implements trust score calculations

4. **Sample Data**: Run `database/seed_data.sql` (optional)
   - Adds sample institutions and communities
   - Creates test data for development

### 4. Configure Authentication

In your Supabase dashboard:

1. **Authentication Settings**:
   - Enable email confirmation
   - Set up email templates
   - Configure redirect URLs

2. **Email Provider**:
   - For production: Configure SMTP settings
   - For development: Use Supabase's built-in email service

## 📋 Database Schema Overview

### Core Tables

- **users**: User profiles with anonymous IDs
- **institutions**: Educational institutions
- **communities**: Institution-based communities
- **confessions**: Anonymous posts
- **comments**: Nested comment system
- **votes**: Upvote/downvote system
- **notifications**: Real-time notifications
- **reports**: Content moderation
- **user_communities**: Community memberships
- **user_sessions**: Session tracking

### Security Features

- **Row Level Security**: All tables protected
- **Anonymous Identity**: Users have separate anonymous IDs
- **Institution Verification**: Email-based verification system
- **Trust Scoring**: Behavior-based reputation system
- **Content Moderation**: Report and review system

## 🔐 Security Implementation

### Anonymous Protection
- User real IDs never exposed in public content
- Anonymous IDs generated per institution
- No cross-referencing between real and anonymous identities

### Data Access Control
- Users can only see content from their institution's communities
- Moderators have additional permissions within their communities
- Admins have institution-wide access

### Content Moderation
- Automated spam detection
- User reporting system
- Trust score-based privileges
- Rate limiting on posting

## 🛠 API Services

The app includes comprehensive service classes:

### AuthService
- Anonymous sign-in
- Email verification
- Institution verification
- Profile management

### ConfessionService
- Post management
- Voting system
- Comment threads
- Content search

### CommunityService
- Community discovery
- Membership management
- Community statistics

### NotificationService
- Real-time updates
- Push notifications
- Notification preferences

## 📱 Flutter Integration

### Initialization
```dart
// In main.dart
await SupabaseConfig.initialize();
await ServiceProvider.initialize();
```

### Using Services
```dart
// Authentication
await ServiceProvider.auth.signInAnonymously();

// Post confession
await ServiceProvider.confession.postConfession(
  content: "Anonymous confession...",
  communityId: communityId,
);

// Join community
await ServiceProvider.community.joinCommunity(communityId);
```

## 🔧 Configuration Options

### Supabase Settings

1. **Database**:
   - Enable real-time subscriptions
   - Configure connection pooling
   - Set up database backups

2. **Authentication**:
   - Email confirmation required
   - Password strength requirements
   - Session timeout settings

3. **Storage** (if using for images):
   - Public bucket for community avatars
   - Private bucket for user content
   - File size and type restrictions

### App Features

- **Anonymous Mode**: Default posting mode
- **Trust Scoring**: Behavioral reputation system
- **Institution Verification**: Email domain verification
- **Real-time Updates**: Live confession and comment feeds
- **Content Moderation**: Community-driven reporting

## 🚨 Important Security Notes

1. **Never expose service role keys** in client code
2. **Always validate user input** before database operations
3. **Use Row Level Security** for all sensitive data
4. **Implement rate limiting** to prevent abuse
5. **Regular security audits** of database policies

## 📊 Monitoring & Analytics

### Database Monitoring
- Query performance tracking
- Connection pool monitoring
- Storage usage alerts

### App Analytics
- User engagement metrics
- Content creation patterns
- Community growth tracking

## 🔄 Backup & Recovery

1. **Database Backups**:
   - Automated daily backups via Supabase
   - Point-in-time recovery available

2. **Data Export**:
   - User can export their data
   - GDPR compliance ready

## 🚀 Deployment

### Production Checklist

- [ ] Environment variables configured
- [ ] Database schema deployed
- [ ] Security policies active
- [ ] Email provider configured
- [ ] SSL certificates installed
- [ ] Monitoring set up
- [ ] Backup procedures tested

### Performance Optimization

- Database indexing for common queries
- Connection pooling configuration
- CDN for static assets
- Image optimization for avatars

## 📞 Support

For issues with the backend setup:

1. Check Supabase project logs
2. Verify database schema execution
3. Test API endpoints in Supabase dashboard
4. Review authentication flow
5. Check network connectivity

## 🔗 Useful Links

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)