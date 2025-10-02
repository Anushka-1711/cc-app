import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anonymous_confessions/screens/auth/login_screen.dart';
import 'package:anonymous_confessions/screens/auth/signup_screen.dart';

void main() {
  group('Authentication Screens Integration Tests', () {
    testWidgets('LoginScreen displays all required UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Check main UI elements that should be visible at top
      expect(find.text('Confess'), findsOneWidget);
      expect(find.text('Share your thoughts anonymously'), findsOneWidget);
      
      // Check form fields (should be visible in viewport)
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Use scrollUntilVisible for elements that might be off-screen
      await tester.scrollUntilVisible(
        find.text('Sign In'),
        500.0,
      );
      expect(find.text('Sign In'), findsOneWidget);
      
      // Scroll to footer elements
      await tester.scrollUntilVisible(
        find.text('Sign up'),
        500.0,
      );
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('SignupScreen displays all required UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Check main UI elements
      expect(find.text('Join Confess'), findsOneWidget);
      expect(find.text('Create your anonymous account'), findsOneWidget);
      
      // Check form fields
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(4));
      
      // Scroll to checkbox if needed
      try {
        await tester.scrollUntilVisible(
          find.byType(Checkbox),
          500.0,
        );
      } catch (e) {
        // If scrollUntilVisible fails, element might already be visible
      }
      expect(find.byType(Checkbox), findsOneWidget);
      
      // Scroll to create account button
      try {
        await tester.scrollUntilVisible(
          find.text('Create Account'),
          500.0,
        );
      } catch (e) {
        // Button might already be visible
      }
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('LoginScreen form inputs work correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Test email input
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      // Test password input and verify it's obscured
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('SignupScreen form inputs work correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);

      // Test username input
      await tester.enterText(fields.first, 'testuser');
      await tester.pump();
      expect(find.text('testuser'), findsOneWidget);

      // Test email input (second field)
      await tester.enterText(fields.at(1), 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      // Verify password fields are obscured
      final passwordField = tester.widget<TextField>(fields.at(2));
      final confirmPasswordField = tester.widget<TextField>(fields.at(3));
      expect(passwordField.obscureText, isTrue);
      expect(confirmPasswordField.obscureText, isTrue);
    });

    testWidgets('LoginScreen shows validation error when fields are empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Scroll to Sign In button and tap it
      await tester.scrollUntilVisible(
        find.text('Sign In'),
        500.0,
      );
      
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // Trigger the validation
      await tester.pump(const Duration(milliseconds: 500)); // Wait for SnackBar

      // Check for SnackBar with validation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('SignupScreen shows validation error when email is empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // First agree to terms by checking the checkbox
      try {
        await tester.scrollUntilVisible(
          find.byType(Checkbox),
          500.0,
        );
      } catch (e) {
        // Element might already be visible
      }
      
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // Scroll to and tap Create Account button
      try {
        await tester.scrollUntilVisible(
          find.text('Create Account'),
          500.0,
        );
      } catch (e) {
        // Button might already be visible
      }
      
      await tester.tap(find.text('Create Account'));
      await tester.pump(); // Trigger validation
      await tester.pump(const Duration(milliseconds: 500)); // Wait for SnackBar

      // Check for SnackBar with validation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter an email address'), findsOneWidget);
    });

    testWidgets('Navigation from LoginScreen to SignupScreen works', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      
      // Scroll to and tap the Sign up button
      await tester.scrollUntilVisible(
        find.text('Sign up'),
        500.0,
      );
      
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      
      // Verify we're now on SignupScreen
      expect(find.byType(SignupScreen), findsOneWidget);
      expect(find.text('Join Confess'), findsOneWidget);
    });

    testWidgets('Navigation from SignupScreen to LoginScreen works', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();
      
      // Scroll to and tap the Sign in button
      try {
        await tester.scrollUntilVisible(
          find.text('Sign in'),
          500.0,
        );
      } catch (e) {
        // Button might already be visible
      }
      
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      
      // Verify we're now on LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Confess'), findsOneWidget);
    });

    testWidgets('SignupScreen checkbox can be toggled', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Find and verify checkbox initial state
      try {
        await tester.scrollUntilVisible(
          find.byType(Checkbox),
          500.0,
        );
      } catch (e) {
        // Checkbox might already be visible
      }

      // Initially unchecked
      Checkbox checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);

      // Tap to check
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Should be checked now
      checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('LoginScreen password field has visibility toggle', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Find the password visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('SignupScreen has visibility toggles for both password fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Should have visibility icons for both password fields
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
    });
  });
}