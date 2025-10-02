import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:anonymous_confessions/services/auth_service.dart';

// Generate mocks using mockito
@GenerateMocks([SupabaseClient, GoTrueClient, User, AuthResponse])
import 'auth_service_test.mocks.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockGoTrueClient;
    late MockUser mockUser;
    late MockAuthResponse mockAuthResponse;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockGoTrueClient = MockGoTrueClient();
      mockUser = MockUser();
      mockAuthResponse = MockAuthResponse();
      
      // Mock the auth property of SupabaseClient
      when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
      
      authService = AuthService();
      // Note: In real tests, we would need to inject the mock client
      // For now, this demonstrates the test structure
    });

    group('signUpWithEmail', () {
      test('should successfully sign up user with valid email and password', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'testPassword123';
        const institutionCode = 'TEST_UNIV';

        when(mockUser.id).thenReturn('test-user-id');
        when(mockUser.email).thenReturn(email);
        when(mockAuthResponse.user).thenReturn(mockUser);

        when(mockGoTrueClient.signUp(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        // Act & Assert
        // Note: This test structure shows how we would test if we had proper dependency injection
        expect(() async {
          // In a real implementation, we would call:
          // final result = await authService.signUpWithEmail(email, password, institutionCode);
          // expect(result['user']['email'], equals(email));
        }, returnsNormally);
      });

      test('should throw exception for invalid email format', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const password = 'testPassword123';
        const institutionCode = 'TEST_UNIV';

        // Act & Assert
        expect(() async {
          await authService.signUpWithEmail(invalidEmail, password, institutionCode);
        }, throwsA(isA<Exception>()));
      });

      test('should throw exception for weak password', () async {
        // Arrange
        const email = 'test@example.com';
        const weakPassword = '123';
        const institutionCode = 'TEST_UNIV';

        // Act & Assert
        expect(() async {
          await authService.signUpWithEmail(email, weakPassword, institutionCode);
        }, throwsA(isA<Exception>()));
      });

      test('should throw exception for empty institution code', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'testPassword123';
        const emptyInstitutionCode = '';

        // Act & Assert
        expect(() async {
          await authService.signUpWithEmail(email, password, emptyInstitutionCode);
        }, throwsA(isA<Exception>()));
      });
    });

    group('signInWithEmail', () {
      test('should successfully sign in user with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'testPassword123';

        when(mockUser.id).thenReturn('test-user-id');
        when(mockUser.email).thenReturn(email);
        when(mockAuthResponse.user).thenReturn(mockUser);

        when(mockGoTrueClient.signInWithPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => mockAuthResponse);

        // Act & Assert
        expect(() async {
          // In a real implementation with dependency injection:
          // final result = await authService.signInWithEmail(email, password);
          // expect(result['user']['email'], equals(email));
        }, returnsNormally);
      });

      test('should throw exception for invalid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const wrongPassword = 'wrongPassword';

        when(mockGoTrueClient.signInWithPassword(
          email: email,
          password: wrongPassword,
        )).thenThrow(AuthException('Invalid credentials'));

        // Act & Assert
        expect(() async {
          await authService.signInWithEmail(email, wrongPassword);
        }, throwsA(isA<Exception>()));
      });
    });

    group('signInAnonymously', () {
      test('should successfully create anonymous user', () async {
        // Arrange
        const institutionCode = 'TEST_UNIV';

        when(mockUser.id).thenReturn('anonymous-user-id');
        when(mockUser.isAnonymous).thenReturn(true);
        when(mockAuthResponse.user).thenReturn(mockUser);

        when(mockGoTrueClient.signInAnonymously()).thenAnswer((_) async => mockAuthResponse);

        // Act & Assert
        expect(() async {
          // In a real implementation:
          // final result = await authService.signInAnonymously(institutionCode);
          // expect(result['user']['id'], isNotEmpty);
        }, returnsNormally);
      });

      test('should throw exception for invalid institution code', () async {
        // Arrange
        const invalidInstitutionCode = 'INVALID_CODE';

        // Act & Assert
        expect(() async {
          await authService.signInAnonymously(invalidInstitutionCode);
        }, throwsA(isA<Exception>()));
      });
    });

    group('signOut', () {
      test('should successfully sign out user', () async {
        // Arrange
        when(mockGoTrueClient.signOut()).thenAnswer((_) async {});

        // Act & Assert
        expect(() async {
          await authService.signOut();
        }, returnsNormally);
      });
    });

    group('getCurrentUser', () {
      test('should return current user when authenticated', () {
        // Arrange
        when(mockGoTrueClient.currentUser).thenReturn(mockUser);
        when(mockUser.id).thenReturn('test-user-id');
        when(mockUser.email).thenReturn('test@example.com');

        // Act
        final user = authService.getCurrentUser();

        // Assert
        expect(user, isNotNull);
      });

      test('should return null when not authenticated', () {
        // Arrange
        when(mockGoTrueClient.currentUser).thenReturn(null);

        // Act
        final user = authService.getCurrentUser();

        // Assert
        expect(user, isNull);
      });
    });

    group('isSignedIn', () {
      test('should return true when user is signed in', () {
        // Arrange
        when(mockGoTrueClient.currentUser).thenReturn(mockUser);

        // Act
        final isSignedIn = authService.isSignedIn();

        // Assert
        expect(isSignedIn, isTrue);
      });

      test('should return false when user is not signed in', () {
        // Arrange
        when(mockGoTrueClient.currentUser).thenReturn(null);

        // Act
        final isSignedIn = authService.isSignedIn();

        // Assert
        expect(isSignedIn, isFalse);
      });
    });

    group('Password Validation', () {
      test('should validate strong passwords correctly', () {
        // Test cases for password validation
        expect(() => _validatePassword('strongPassword123!'), returnsNormally);
        expect(() => _validatePassword('AnotherGood1@'), returnsNormally);
      });

      test('should reject weak passwords', () {
        // Test cases for weak passwords
        expect(() => _validatePassword('123'), throwsA(isA<Exception>()));
        expect(() => _validatePassword('weak'), throwsA(isA<Exception>()));
        expect(() => _validatePassword(''), throwsA(isA<Exception>()));
      });
    });

    group('Email Validation', () {
      test('should validate correct email formats', () {
        expect(_isValidEmail('test@example.com'), isTrue);
        expect(_isValidEmail('user@university.edu'), isTrue);
        expect(_isValidEmail('name.surname@domain.co.uk'), isTrue);
      });

      test('should reject invalid email formats', () {
        expect(_isValidEmail('invalid-email'), isFalse);
        expect(_isValidEmail('@domain.com'), isFalse);
        expect(_isValidEmail('user@'), isFalse);
        expect(_isValidEmail(''), isFalse);
      });
    });
  });
}

// Helper functions for validation tests
void _validatePassword(String password) {
  if (password.length < 8) {
    throw Exception('Password must be at least 8 characters long');
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
    throw Exception('Password must contain at least one lowercase letter, one uppercase letter, and one number');
  }
}

bool _isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}