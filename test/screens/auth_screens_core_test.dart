import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anonymous_confessions/screens/auth/login_screen.dart';
import 'package:anonymous_confessions/screens/auth/signup_screen.dart';

void main() {
  group('Authentication Screens - Core Functionality Tests', () {
    
    testWidgets('LoginScreen loads and displays main elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Test main branding elements
      expect(find.text('Confess'), findsOneWidget);
      expect(find.text('Share your thoughts anonymously'), findsOneWidget);
      
      // Test form field labels
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      
      // Test that we have the correct number of input fields
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('SignupScreen loads and displays main elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Test main branding elements
      expect(find.text('Join Confess'), findsOneWidget);
      expect(find.text('Create your anonymous account'), findsOneWidget);
      
      // Test form field labels
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      
      // Test that we have the correct number of input fields
      expect(find.byType(TextField), findsNWidgets(4));
      
      // Test checkbox for terms
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the Terms of Service and Privacy Policy'), findsOneWidget);
    });

    testWidgets('LoginScreen email field accepts input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Find and test email field
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('LoginScreen password field is obscured', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Find password field and verify it's obscured
      final passwordFields = find.byType(TextField);
      final passwordField = tester.widget<TextField>(passwordFields.last);
      
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('SignupScreen username field accepts input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Test username field (first field)
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'testuser123');
      await tester.pump();

      expect(find.text('testuser123'), findsOneWidget);
    });

    testWidgets('SignupScreen email field accepts input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Test email field (second field)
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(1), 'user@test.com');
      await tester.pump();

      expect(find.text('user@test.com'), findsOneWidget);
    });

    testWidgets('SignupScreen password fields are obscured', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      
      // Check password field (3rd field)
      final passwordField = tester.widget<TextField>(fields.at(2));
      expect(passwordField.obscureText, isTrue);
      
      // Check confirm password field (4th field)
      final confirmPasswordField = tester.widget<TextField>(fields.at(3));
      expect(confirmPasswordField.obscureText, isTrue);
    });

    testWidgets('LoginScreen has password visibility toggle', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Should have a visibility icon for password field
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('SignupScreen has password visibility toggles', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Should have visibility icons for both password fields
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
    });

    testWidgets('LoginScreen has social login buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Check for Google and Apple login options
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('SignupScreen has social signup buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Check for Google and Apple signup options
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });

    testWidgets('Navigation buttons exist on both screens', (tester) async {
      // Test LoginScreen navigation text
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      
      // Test SignupScreen navigation text
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();
      
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('Basic form validation triggers exist', (tester) async {
      // Just verify that the buttons exist that would trigger validation
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      
      // Find main sign in button - use more specific finder
      final signInButtons = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(signInButtons, findsOneWidget);
      
      // Test SignupScreen
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();
      
      // Find create account button
      final createAccountButtons = find.widgetWithText(ElevatedButton, 'Create Account');
      expect(createAccountButtons, findsOneWidget);
    });
  });
}