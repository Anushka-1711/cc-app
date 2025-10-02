import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anonymous_confessions/screens/auth/login_screen.dart';
import 'package:anonymous_confessions/screens/auth/signup_screen.dart';

void main() {
  group('Authentication Screens UI Tests', () {
    testWidgets('LoginScreen displays all expected UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Check for main brand elements
      expect(find.text('Confess'), findsOneWidget);
      expect(find.text('Share your thoughts anonymously'), findsOneWidget);
      
      // Check for form elements
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Check for action buttons
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      
      // Check for footer text
      expect(find.text("Don't have an account? "), findsOneWidget);
    });

    testWidgets('SignupScreen displays all expected UI elements', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      // Check for main brand elements
      expect(find.text('Join Confess'), findsOneWidget);
      expect(find.text('Create your anonymous account'), findsOneWidget);
      
      // Check for form elements
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(4));
      
      // Check for action elements
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the Terms of Service and Privacy Policy'), findsOneWidget);
      
      // Check for footer
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('LoginScreen email field accepts text input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('LoginScreen password field is obscured by default', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final passwordField = find.byType(TextField).last;
      final textField = tester.widget<TextField>(passwordField);
      
      expect(textField.obscureText, isTrue);
    });

    testWidgets('SignupScreen username field accepts text input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'testuser123');
      await tester.pump();

      expect(find.text('testuser123'), findsOneWidget);
    });

    testWidgets('SignupScreen email field accepts text input', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      final fields = find.byType(TextField);
      final emailField = fields.at(1); // Second field is email
      await tester.enterText(emailField, 'user@test.com');
      await tester.pump();

      expect(find.text('user@test.com'), findsOneWidget);
    });

    testWidgets('SignupScreen password fields are obscured by default', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      final fields = find.byType(TextField);
      final passwordField = fields.at(2); // Third field is password
      final confirmPasswordField = fields.at(3); // Fourth field is confirm password

      final passwordWidget = tester.widget<TextField>(passwordField);
      final confirmPasswordWidget = tester.widget<TextField>(confirmPasswordField);
      
      expect(passwordWidget.obscureText, isTrue);
      expect(confirmPasswordWidget.obscureText, isTrue);
    });

    testWidgets('LoginScreen navigation to SignupScreen works', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      final signupButton = find.text('Sign up');
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      expect(find.byType(SignupScreen), findsOneWidget);
      expect(find.text('Join Confess'), findsOneWidget);
    });

    testWidgets('SignupScreen navigation to LoginScreen works', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      final loginButton = find.text('Sign in');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Confess'), findsOneWidget);
    });

    testWidgets('LoginScreen has visibility toggle for password field', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Find the password visibility icon button
      final visibilityIcon = find.byIcon(Icons.visibility);
      expect(visibilityIcon, findsOneWidget);
    });

    testWidgets('SignupScreen has visibility toggles for password fields', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

      // Should have visibility icons for both password fields
      final visibilityIcons = find.byIcon(Icons.visibility);
      expect(visibilityIcons, findsNWidgets(2));
    });
  });
}