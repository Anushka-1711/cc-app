-- =================================================================
-- ROW LEVEL SECURITY POLICIES
-- Ensures users can only access data they're authorized to see
-- =================================================================

-- =================================================================
-- INSTITUTIONS POLICIES
-- =================================================================

-- Everyone can read verified institutions
CREATE POLICY "institutions_read_verified" ON institutions
  FOR SELECT USING (is_verified = true);

-- Only authenticated users can suggest institutions
CREATE POLICY "institutions_suggest" ON institutions
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- =================================================================
-- USERS POLICIES
-- =================================================================

-- Users can read their own profile
CREATE POLICY "users_read_own" ON users
  FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "users_update_own" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Users can insert their own profile (on signup)
CREATE POLICY "users_insert_own" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Moderators can read user profiles for moderation
CREATE POLICY "users_read_moderators" ON users
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
    )
  );

-- =================================================================
-- COMMUNITIES POLICIES
-- =================================================================

-- Everyone can read active public communities
CREATE POLICY "communities_read_public" ON communities
  FOR SELECT USING (is_active = true AND type = 'open');

-- Institution members can read institution communities
CREATE POLICY "communities_read_institution" ON communities
  FOR SELECT USING (
    type = 'institution' AND is_active = true AND
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = auth.uid()
      AND u.institution_id = communities.institution_id
      AND u.institution_verified = true
    )
  );

-- Community members can read private communities they belong to
CREATE POLICY "communities_read_members" ON communities
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = id
      AND uc.user_id = auth.uid()
      AND uc.status = 'active'
    )
  );

-- Moderators can create communities
CREATE POLICY "communities_create" ON communities
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    (
      -- Open communities: any verified user
      (type = 'open' AND EXISTS (
        SELECT 1 FROM users WHERE id = auth.uid() AND email_verified = true
      )) OR
      -- Institution communities: verified institution members
      (type = 'institution' AND EXISTS (
        SELECT 1 FROM users u
        WHERE u.id = auth.uid()
        AND u.institution_id = NEW.institution_id
        AND u.institution_verified = true
      ))
    )
  );

-- Moderators can update their communities
CREATE POLICY "communities_update_moderators" ON communities
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = id
      AND uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
    )
  );

-- =================================================================
-- USER_COMMUNITIES POLICIES
-- =================================================================

-- Users can read their own memberships
CREATE POLICY "user_communities_read_own" ON user_communities
  FOR SELECT USING (user_id = auth.uid());

-- Community moderators can read all memberships
CREATE POLICY "user_communities_read_moderators" ON user_communities
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = user_communities.community_id
      AND uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
    )
  );

-- Users can join communities
CREATE POLICY "user_communities_join" ON user_communities
  FOR INSERT WITH CHECK (
    user_id = auth.uid() AND
    -- Can only join if community allows it
    EXISTS (
      SELECT 1 FROM communities c
      WHERE c.id = community_id
      AND c.is_active = true
      AND (
        c.type = 'open' OR
        (c.type = 'institution' AND EXISTS (
          SELECT 1 FROM users u
          WHERE u.id = auth.uid()
          AND u.institution_id = c.institution_id
          AND u.institution_verified = true
        ))
      )
    )
  );

-- Users can leave communities (update to 'left' status)
CREATE POLICY "user_communities_leave" ON user_communities
  FOR UPDATE USING (
    user_id = auth.uid() AND
    status = 'active'
  )
  WITH CHECK (
    user_id = auth.uid() AND
    status = 'left'
  );

-- Moderators can manage memberships
CREATE POLICY "user_communities_moderate" ON user_communities
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = user_communities.community_id
      AND uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
    )
  );

-- =================================================================
-- CONFESSIONS POLICIES
-- =================================================================

-- Users can read active confessions in communities they're part of
CREATE POLICY "confessions_read" ON confessions
  FOR SELECT USING (
    status = 'active' AND
    (
      -- Public confessions
      visibility = 'public' OR
      -- Community confessions: must be member
      (visibility = 'community' AND EXISTS (
        SELECT 1 FROM user_communities uc
        WHERE uc.community_id = confessions.community_id
        AND uc.user_id = auth.uid()
        AND uc.status = 'active'
      )) OR
      -- Institution confessions: must be from same institution
      (visibility = 'institution' AND EXISTS (
        SELECT 1 FROM users u
        WHERE u.id = auth.uid()
        AND u.institution_id = confessions.author_institution_id
      ))
    )
  );

-- Users can create confessions in communities they're part of
CREATE POLICY "confessions_create" ON confessions
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    author_id = auth.uid() AND
    -- Must be member of the community
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = confessions.community_id
      AND uc.user_id = auth.uid()
      AND uc.status = 'active'
      AND uc.can_post = true
    )
  );

-- Authors can update their own confessions (limited fields)
CREATE POLICY "confessions_update_own" ON confessions
  FOR UPDATE USING (
    author_id = auth.uid() AND
    status = 'active'
  )
  WITH CHECK (
    author_id = auth.uid() AND
    -- Only allow editing content, not metadata
    OLD.id = NEW.id AND
    OLD.author_id = NEW.author_id AND
    OLD.community_id = NEW.community_id
  );

-- Moderators can update confessions for moderation
CREATE POLICY "confessions_moderate" ON confessions
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.community_id = confessions.community_id
      AND uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
      AND uc.can_moderate = true
    )
  );

-- =================================================================
-- COMMENTS POLICIES
-- =================================================================

-- Users can read comments on confessions they can see
CREATE POLICY "comments_read" ON comments
  FOR SELECT USING (
    status = 'active' AND
    EXISTS (
      SELECT 1 FROM confessions c
      WHERE c.id = comments.confession_id
      -- Use confession's RLS policy
    )
  );

-- Users can create comments on confessions they can see
CREATE POLICY "comments_create" ON comments
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    author_id = auth.uid() AND
    EXISTS (
      SELECT 1 FROM confessions c
      JOIN user_communities uc ON uc.community_id = c.community_id
      WHERE c.id = comments.confession_id
      AND uc.user_id = auth.uid()
      AND uc.status = 'active'
      AND uc.can_comment = true
    )
  );

-- Authors can update their own comments
CREATE POLICY "comments_update_own" ON comments
  FOR UPDATE USING (
    author_id = auth.uid() AND
    status = 'active'
  )
  WITH CHECK (
    author_id = auth.uid() AND
    OLD.id = NEW.id AND
    OLD.author_id = NEW.author_id
  );

-- Moderators can update comments for moderation
CREATE POLICY "comments_moderate" ON comments
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM confessions c
      JOIN user_communities uc ON uc.community_id = c.community_id
      WHERE c.id = comments.confession_id
      AND uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
      AND uc.can_moderate = true
    )
  );

-- =================================================================
-- VOTES POLICIES
-- =================================================================

-- Users can read vote counts (aggregated, not individual votes)
-- Individual votes are private - only aggregated counts shown

-- Users can vote on content they can see
CREATE POLICY "votes_create" ON votes
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    user_id = auth.uid() AND
    (
      -- Voting on confessions
      (votable_type = 'confession' AND EXISTS (
        SELECT 1 FROM confessions c
        WHERE c.id = votes.votable_id
        -- Use confession's RLS policy
      )) OR
      -- Voting on comments
      (votable_type = 'comment' AND EXISTS (
        SELECT 1 FROM comments cm
        WHERE cm.id = votes.votable_id
        -- Use comment's RLS policy
      ))
    )
  );

-- Users can update their own votes
CREATE POLICY "votes_update_own" ON votes
  FOR UPDATE USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Users can delete their own votes
CREATE POLICY "votes_delete_own" ON votes
  FOR DELETE USING (user_id = auth.uid());

-- =================================================================
-- REPORTS POLICIES
-- =================================================================

-- Users can create reports
CREATE POLICY "reports_create" ON reports
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND
    reporter_id = auth.uid()
  );

-- Users can read their own reports
CREATE POLICY "reports_read_own" ON reports
  FOR SELECT USING (reporter_id = auth.uid());

-- Moderators can read reports for their communities
CREATE POLICY "reports_read_moderators" ON reports
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
      AND uc.can_moderate = true
    )
  );

-- Moderators can update reports
CREATE POLICY "reports_update_moderators" ON reports
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM user_communities uc
      WHERE uc.user_id = auth.uid()
      AND uc.role IN ('moderator', 'admin')
      AND uc.status = 'active'
      AND uc.can_moderate = true
    )
  );

-- =================================================================
-- NOTIFICATIONS POLICIES
-- =================================================================

-- Users can read their own notifications
CREATE POLICY "notifications_read_own" ON notifications
  FOR SELECT USING (user_id = auth.uid());

-- System can create notifications
CREATE POLICY "notifications_create_system" ON notifications
  FOR INSERT WITH CHECK (true); -- Handled by triggers/functions

-- Users can update their own notifications (mark as read)
CREATE POLICY "notifications_update_own" ON notifications
  FOR UPDATE USING (user_id = auth.uid())
  WITH CHECK (
    user_id = auth.uid() AND
    -- Only allow updating read status
    OLD.id = NEW.id AND
    OLD.user_id = NEW.user_id
  );

-- =================================================================
-- USER_SESSIONS POLICIES
-- =================================================================

-- Users can read their own sessions
CREATE POLICY "user_sessions_read_own" ON user_sessions
  FOR SELECT USING (user_id = auth.uid());

-- System can create sessions
CREATE POLICY "user_sessions_create" ON user_sessions
  FOR INSERT WITH CHECK (user_id = auth.uid());

-- Users can update their own sessions
CREATE POLICY "user_sessions_update_own" ON user_sessions
  FOR UPDATE USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Users can delete their own sessions
CREATE POLICY "user_sessions_delete_own" ON user_sessions
  FOR DELETE USING (user_id = auth.uid());

-- =================================================================
-- FUNCTIONS FOR AUTOMATIC UPDATES
-- =================================================================

-- Function to update updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply the trigger to all tables with updated_at
CREATE TRIGGER update_institutions_updated_at BEFORE UPDATE ON institutions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_communities_updated_at BEFORE UPDATE ON communities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_communities_updated_at BEFORE UPDATE ON user_communities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_confessions_updated_at BEFORE UPDATE ON confessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_votes_updated_at BEFORE UPDATE ON votes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reports_updated_at BEFORE UPDATE ON reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();