-- =================================================================
-- INITIAL DATA SEEDING
-- Sample institutions, communities, and reference data
-- =================================================================

-- =================================================================
-- SAMPLE INSTITUTIONS
-- =================================================================

-- Major Indian Engineering Colleges
INSERT INTO institutions (id, name, type, location, domain, is_verified, logo_url) VALUES
  (uuid_generate_v4(), 'Indian Institute of Technology Bombay', 'college', 'Mumbai, Maharashtra', 'iitb.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Technology Delhi', 'college', 'New Delhi', 'iitd.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Technology Kanpur', 'college', 'Kanpur, Uttar Pradesh', 'iitk.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Technology Madras', 'college', 'Chennai, Tamil Nadu', 'iitm.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Technology Kharagpur', 'college', 'Kharagpur, West Bengal', 'iitkgp.ac.in', true, NULL),
  (uuid_generate_v4(), 'National Institute of Technology Trichy', 'college', 'Tiruchirappalli, Tamil Nadu', 'nitt.edu', true, NULL),
  (uuid_generate_v4(), 'Birla Institute of Technology and Science Pilani', 'college', 'Pilani, Rajasthan', 'pilani.bits-pilani.ac.in', true, NULL),
  (uuid_generate_v4(), 'Vellore Institute of Technology', 'college', 'Vellore, Tamil Nadu', 'vit.ac.in', true, NULL),
  (uuid_generate_v4(), 'Manipal Institute of Technology', 'college', 'Manipal, Karnataka', 'manipal.edu', true, NULL),
  (uuid_generate_v4(), 'Delhi Technological University', 'college', 'New Delhi', 'dtu.ac.in', true, NULL);

-- Medical Colleges
INSERT INTO institutions (id, name, type, location, domain, is_verified, logo_url) VALUES
  (uuid_generate_v4(), 'All India Institute of Medical Sciences Delhi', 'college', 'New Delhi', 'aiims.edu', true, NULL),
  (uuid_generate_v4(), 'Christian Medical College Vellore', 'college', 'Vellore, Tamil Nadu', 'cmcvellore.ac.in', true, NULL),
  (uuid_generate_v4(), 'Armed Forces Medical College', 'college', 'Pune, Maharashtra', 'afmc.nic.in', true, NULL),
  (uuid_generate_v4(), 'Maulana Azad Medical College', 'college', 'New Delhi', 'mamc.ac.in', true, NULL);

-- Business Schools
INSERT INTO institutions (id, name, type, location, domain, is_verified, logo_url) VALUES
  (uuid_generate_v4(), 'Indian Institute of Management Ahmedabad', 'college', 'Ahmedabad, Gujarat', 'iima.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Management Bangalore', 'college', 'Bangalore, Karnataka', 'iimb.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian Institute of Management Calcutta', 'college', 'Kolkata, West Bengal', 'iimcal.ac.in', true, NULL),
  (uuid_generate_v4(), 'Indian School of Business', 'college', 'Hyderabad, Telangana', 'isb.edu', true, NULL);

-- Schools (Sample)
INSERT INTO institutions (id, name, type, location, domain, is_verified, logo_url) VALUES
  (uuid_generate_v4(), 'Delhi Public School R.K. Puram', 'school', 'New Delhi', 'dpsrkp.net', true, NULL),
  (uuid_generate_v4(), 'La Martiniere Calcutta', 'school', 'Kolkata, West Bengal', 'lamartiniere.net', true, NULL),
  (uuid_generate_v4(), 'The Doon School', 'school', 'Dehradun, Uttarakhand', 'doonschool.com', true, NULL),
  (uuid_generate_v4(), 'Mayo College', 'school', 'Ajmer, Rajasthan', 'mayocollege.com', true, NULL);

-- Coaching Centers
INSERT INTO institutions (id, name, type, location, domain, is_verified, logo_url) VALUES
  (uuid_generate_v4(), 'FIITJEE', 'coaching', 'New Delhi', 'fiitjee.com', true, NULL),
  (uuid_generate_v4(), 'Allen Career Institute', 'coaching', 'Kota, Rajasthan', 'allen.ac.in', true, NULL),
  (uuid_generate_v4(), 'Aakash Institute', 'coaching', 'New Delhi', 'aakash.ac.in', true, NULL),
  (uuid_generate_v4(), 'Resonance', 'coaching', 'Kota, Rajasthan', 'resonance.ac.in', true, NULL);

-- =================================================================
-- DEFAULT COMMUNITIES
-- =================================================================

-- Get some institution IDs for reference
DO $$
DECLARE
  iit_bombay_id UUID;
  iit_delhi_id UUID;
  aiims_delhi_id UUID;
  iim_ahmedabad_id UUID;
  dps_rkp_id UUID;
  fiitjee_id UUID;
BEGIN
  -- Get institution IDs
  SELECT id INTO iit_bombay_id FROM institutions WHERE name = 'Indian Institute of Technology Bombay';
  SELECT id INTO iit_delhi_id FROM institutions WHERE name = 'Indian Institute of Technology Delhi';
  SELECT id INTO aiims_delhi_id FROM institutions WHERE name = 'All India Institute of Medical Sciences Delhi';
  SELECT id INTO iim_ahmedabad_id FROM institutions WHERE name = 'Indian Institute of Management Ahmedabad';
  SELECT id INTO dps_rkp_id FROM institutions WHERE name = 'Delhi Public School R.K. Puram';
  SELECT id INTO fiitjee_id FROM institutions WHERE name = 'FIITJEE';

  -- General/Open Communities
  INSERT INTO communities (id, name, description, type, tags, rules) VALUES
    (uuid_generate_v4(), 'General Confessions', 'Share your thoughts anonymously with everyone', 'open', ARRAY['general', 'anonymous', 'confessions'], 'Be respectful and kind to others. No personal attacks or hate speech.'),
    (uuid_generate_v4(), 'Relationship Advice', 'Get advice on dating, relationships, and social interactions', 'open', ARRAY['relationships', 'dating', 'advice'], 'No identifying information about people. Keep discussions constructive.'),
    (uuid_generate_v4(), 'Academic Stress', 'Share your academic struggles and get support', 'open', ARRAY['academics', 'stress', 'support'], 'Focus on constructive support. No encouraging harmful behavior.'),
    (uuid_generate_v4(), 'Career Guidance', 'Discuss career choices, job hunting, and professional life', 'open', ARRAY['career', 'jobs', 'professional'], 'Share experiences respectfully. No spam or promotional content.'),
    (uuid_generate_v4(), 'Mental Health Support', 'A safe space to discuss mental health and wellness', 'open', ARRAY['mental-health', 'wellness', 'support'], 'Be supportive and empathetic. Crisis situations should contact professionals.'),
    (uuid_generate_v4(), 'Exam Prep', 'Share study tips, exam strategies, and motivation', 'open', ARRAY['exams', 'study', 'preparation'], 'Share helpful content only. No cheating or unethical practices.'),
    (uuid_generate_v4(), 'Campus Life', 'Stories and experiences from college and school life', 'open', ARRAY['campus', 'college', 'experiences'], 'Respect privacy. No identifying specific people or institutions inappropriately.');

  -- Institution-Specific Communities (IIT Bombay)
  IF iit_bombay_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'IIT Bombay General', 'General discussions for IIT Bombay students', 'institution', iit_bombay_id, ARRAY['iitb', 'general'], 'Verified IIT Bombay students only'),
      (uuid_generate_v4(), 'IITB Computer Science', 'CSE department discussions', 'institution', iit_bombay_id, ARRAY['iitb', 'cse', 'computer-science'], 'CSE students and faculty only'),
      (uuid_generate_v4(), 'IITB Mechanical Engineering', 'Mechanical department discussions', 'institution', iit_bombay_id, ARRAY['iitb', 'mechanical'], 'Mechanical engineering students only'),
      (uuid_generate_v4(), 'IITB Hostel Life', 'Share hostel experiences and stories', 'institution', iit_bombay_id, ARRAY['iitb', 'hostel', 'campus-life'], 'Current and former IIT Bombay students');
  END IF;

  -- Institution-Specific Communities (IIT Delhi)
  IF iit_delhi_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'IIT Delhi General', 'General discussions for IIT Delhi students', 'institution', iit_delhi_id, ARRAY['iitd', 'general'], 'Verified IIT Delhi students only'),
      (uuid_generate_v4(), 'IITD Electrical Engineering', 'EE department discussions', 'institution', iit_delhi_id, ARRAY['iitd', 'electrical'], 'EE students and faculty only');
  END IF;

  -- Medical College Communities
  IF aiims_delhi_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'AIIMS Delhi General', 'General discussions for AIIMS Delhi', 'institution', aiims_delhi_id, ARRAY['aiims', 'medical'], 'Verified AIIMS students and staff only'),
      (uuid_generate_v4(), 'Medical Studies Support', 'Academic support for medical students', 'institution', aiims_delhi_id, ARRAY['aiims', 'academics', 'medicine'], 'Medical students only');
  END IF;

  -- Business School Communities
  IF iim_ahmedabad_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'IIM Ahmedabad General', 'General discussions for IIM-A students', 'institution', iim_ahmedabad_id, ARRAY['iima', 'mba'], 'Verified IIM-A students only'),
      (uuid_generate_v4(), 'MBA Life at IIM-A', 'Share MBA experiences and insights', 'institution', iim_ahmedabad_id, ARRAY['iima', 'mba', 'experiences'], 'Current and former IIM-A students');
  END IF;

  -- School Communities
  IF dps_rkp_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'DPS RKP General', 'General discussions for DPS RKP students', 'institution', dps_rkp_id, ARRAY['dps', 'school'], 'Current and former DPS RKP students'),
      (uuid_generate_v4(), 'Class 12 Board Prep', 'Board exam preparation and support', 'institution', dps_rkp_id, ARRAY['dps', 'boards', 'class12'], 'Class 12 students only');
  END IF;

  -- Coaching Communities
  IF fiitjee_id IS NOT NULL THEN
    INSERT INTO communities (id, name, description, type, institution_id, tags, rules) VALUES
      (uuid_generate_v4(), 'FIITJEE General', 'General discussions for FIITJEE students', 'institution', fiitjee_id, ARRAY['fiitjee', 'coaching'], 'Current FIITJEE students only'),
      (uuid_generate_v4(), 'JEE Preparation Tips', 'Share JEE prep strategies and tips', 'institution', fiitjee_id, ARRAY['fiitjee', 'jee', 'preparation'], 'JEE aspirants only');
  END IF;

END $$;

-- =================================================================
-- SAMPLE CONFESSION TYPES & TAGS
-- =================================================================

-- This would typically be handled by the application, but we can create
-- a reference table for common tags if needed

CREATE TABLE IF NOT EXISTS confession_tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(50) UNIQUE NOT NULL,
  category VARCHAR(30) NOT NULL,
  description TEXT,
  color VARCHAR(7), -- Hex color code
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Popular confession tags
INSERT INTO confession_tags (name, category, description, color) VALUES
  ('academic-stress', 'academics', 'Academic pressure and study-related stress', '#FF6B6B'),
  ('relationships', 'personal', 'Dating, friendships, and relationship issues', '#FF8E53'),
  ('family', 'personal', 'Family-related confessions and issues', '#FF6B9D'),
  ('mental-health', 'health', 'Mental health struggles and support', '#4ECDC4'),
  ('career-confusion', 'career', 'Career choices and professional uncertainty', '#45B7D1'),
  ('social-anxiety', 'social', 'Social situations and anxiety', '#96CEB4'),
  ('financial-stress', 'personal', 'Money-related worries and stress', '#FFEAA7'),
  ('imposter-syndrome', 'academics', 'Feeling inadequate despite achievements', '#DDA0DD'),
  ('hostel-life', 'campus', 'Hostel and campus living experiences', '#98D8C8'),
  ('exam-anxiety', 'academics', 'Exam-related stress and anxiety', '#F7DC6F'),
  ('future-uncertainty', 'career', 'Uncertainty about future plans', '#AED6F1'),
  ('peer-pressure', 'social', 'Pressure from friends and peers', '#F8C471'),
  ('loneliness', 'personal', 'Feeling isolated or alone', '#E8DAEF'),
  ('study-burnout', 'academics', 'Exhaustion from excessive studying', '#FADBD8'),
  ('parent-expectations', 'family', 'Pressure from parental expectations', '#D5DBDB');

-- =================================================================
-- SYSTEM CONFIGURATION
-- =================================================================

-- Create a system configuration table for app settings
CREATE TABLE IF NOT EXISTS app_config (
  key VARCHAR(100) PRIMARY KEY,
  value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Initial app configuration
INSERT INTO app_config (key, value, description) VALUES
  ('max_confession_length', '2000', 'Maximum character limit for confession content'),
  ('max_comment_length', '500', 'Maximum character limit for comments'),
  ('max_title_length', '200', 'Maximum character limit for confession titles'),
  ('daily_post_limit_default', '10', 'Default daily post limit for communities'),
  ('vote_weight_multiplier', '1.0', 'Multiplier for vote weight calculations'),
  ('trust_score_thresholds', '{"new_user": 50, "trusted": 70, "moderator": 80}', 'Trust score thresholds for various privileges'),
  ('content_moderation_enabled', 'true', 'Whether automatic content moderation is enabled'),
  ('notification_batch_size', '50', 'Number of notifications to process in each batch'),
  ('session_timeout_days', '30', 'Number of days before user sessions expire'),
  ('rate_limit_window_minutes', '5', 'Time window for rate limiting (in minutes)'),
  ('rate_limit_max_posts', '5', 'Maximum posts allowed in rate limit window'),
  ('min_trust_score_to_vote', '10', 'Minimum trust score required to vote'),
  ('min_trust_score_to_post', '20', 'Minimum trust score required to post'),
  ('auto_moderation_keywords', '[]', 'Keywords that trigger automatic moderation'),
  ('supported_image_formats', '["jpg", "jpeg", "png", "gif", "webp"]', 'Supported image file formats'),
  ('max_image_size_mb', '5', 'Maximum image size in megabytes');

-- =================================================================
-- SAMPLE MODERATOR ACCOUNTS
-- =================================================================

-- Note: These would be created through the application's signup process
-- This is just for reference of what moderator accounts might look like

-- We'll create this through the application later, but the structure would be:
-- 1. System admin account
-- 2. Community moderators for each major community
-- 3. Institution moderators for verified institutions

COMMIT;

-- =================================================================
-- POST-SETUP VERIFICATION QUERIES
-- =================================================================

-- These queries can be run to verify the setup

-- Count institutions by type
-- SELECT type, COUNT(*) as count FROM institutions GROUP BY type;

-- Count communities by type
-- SELECT type, COUNT(*) as count FROM communities GROUP BY type;

-- List all available tags
-- SELECT name, category, description FROM confession_tags ORDER BY category, name;

-- Check app configuration
-- SELECT key, value, description FROM app_config ORDER BY key;