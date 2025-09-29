-- =================================================================
-- BUSINESS LOGIC FUNCTIONS & TRIGGERS
-- Automated data integrity and business rules
-- =================================================================

-- =================================================================
-- VOTE MANAGEMENT FUNCTIONS
-- =================================================================

-- Function to update vote counts when votes are added/updated/deleted
CREATE OR REPLACE FUNCTION update_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
  -- Handle confession votes
  IF (TG_OP = 'DELETE' OR OLD.votable_type = 'confession') THEN
    UPDATE confessions 
    SET 
      upvotes = (
        SELECT COUNT(*) FROM votes 
        WHERE votable_type = 'confession' 
        AND votable_id = COALESCE(OLD.votable_id, NEW.votable_id)
        AND vote_value = 1
      ),
      downvotes = (
        SELECT COUNT(*) FROM votes 
        WHERE votable_type = 'confession' 
        AND votable_id = COALESCE(OLD.votable_id, NEW.votable_id)
        AND vote_value = -1
      )
    WHERE id = COALESCE(OLD.votable_id, NEW.votable_id);
  END IF;

  -- Handle comment votes
  IF (TG_OP = 'DELETE' OR OLD.votable_type = 'comment') THEN
    UPDATE comments 
    SET 
      upvotes = (
        SELECT COUNT(*) FROM votes 
        WHERE votable_type = 'comment' 
        AND votable_id = COALESCE(OLD.votable_id, NEW.votable_id)
        AND vote_value = 1
      ),
      downvotes = (
        SELECT COUNT(*) FROM votes 
        WHERE votable_type = 'comment' 
        AND votable_id = COALESCE(OLD.votable_id, NEW.votable_id)
        AND vote_value = -1
      )
    WHERE id = COALESCE(OLD.votable_id, NEW.votable_id);
  END IF;

  -- Handle NEW votes for INSERT/UPDATE
  IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
    -- Handle confession votes
    IF NEW.votable_type = 'confession' THEN
      UPDATE confessions 
      SET 
        upvotes = (
          SELECT COUNT(*) FROM votes 
          WHERE votable_type = 'confession' 
          AND votable_id = NEW.votable_id
          AND vote_value = 1
        ),
        downvotes = (
          SELECT COUNT(*) FROM votes 
          WHERE votable_type = 'confession' 
          AND votable_id = NEW.votable_id
          AND vote_value = -1
        )
      WHERE id = NEW.votable_id;
    END IF;

    -- Handle comment votes
    IF NEW.votable_type = 'comment' THEN
      UPDATE comments 
      SET 
        upvotes = (
          SELECT COUNT(*) FROM votes 
          WHERE votable_type = 'comment' 
          AND votable_id = NEW.votable_id
          AND vote_value = 1
        ),
        downvotes = (
          SELECT COUNT(*) FROM votes 
          WHERE votable_type = 'comment' 
          AND votable_id = NEW.votable_id
          AND vote_value = -1
        )
      WHERE id = NEW.votable_id;
    END IF;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Apply vote count triggers
CREATE TRIGGER vote_counts_trigger
  AFTER INSERT OR UPDATE OR DELETE ON votes
  FOR EACH ROW EXECUTE FUNCTION update_vote_counts();

-- =================================================================
-- COMMENT COUNT MANAGEMENT
-- =================================================================

-- Function to update comment counts on confessions
CREATE OR REPLACE FUNCTION update_comment_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    UPDATE confessions 
    SET comment_count = (
      SELECT COUNT(*) FROM comments 
      WHERE confession_id = OLD.confession_id 
      AND status = 'active'
    )
    WHERE id = OLD.confession_id;
    RETURN OLD;
  ELSIF TG_OP = 'INSERT' THEN
    UPDATE confessions 
    SET 
      comment_count = (
        SELECT COUNT(*) FROM comments 
        WHERE confession_id = NEW.confession_id 
        AND status = 'active'
      ),
      last_activity_at = NOW()
    WHERE id = NEW.confession_id;
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Only update if status changed
    IF OLD.status != NEW.status THEN
      UPDATE confessions 
      SET comment_count = (
        SELECT COUNT(*) FROM comments 
        WHERE confession_id = NEW.confession_id 
        AND status = 'active'
      )
      WHERE id = NEW.confession_id;
    END IF;
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply comment count trigger
CREATE TRIGGER comment_counts_trigger
  AFTER INSERT OR UPDATE OR DELETE ON comments
  FOR EACH ROW EXECUTE FUNCTION update_comment_counts();

-- =================================================================
-- COMMUNITY MEMBER COUNT MANAGEMENT
-- =================================================================

-- Function to update member counts in communities
CREATE OR REPLACE FUNCTION update_community_member_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    UPDATE communities 
    SET member_count = (
      SELECT COUNT(*) FROM user_communities 
      WHERE community_id = OLD.community_id 
      AND status = 'active'
    )
    WHERE id = OLD.community_id;
    RETURN OLD;
  ELSIF TG_OP = 'INSERT' THEN
    UPDATE communities 
    SET member_count = (
      SELECT COUNT(*) FROM user_communities 
      WHERE community_id = NEW.community_id 
      AND status = 'active'
    )
    WHERE id = NEW.community_id;
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Only update if status changed
    IF OLD.status != NEW.status THEN
      UPDATE communities 
      SET member_count = (
        SELECT COUNT(*) FROM user_communities 
        WHERE community_id = NEW.community_id 
        AND status = 'active'
      )
      WHERE id = NEW.community_id;
    END IF;
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply member count trigger
CREATE TRIGGER community_member_counts_trigger
  AFTER INSERT OR UPDATE OR DELETE ON user_communities
  FOR EACH ROW EXECUTE FUNCTION update_community_member_counts();

-- =================================================================
-- COMMUNITY POST COUNT MANAGEMENT
-- =================================================================

-- Function to update post counts in communities
CREATE OR REPLACE FUNCTION update_community_post_counts()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    UPDATE communities 
    SET post_count = (
      SELECT COUNT(*) FROM confessions 
      WHERE community_id = OLD.community_id 
      AND status = 'active'
    )
    WHERE id = OLD.community_id;
    RETURN OLD;
  ELSIF TG_OP = 'INSERT' THEN
    UPDATE communities 
    SET post_count = (
      SELECT COUNT(*) FROM confessions 
      WHERE community_id = NEW.community_id 
      AND status = 'active'
    )
    WHERE id = NEW.community_id;
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    -- Only update if status changed
    IF OLD.status != NEW.status THEN
      UPDATE communities 
      SET post_count = (
        SELECT COUNT(*) FROM confessions 
        WHERE community_id = NEW.community_id 
        AND status = 'active'
      )
      WHERE id = NEW.community_id;
    END IF;
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply post count trigger
CREATE TRIGGER community_post_counts_trigger
  AFTER INSERT OR UPDATE OR DELETE ON confessions
  FOR EACH ROW EXECUTE FUNCTION update_community_post_counts();

-- =================================================================
-- CONTENT HASH GENERATION (Duplicate Detection)
-- =================================================================

-- Function to generate content hash for duplicate detection
CREATE OR REPLACE FUNCTION generate_content_hash()
RETURNS TRIGGER AS $$
BEGIN
  -- Generate hash for confessions
  IF TG_TABLE_NAME = 'confessions' THEN
    NEW.content_hash = encode(digest(
      LOWER(TRIM(NEW.content)) || COALESCE(LOWER(TRIM(NEW.title)), ''), 
      'sha256'
    ), 'hex');
  END IF;

  -- Generate hash for comments
  IF TG_TABLE_NAME = 'comments' THEN
    NEW.content_hash = encode(digest(
      LOWER(TRIM(NEW.content)), 
      'sha256'
    ), 'hex');
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply content hash triggers
CREATE TRIGGER confession_content_hash_trigger
  BEFORE INSERT OR UPDATE ON confessions
  FOR EACH ROW EXECUTE FUNCTION generate_content_hash();

CREATE TRIGGER comment_content_hash_trigger
  BEFORE INSERT OR UPDATE ON comments
  FOR EACH ROW EXECUTE FUNCTION generate_content_hash();

-- =================================================================
-- USER TRUST SCORE MANAGEMENT
-- =================================================================

-- Function to update user trust scores based on activity
CREATE OR REPLACE FUNCTION update_user_trust_score()
RETURNS TRIGGER AS $$
DECLARE
  user_id_to_update UUID;
  score_change INTEGER := 0;
BEGIN
  -- Determine which user's score to update
  IF TG_TABLE_NAME = 'confessions' THEN
    user_id_to_update := COALESCE(NEW.author_id, OLD.author_id);
    IF TG_OP = 'INSERT' THEN
      score_change := 1; -- +1 for creating content
    ELSIF TG_OP = 'UPDATE' AND OLD.status = 'active' AND NEW.status = 'removed' THEN
      score_change := -5; -- -5 for having content removed
    END IF;
  ELSIF TG_TABLE_NAME = 'votes' AND TG_OP = 'INSERT' THEN
    -- User receiving the vote
    IF NEW.votable_type = 'confession' THEN
      SELECT author_id INTO user_id_to_update FROM confessions WHERE id = NEW.votable_id;
    ELSIF NEW.votable_type = 'comment' THEN
      SELECT author_id INTO user_id_to_update FROM comments WHERE id = NEW.votable_id;
    END IF;
    
    IF NEW.vote_value = 1 THEN
      score_change := 1; -- +1 for upvote
    ELSIF NEW.vote_value = -1 THEN
      score_change := -1; -- -1 for downvote
    END IF;
  ELSIF TG_TABLE_NAME = 'reports' AND TG_OP = 'UPDATE' THEN
    -- User being reported
    IF NEW.status = 'resolved' AND NEW.resolution_action IN ('removed', 'ban') THEN
      IF NEW.reported_type = 'confession' THEN
        SELECT author_id INTO user_id_to_update FROM confessions WHERE id = NEW.reported_id;
      ELSIF NEW.reported_type = 'comment' THEN
        SELECT author_id INTO user_id_to_update FROM comments WHERE id = NEW.reported_id;
      ELSIF NEW.reported_type = 'user' THEN
        user_id_to_update := NEW.reported_id;
      END IF;
      score_change := -10; -- -10 for valid report
    END IF;
  END IF;

  -- Update trust score if we have a user and score change
  IF user_id_to_update IS NOT NULL AND score_change != 0 THEN
    UPDATE users 
    SET trust_score = GREATEST(0, LEAST(100, trust_score + score_change))
    WHERE id = user_id_to_update;
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Apply trust score triggers
CREATE TRIGGER trust_score_confessions_trigger
  AFTER INSERT OR UPDATE ON confessions
  FOR EACH ROW EXECUTE FUNCTION update_user_trust_score();

CREATE TRIGGER trust_score_votes_trigger
  AFTER INSERT ON votes
  FOR EACH ROW EXECUTE FUNCTION update_user_trust_score();

CREATE TRIGGER trust_score_reports_trigger
  AFTER UPDATE ON reports
  FOR EACH ROW EXECUTE FUNCTION update_user_trust_score();

-- =================================================================
-- NOTIFICATION CREATION FUNCTIONS
-- =================================================================

-- Function to create notifications for various events
CREATE OR REPLACE FUNCTION create_notification(
  recipient_id UUID,
  notification_type VARCHAR(50),
  title VARCHAR(255),
  message TEXT,
  related_type VARCHAR(20) DEFAULT NULL,
  related_id UUID DEFAULT NULL,
  actor_id UUID DEFAULT NULL,
  data JSONB DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  notification_id UUID;
BEGIN
  -- Check if user wants notifications
  IF NOT EXISTS (
    SELECT 1 FROM users 
    WHERE id = recipient_id 
    AND receive_notifications = true
  ) THEN
    RETURN NULL;
  END IF;

  -- Insert notification
  INSERT INTO notifications (
    user_id, type, title, message, 
    related_type, related_id, actor_id, data
  ) VALUES (
    recipient_id, notification_type, title, message,
    related_type, related_id, actor_id, data
  ) RETURNING id INTO notification_id;

  RETURN notification_id;
END;
$$ LANGUAGE plpgsql;

-- Function to create notifications when comments are added
CREATE OR REPLACE FUNCTION notify_comment_added()
RETURNS TRIGGER AS $$
DECLARE
  confession_author_id UUID;
  confession_title VARCHAR(500);
  parent_comment_author_id UUID;
  commenter_name VARCHAR(50);
BEGIN
  -- Get confession details
  SELECT author_id, title INTO confession_author_id, confession_title
  FROM confessions 
  WHERE id = NEW.confession_id;

  -- Get commenter's display name (or anonymous)
  SELECT COALESCE(display_name, 'Someone') INTO commenter_name
  FROM users 
  WHERE id = NEW.author_id;

  -- Notify confession author if it's not their own comment
  IF confession_author_id IS NOT NULL AND confession_author_id != NEW.author_id THEN
    PERFORM create_notification(
      confession_author_id,
      'new_comment',
      'New comment on your confession',
      commenter_name || ' commented on your confession',
      'confession',
      NEW.confession_id,
      NEW.author_id,
      jsonb_build_object('comment_id', NEW.id)
    );
  END IF;

  -- If this is a reply to another comment, notify the parent comment author
  IF NEW.parent_id IS NOT NULL THEN
    SELECT author_id INTO parent_comment_author_id
    FROM comments 
    WHERE id = NEW.parent_id;

    IF parent_comment_author_id IS NOT NULL 
       AND parent_comment_author_id != NEW.author_id 
       AND parent_comment_author_id != confession_author_id THEN
      PERFORM create_notification(
        parent_comment_author_id,
        'comment_reply',
        'Someone replied to your comment',
        commenter_name || ' replied to your comment',
        'comment',
        NEW.parent_id,
        NEW.author_id,
        jsonb_build_object('comment_id', NEW.id, 'confession_id', NEW.confession_id)
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply comment notification trigger
CREATE TRIGGER comment_notification_trigger
  AFTER INSERT ON comments
  FOR EACH ROW EXECUTE FUNCTION notify_comment_added();

-- =================================================================
-- RATE LIMITING FUNCTIONS
-- =================================================================

-- Function to check rate limits for posting
CREATE OR REPLACE FUNCTION check_rate_limit()
RETURNS TRIGGER AS $$
DECLARE
  post_count INTEGER;
  community_limit INTEGER;
BEGIN
  -- Get community's daily post limit
  SELECT max_posts_per_day INTO community_limit
  FROM communities 
  WHERE id = NEW.community_id;

  -- Count user's posts in this community today
  SELECT COUNT(*) INTO post_count
  FROM confessions
  WHERE author_id = NEW.author_id
    AND community_id = NEW.community_id
    AND created_at >= CURRENT_DATE
    AND status = 'active';

  -- Check if limit exceeded
  IF post_count >= community_limit THEN
    RAISE EXCEPTION 'Daily post limit exceeded for this community. Limit: %', community_limit;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply rate limiting trigger
CREATE TRIGGER rate_limit_trigger
  BEFORE INSERT ON confessions
  FOR EACH ROW EXECUTE FUNCTION check_rate_limit();

-- =================================================================
-- DATA CLEANUP FUNCTIONS
-- =================================================================

-- Function to clean up old data
CREATE OR REPLACE FUNCTION cleanup_old_data()
RETURNS void AS $$
BEGIN
  -- Delete old inactive sessions (older than 90 days)
  DELETE FROM user_sessions 
  WHERE is_active = false 
    AND last_activity_at < NOW() - INTERVAL '90 days';

  -- Delete old notifications (older than 1 year)
  DELETE FROM notifications 
  WHERE created_at < NOW() - INTERVAL '1 year';

  -- Delete old reports that are resolved (older than 6 months)
  DELETE FROM reports 
  WHERE status = 'resolved' 
    AND resolved_at < NOW() - INTERVAL '6 months';

  -- Anonymize old deleted confessions (older than 30 days)
  UPDATE confessions 
  SET 
    content = '[This confession was deleted]',
    title = NULL,
    author_id = NULL,
    anonymous_author_id = NULL
  WHERE status = 'removed' 
    AND updated_at < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- =================================================================
-- SECURITY FUNCTIONS
-- =================================================================

-- Function to detect and prevent spam
CREATE OR REPLACE FUNCTION detect_spam()
RETURNS TRIGGER AS $$
DECLARE
  duplicate_count INTEGER;
  recent_post_count INTEGER;
BEGIN
  -- Check for duplicate content
  SELECT COUNT(*) INTO duplicate_count
  FROM confessions
  WHERE content_hash = NEW.content_hash
    AND author_id = NEW.author_id
    AND created_at > NOW() - INTERVAL '1 hour';

  IF duplicate_count > 0 THEN
    RAISE EXCEPTION 'Duplicate content detected';
  END IF;

  -- Check for rapid posting (more than 5 posts in 5 minutes)
  SELECT COUNT(*) INTO recent_post_count
  FROM confessions
  WHERE author_id = NEW.author_id
    AND created_at > NOW() - INTERVAL '5 minutes';

  IF recent_post_count >= 5 THEN
    RAISE EXCEPTION 'Too many posts in short time. Please wait before posting again.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply spam detection trigger
CREATE TRIGGER spam_detection_trigger
  BEFORE INSERT ON confessions
  FOR EACH ROW EXECUTE FUNCTION detect_spam();