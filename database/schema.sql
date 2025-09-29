-- =================================================================
-- COLLEGE CONFESSIONS - SECURE DATABASE SCHEMA
-- Supabase PostgreSQL with Row Level Security (RLS)
-- =================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =================================================================
-- 1. INSTITUTIONS TABLE
-- =================================================================
CREATE TABLE institutions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL CHECK (type IN ('college', 'school', 'coaching')),
  location VARCHAR(255),
  website VARCHAR(255),
  domain VARCHAR(100), -- Email domain for verification (e.g., 'mit.edu')
  is_verified BOOLEAN DEFAULT FALSE,
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_institutions_type ON institutions(type);
CREATE INDEX idx_institutions_domain ON institutions(domain);
CREATE UNIQUE INDEX idx_institutions_domain_unique ON institutions(domain) WHERE domain IS NOT NULL;

-- =================================================================
-- 2. USERS TABLE (Authentication + Profile)
-- =================================================================
CREATE TABLE users (
  -- Core Identity (linked to Supabase Auth)
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Anonymous Identity
  anonymous_id UUID UNIQUE DEFAULT uuid_generate_v4(),
  display_name VARCHAR(50), -- Optional display name
  
  -- Institution Verification
  institution_id UUID REFERENCES institutions(id),
  email_verified BOOLEAN DEFAULT FALSE,
  institution_verified BOOLEAN DEFAULT FALSE,
  verification_status VARCHAR(20) DEFAULT 'unverified' CHECK (
    verification_status IN ('unverified', 'pending', 'verified', 'rejected')
  ),
  
  -- Privacy Settings
  show_institution BOOLEAN DEFAULT FALSE,
  allow_anonymous_posts BOOLEAN DEFAULT TRUE,
  receive_notifications BOOLEAN DEFAULT TRUE,
  
  -- Security & Moderation
  is_banned BOOLEAN DEFAULT FALSE,
  ban_reason TEXT,
  ban_expires_at TIMESTAMP WITH TIME ZONE,
  trust_score INTEGER DEFAULT 50 CHECK (trust_score >= 0 AND trust_score <= 100),
  
  -- Activity Tracking
  last_active_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_anonymous_id ON users(anonymous_id);
CREATE INDEX idx_users_institution ON users(institution_id);
CREATE INDEX idx_users_verification_status ON users(verification_status);

-- =================================================================
-- 3. COMMUNITIES TABLE
-- =================================================================
CREATE TABLE communities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  
  -- Community Type
  type VARCHAR(20) DEFAULT 'open' CHECK (type IN ('open', 'institution', 'private')),
  
  -- Institution Specific
  institution_id UUID REFERENCES institutions(id),
  department VARCHAR(100), -- For academic communities
  
  -- Settings
  requires_approval BOOLEAN DEFAULT FALSE,
  allow_anonymous_posts BOOLEAN DEFAULT TRUE,
  allow_images BOOLEAN DEFAULT TRUE,
  max_posts_per_day INTEGER DEFAULT 10,
  
  -- Moderation
  is_active BOOLEAN DEFAULT TRUE,
  moderator_id UUID REFERENCES users(id),
  
  -- Stats
  member_count INTEGER DEFAULT 0,
  post_count INTEGER DEFAULT 0,
  
  -- Metadata
  tags TEXT[], -- Array of tags for discovery
  rules TEXT,
  icon_url TEXT,
  banner_url TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_communities_type ON communities(type);
CREATE INDEX idx_communities_institution ON communities(institution_id);
CREATE INDEX idx_communities_active ON communities(is_active);

-- =================================================================
-- 4. USER_COMMUNITIES (Membership)
-- =================================================================
CREATE TABLE user_communities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  community_id UUID NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
  
  -- Membership Details
  role VARCHAR(20) DEFAULT 'member' CHECK (role IN ('member', 'moderator', 'admin')),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('pending', 'active', 'banned', 'left')),
  
  -- Permissions
  can_post BOOLEAN DEFAULT TRUE,
  can_comment BOOLEAN DEFAULT TRUE,
  can_moderate BOOLEAN DEFAULT FALSE,
  
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, community_id)
);

-- Indexes
CREATE INDEX idx_user_communities_user ON user_communities(user_id);
CREATE INDEX idx_user_communities_community ON user_communities(community_id);
CREATE INDEX idx_user_communities_status ON user_communities(status);

-- =================================================================
-- 5. CONFESSIONS TABLE
-- =================================================================
CREATE TABLE confessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- Content
  title VARCHAR(500),
  content TEXT NOT NULL,
  content_hash TEXT NOT NULL, -- Hash for duplicate detection
  
  -- Author (Anonymous by design)
  author_id UUID REFERENCES users(id) ON DELETE SET NULL,
  anonymous_author_id UUID, -- Reference to user's anonymous_id
  author_institution_id UUID REFERENCES institutions(id),
  
  -- Community
  community_id UUID REFERENCES communities(id) ON DELETE CASCADE,
  
  -- Post Type
  post_type VARCHAR(20) DEFAULT 'confession' CHECK (
    post_type IN ('confession', 'question', 'advice', 'rant', 'appreciation')
  ),
  
  -- Privacy & Visibility
  is_anonymous BOOLEAN DEFAULT TRUE,
  visibility VARCHAR(20) DEFAULT 'public' CHECK (
    visibility IN ('public', 'community', 'institution')
  ),
  
  -- Content Moderation
  status VARCHAR(20) DEFAULT 'active' CHECK (
    status IN ('draft', 'active', 'reported', 'under_review', 'removed', 'banned')
  ),
  moderation_reason TEXT,
  moderated_by UUID REFERENCES users(id),
  moderated_at TIMESTAMP WITH TIME ZONE,
  
  -- Engagement Stats
  upvotes INTEGER DEFAULT 0,
  downvotes INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  report_count INTEGER DEFAULT 0,
  
  -- Metadata
  tags TEXT[],
  mentions TEXT[], -- Array of mentioned users/communities
  
  -- Media (if enabled)
  has_media BOOLEAN DEFAULT FALSE,
  media_urls TEXT[],
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_confessions_community ON confessions(community_id);
CREATE INDEX idx_confessions_author ON confessions(author_id);
CREATE INDEX idx_confessions_status ON confessions(status);
CREATE INDEX idx_confessions_created_at ON confessions(created_at DESC);
CREATE INDEX idx_confessions_activity ON confessions(last_activity_at DESC);
CREATE INDEX idx_confessions_content_hash ON confessions(content_hash);
CREATE INDEX idx_confessions_institution ON confessions(author_institution_id);

-- =================================================================
-- 6. COMMENTS TABLE
-- =================================================================
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- Hierarchy
  confession_id UUID NOT NULL REFERENCES confessions(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE, -- For nested replies
  thread_depth INTEGER DEFAULT 0 CHECK (thread_depth <= 5), -- Limit nesting
  
  -- Content
  content TEXT NOT NULL,
  content_hash TEXT NOT NULL,
  
  -- Author (Anonymous by design)
  author_id UUID REFERENCES users(id) ON DELETE SET NULL,
  anonymous_author_id UUID,
  is_anonymous BOOLEAN DEFAULT TRUE,
  
  -- Moderation
  status VARCHAR(20) DEFAULT 'active' CHECK (
    status IN ('active', 'reported', 'under_review', 'removed', 'banned')
  ),
  moderation_reason TEXT,
  moderated_by UUID REFERENCES users(id),
  moderated_at TIMESTAMP WITH TIME ZONE,
  
  -- Engagement
  upvotes INTEGER DEFAULT 0,
  downvotes INTEGER DEFAULT 0,
  report_count INTEGER DEFAULT 0,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_comments_confession ON comments(confession_id);
CREATE INDEX idx_comments_parent ON comments(parent_id);
CREATE INDEX idx_comments_author ON comments(author_id);
CREATE INDEX idx_comments_status ON comments(status);
CREATE INDEX idx_comments_created_at ON comments(created_at DESC);

-- =================================================================
-- 7. VOTES TABLE (Upvotes/Downvotes)
-- =================================================================
CREATE TABLE votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Polymorphic relationship (confession or comment)
  votable_type VARCHAR(20) NOT NULL CHECK (votable_type IN ('confession', 'comment')),
  votable_id UUID NOT NULL,
  
  -- Vote value
  vote_value SMALLINT NOT NULL CHECK (vote_value IN (-1, 1)), -- -1 downvote, 1 upvote
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure one vote per user per item
  UNIQUE(user_id, votable_type, votable_id)
);

-- Indexes
CREATE INDEX idx_votes_user ON votes(user_id);
CREATE INDEX idx_votes_votable ON votes(votable_type, votable_id);

-- =================================================================
-- 8. REPORTS TABLE (Content Moderation)
-- =================================================================
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- Reporter
  reporter_id UUID REFERENCES users(id) ON DELETE SET NULL,
  reporter_ip INET, -- For tracking abuse
  
  -- Reported Content (Polymorphic)
  reported_type VARCHAR(20) NOT NULL CHECK (reported_type IN ('confession', 'comment', 'user')),
  reported_id UUID NOT NULL,
  
  -- Report Details
  reason VARCHAR(50) NOT NULL CHECK (reason IN (
    'harassment', 'hate_speech', 'spam', 'inappropriate_content', 
    'false_information', 'privacy_violation', 'other'
  )),
  description TEXT,
  
  -- Status
  status VARCHAR(20) DEFAULT 'pending' CHECK (
    status IN ('pending', 'investigating', 'resolved', 'dismissed')
  ),
  
  -- Resolution
  resolved_by UUID REFERENCES users(id),
  resolved_at TIMESTAMP WITH TIME ZONE,
  resolution_action VARCHAR(50), -- 'removed', 'warning', 'ban', 'no_action'
  resolution_notes TEXT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_reports_reporter ON reports(reporter_id);
CREATE INDEX idx_reports_reported ON reports(reported_type, reported_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);

-- =================================================================
-- 9. NOTIFICATIONS TABLE
-- =================================================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- Recipient
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Notification Type
  type VARCHAR(50) NOT NULL CHECK (type IN (
    'new_comment', 'comment_reply', 'confession_upvote', 'comment_upvote',
    'community_invite', 'community_approval', 'mention', 'report_update',
    'system_announcement', 'moderation_action'
  )),
  
  -- Content
  title VARCHAR(255) NOT NULL,
  message TEXT,
  
  -- Related Objects (Polymorphic)
  related_type VARCHAR(20), -- 'confession', 'comment', 'community', etc.
  related_id UUID,
  
  -- Actor (who triggered the notification)
  actor_id UUID REFERENCES users(id) ON DELETE SET NULL,
  
  -- Status
  is_read BOOLEAN DEFAULT FALSE,
  is_pushed BOOLEAN DEFAULT FALSE, -- For push notifications
  
  -- Metadata
  data JSONB, -- Additional structured data
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_related ON notifications(related_type, related_id);

-- =================================================================
-- 10. USER_SESSIONS TABLE (Security Tracking)
-- =================================================================
CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Session Details
  session_token TEXT NOT NULL,
  device_info JSONB,
  ip_address INET,
  user_agent TEXT,
  
  -- Location (optional)
  country VARCHAR(2),
  city VARCHAR(100),
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() + INTERVAL '30 days'
);

-- Indexes
CREATE INDEX idx_user_sessions_user ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON user_sessions(session_token);
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active);

-- =================================================================
-- SECURITY: ROW LEVEL SECURITY (RLS) POLICIES
-- =================================================================

-- Enable RLS on all tables
ALTER TABLE institutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE confessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;