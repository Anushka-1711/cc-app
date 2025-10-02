import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'services/auth_service_test.dart' as auth_service_tests;
import 'screens/auth_screens_test.dart' as auth_screens_tests;
import 'screens/feature_integration_test.dart' as feature_integration_tests;

void main() {
  group('Complete Test Suite for CC-App Backend Integration', () {
    
    // Service Layer Tests
    group('Service Layer Tests', () {
      auth_service_tests.main();
    });

    // UI Layer Tests
    group('Authentication Screens Tests', () {
      auth_screens_tests.main();
    });

    // Feature Integration Tests
    group('Feature Integration Tests', () {
      feature_integration_tests.main();
    });
  });
}