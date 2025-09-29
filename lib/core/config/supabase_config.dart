import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Supabase configuration and client management
class SupabaseConfig {
  // Replace these with your actual Supabase project credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Storage bucket names
  static const String avatarsBucket = 'avatars';
  static const String mediaBucket = 'confession-media';
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode,
    );
  }
  
  /// Get the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Get the current authenticated user
  static User? get currentUser => client.auth.currentUser;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
  
  /// Get user ID safely
  static String? get userId => currentUser?.id;
  
  /// Get user email safely
  static String? get userEmail => currentUser?.email;
}

/// Authentication state management
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAnonymous;
  final bool isEmailVerified;
  final bool isInstitutionVerified;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAnonymous = true,
    this.isEmailVerified = false,
    this.isInstitutionVerified = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAnonymous,
    bool? isEmailVerified,
    bool? isInstitutionVerified,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isInstitutionVerified: isInstitutionVerified ?? this.isInstitutionVerified,
    );
  }
}

/// Custom exceptions for better error handling
class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException(this.message, {this.code});
  
  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}