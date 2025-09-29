import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState, AuthException;
import '../core/config/supabase_config.dart';

/// Comprehensive authentication service with anonymous and verified options
class AuthService {
  final SupabaseClient _supabase = SupabaseConfig.client;
  
  // Stream controllers for auth state
  final _authStateController = StreamController<AuthState>.broadcast();
  AuthState _currentState = const AuthState();
  
  /// Stream of authentication state changes
  Stream<AuthState> get authStateStream => _authStateController.stream;
  
  /// Current authentication state
  AuthState get currentState => _currentState;
  
  AuthService() {
    _initialize();
  }
  
  void _initialize() {
    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      _handleAuthStateChange(data.event, data.session);
    });
    
    // Check initial auth state
    _checkInitialAuthState();
  }
  
  Future<void> _checkInitialAuthState() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session?.user != null) {
        await _loadUserProfile(session!.user);
      }
    } catch (e) {
      _updateState(_currentState.copyWith(error: e.toString()));
    }
  }
  
  void _handleAuthStateChange(AuthChangeEvent event, Session? session) {
    switch (event) {
      case AuthChangeEvent.signedIn:
        if (session?.user != null) {
          _loadUserProfile(session!.user);
        }
        break;
      case AuthChangeEvent.signedOut:
        _updateState(const AuthState());
        break;
      case AuthChangeEvent.userUpdated:
        if (session?.user != null) {
          _loadUserProfile(session!.user);
        }
        break;
      default:
        break;
    }
  }
  
  Future<void> _loadUserProfile(User user) async {
    try {
      _updateState(_currentState.copyWith(isLoading: true));
      
      // Get user profile from database
      final profile = await _supabase
          .from('users')
          .select('email_verified, institution_verified')
          .eq('id', user.id)
          .maybeSingle();
      
      final isEmailVerified = profile?['email_verified'] ?? false;
      final isInstitutionVerified = profile?['institution_verified'] ?? false;
      final isAnonymous = user.email == null || user.email!.isEmpty;
      
      _updateState(AuthState(
        user: user,
        isLoading: false,
        isAnonymous: isAnonymous,
        isEmailVerified: isEmailVerified,
        isInstitutionVerified: isInstitutionVerified,
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        user: user,
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
  
  void _updateState(AuthState newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }
  
  /// Sign in anonymously for privacy-focused posting
  Future<User> signInAnonymously() async {
    try {
      _updateState(_currentState.copyWith(isLoading: true));
      
      final response = await _supabase.auth.signInAnonymously();
      
      if (response.user == null) {
        throw const AuthException('Failed to sign in anonymously');
      }
      
      // Create user profile with anonymous settings
      await _createUserProfile(response.user!, isAnonymous: true);
      
      return response.user!;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Anonymous sign-in failed: ${e.toString()}');
    }
  }
  
  /// Sign up with email for institution verification
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _updateState(_currentState.copyWith(isLoading: true));
      
      // Validate email domain against institutions
      await _validateInstitutionEmail(email);
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      
      if (response.user == null) {
        throw const AuthException('Failed to create account');
      }
      
      // Create user profile
      await _createUserProfile(
        response.user!,
        email: email,
        displayName: displayName,
      );
      
      return response.user!;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Sign up failed: ${e.toString()}');
    }
  }
  
  /// Sign in with email
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _updateState(_currentState.copyWith(isLoading: true));
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw const AuthException('Invalid email or password');
      }
      
      return response.user!;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }
  
  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }
  
  /// Request password reset
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }
  
  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    bool? showInstitution,
    bool? allowAnonymousPosts,
    bool? receiveNotifications,
  }) async {
    try {
      final userId = SupabaseConfig.userId;
      if (userId == null) {
        throw const AuthException('User not authenticated');
      }
      
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (showInstitution != null) updates['show_institution'] = showInstitution;
      if (allowAnonymousPosts != null) updates['allow_anonymous_posts'] = allowAnonymousPosts;
      if (receiveNotifications != null) updates['receive_notifications'] = receiveNotifications;
      
      if (updates.isNotEmpty) {
        updates['updated_at'] = DateTime.now().toIso8601String();
        
        await _supabase
            .from('users')
            .update(updates)
            .eq('id', userId);
        
        // Reload user profile
        final user = SupabaseConfig.currentUser;
        if (user != null) {
          await _loadUserProfile(user);
        }
      }
    } catch (e) {
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }
  
  /// Verify institution email
  Future<bool> verifyInstitutionEmail() async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user?.email == null) {
        throw const AuthException('No email to verify');
      }
      
      final domain = user!.email!.split('@').last.toLowerCase();
      
      // Check if domain matches verified institution
      final institution = await _supabase
          .from('institutions')
          .select('id')
          .eq('domain', domain)
          .eq('is_verified', true)
          .maybeSingle();
      
      if (institution != null) {
        // Update user as institution verified
        await _supabase
            .from('users')
            .update({
              'institution_id': institution['id'],
              'institution_verified': true,
              'verification_status': 'verified',
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', user.id);
        
        // Reload profile
        await _loadUserProfile(user);
        return true;
      }
      
      return false;
    } catch (e) {
      throw AuthException('Institution verification failed: ${e.toString()}');
    }
  }
  
  /// Get available institutions
  Future<List<Map<String, dynamic>>> getInstitutions({
    String? type,
    String? search,
  }) async {
    try {
      var query = _supabase
          .from('institutions')
          .select('id, name, type, location, domain')
          .eq('is_verified', true);
      
      if (type != null) {
        query = query.eq('type', type);
      }
      
      if (search != null && search.isNotEmpty) {
        query = query.ilike('name', '%$search%');
      }
      
      final result = await query.order('name');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      throw NetworkException('Failed to load institutions: ${e.toString()}');
    }
  }
  
  /// Create user profile in database
  Future<void> _createUserProfile(
    User user, {
    String? email,
    String? displayName,
    bool isAnonymous = false,
  }) async {
    try {
      String? institutionId;
      bool institutionVerified = false;
      
      // Check institution if email provided
      if (email != null && !isAnonymous) {
        final domain = email.split('@').last.toLowerCase();
        final institution = await _supabase
            .from('institutions')
            .select('id')
            .eq('domain', domain)
            .eq('is_verified', true)
            .maybeSingle();
        
        if (institution != null) {
          institutionId = institution['id'];
          institutionVerified = true;
        }
      }
      
      await _supabase.from('users').insert({
        'id': user.id,
        'display_name': displayName,
        'institution_id': institutionId,
        'email_verified': !isAnonymous,
        'institution_verified': institutionVerified,
        'verification_status': institutionVerified ? 'verified' : 'unverified',
        'allow_anonymous_posts': true,
        'receive_notifications': true,
        'trust_score': 50, // Starting trust score
      });
    } catch (e) {
      // Ignore if user already exists
      if (!e.toString().contains('duplicate key')) {
        rethrow;
      }
    }
  }
  
  /// Validate email domain against institutions
  Future<void> _validateInstitutionEmail(String email) async {
    final domain = email.split('@').last.toLowerCase();
    
    // Check if domain exists in institutions
    final institution = await _supabase
        .from('institutions')
        .select('id, name')
        .eq('domain', domain)
        .eq('is_verified', true)
        .maybeSingle();
    
    if (institution == null) {
      throw AuthException(
        'Email domain not recognized. Please use your institutional email or sign in anonymously.',
      );
    }
  }
  
  /// Clean up resources
  void dispose() {
    _authStateController.close();
  }
}