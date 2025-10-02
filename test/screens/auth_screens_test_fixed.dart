import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anonymous_confessions/screens/auth/login_screen.dart';
import 'package:anonymous_confessions/screens/auth/signup_screen.dart';

void main() {
  group('Authentication Screens Integration Tests', () {
    testWidgets('LoginScreen displays all UI elements with proper scrolling', (tester) async {
      // Set a larger viewport to accommodate the full screen
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Check main UI elements (should be visible without scrolling)
      expect(find.text('Confess'), findsOneWidget);
      expect(find.text('Share your thoughts anonymously'), findsOneWidget);
      
      // Check form fields
      expect(find.text('Email or Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      
      // Scroll down to find the Sign In button
      await tester.scrollUntilVisible(
        find.text('Sign In'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      expect(find.text('Sign In'), findsOneWidget);
      
      // Scroll to footer
      await tester.scrollUntilVisible(
        find.text('Sign up'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('SignupScreen displays all UI elements with proper scrolling', (tester) async {
      // Set a larger viewport
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      
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
      
      // Scroll to find checkbox
      await tester.scrollUntilVisible(
        find.byType(Checkbox),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the Terms of Service and Privacy Policy'), findsOneWidget);
      
      // Scroll to find Create Account button
      await tester.scrollUntilVisible(
        find.text('Create Account'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('LoginScreen shows validation via SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Scroll to Sign In button
      await tester.scrollUntilVisible(
        find.text('Sign In'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      
      // Tap Sign In button without filling fields
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check for SnackBar validation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('SignupScreen shows validation via SnackBar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // First scroll to and check the checkbox
      await tester.scrollUntilVisible(
        find.byType(Checkbox),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      
      // Tap checkbox to agree to terms
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // Scroll to Create Account button
      await tester.scrollUntilVisible(
        find.text('Create Account'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      
      // Tap Create Account without filling fields
      await tester.tap(find.text('Create Account'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check for SnackBar validation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter an email address'), findsOneWidget);
    });

    testWidgets('LoginScreen form inputs work correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();

      // Test email input
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      // Test password input and obscuring
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();
      
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('SignupScreen form inputs work correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);

      // Test username input
      await tester.enterText(fields.first, 'testuser');
      await tester.pump();
      expect(find.text('testuser'), findsOneWidget);

      // Test email input
      await tester.enterText(fields.at(1), 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);

      // Test password fields are obscured
      final passwordField = tester.widget<TextField>(fields.at(2));
      final confirmPasswordField = tester.widget<TextField>(fields.at(3));
      expect(passwordField.obscureText, isTrue);
      expect(confirmPasswordField.obscureText, isTrue);
    });

    testWidgets('Navigation between screens works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      
      // Test LoginScreen -> SignupScreen
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      
      await tester.scrollUntilVisible(
        find.text('Sign up'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      
      expect(find.byType(SignupScreen), findsOneWidget);
      expect(find.text('Join Confess'), findsOneWidget);
      
      // Test SignupScreen -> LoginScreen
      await tester.scrollUntilVisible(
        find.text('Sign in'),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );
      
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Confess'), findsOneWidget);
    });

    testWidgets('SignupScreen checkbox interaction works', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      
      await tester.pumpWidget(const MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      // Scroll to checkbox
      await tester.scrollUntilVisible(
        find.byType(Checkbox),
        500.0,
        scrollable: find.byType(SingleChildScrollView),
      );

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

    // Reset surface size after tests
    tearDown(() async {
      await TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(null);
    });
  });
}