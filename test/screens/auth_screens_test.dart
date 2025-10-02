import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anonymous_confessions/screens/auth/login_screen.dart';
import 'package:anonymous_confessions/screens/auth/signup_screen.dart';

void main() {
  group('Authentication Screens Tests', () {
    testWidgets('LoginScreen displays correct UI elements', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const LoginScreen()));

      // Check for main UI elements - based on actual LoginScreen implementation
      expect(find.text('Confess'), findsOneWidget);
      expect(find.text('Share your thoughts anonymously'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      
      // Check for form fields - LoginScreen uses TextField, not TextFormField
      expect(find.byType(TextField), findsNWidgets(2)); // Email and password
      
      // Check for field labels
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('SignupScreen displays correct UI elements', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const SignupScreen()));

      // Check for main UI elements - based on actual SignupScreen implementation
      expect(find.text('Join Confess'), findsOneWidget);
      expect(find.text('Create your anonymous account'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      
      // Check for form fields - SignupScreen uses TextField, not TextFormField
      expect(find.byType(TextField), findsNWidgets(4)); // Username, email, password, confirm password
      
      // Check for field labels
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('LoginScreen form validation works', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Try to submit without filling fields
      final submitButton = find.text('Sign In');
      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation error
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('SignupScreen form validation works', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      // Try to submit without filling fields - first need to agree to terms
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pump();

      final submitButton = find.text('Create Account');
      await tester.tap(submitButton);
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter an email address'), findsOneWidget);
    });

    testWidgets('LoginScreen email field accepts input', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('LoginScreen password field obscures text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Password field should obscure text by default
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('SignupScreen username field accepts input', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'testuser');
      await tester.pump();

      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('SignupScreen email field accepts input', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final fields = find.byType(TextField);
      final emailField = fields.at(1); // Second field is email
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('SignupScreen password fields obscure text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final fields = find.byType(TextField);
      final passwordField = fields.at(2); // Third field is password
      final confirmPasswordField = fields.at(3); // Fourth field is confirm password

      // Both password fields should obscure text by default
      final passwordWidget = tester.widget<TextField>(passwordField);
      final confirmPasswordWidget = tester.widget<TextField>(confirmPasswordField);
      
      expect(passwordWidget.obscureText, isTrue);
      expect(confirmPasswordWidget.obscureText, isTrue);
    });

    testWidgets('LoginScreen navigation to signup works', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final signupButton = find.text('Sign up');
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // Should navigate to SignupScreen
      expect(find.byType(SignupScreen), findsOneWidget);
    });

    testWidgets('SignupScreen navigation to login works', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      final loginButton = find.text('Sign in');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Should navigate to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('SignupScreen terms checkbox works', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      // Find and tap the checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);
      
      // Initially unchecked
      Checkbox checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isFalse);
      
      // Tap to check
      await tester.tap(checkbox);
      await tester.pump();
      
      // Should be checked now
      checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);
    });
  });
}