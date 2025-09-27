# Contributing to College Confessions App

Thank you for your interest in contributing to College Confessions! This document provides guidelines and instructions for contributors.

## 🚀 Quick Start for Contributors

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/cc-app.git
   cd cc-app
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
5. **Make your changes** following our guidelines
6. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   ```
7. **Commit and push**:
   ```bash
   git commit -m "feat: add your feature description"
   git push origin feature/your-feature-name
   ```
8. **Create a Pull Request** on GitHub

## 📋 Development Guidelines

### Code Style & Standards

- **Dart Style**: Follow official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- **Flutter Conventions**: Use Flutter best practices
- **Linting**: Code must pass `flutter analyze` without warnings
- **Formatting**: Use `dart format` before committing
- **Documentation**: Document all public APIs and complex logic

### Design System Usage

**Always use the design system components:**

```dart
// ✅ Good - Use design system
Container(
  padding: CCDesignSystem.paddingMedium,
  decoration: BoxDecoration(
    color: CCDesignSystem.primaryBlue,
    borderRadius: CCDesignSystem.borderRadiusLarge,
  ),
  child: Text(
    'Hello World',
    style: CCDesignSystem.bodyMedium,
  ),
)

// ❌ Bad - Hard-coded values
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF0095F6),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(fontSize: 15),
  ),
)
```

### Component Development

When creating new widgets:

1. **Location**: Place reusable components in `lib/widgets/common/`
2. **Naming**: Use `CC` prefix for College Confessions components
3. **Documentation**: Include comprehensive documentation
4. **Examples**: Provide usage examples in comments
5. **Export**: Add to `lib/widgets/cc_widgets.dart`

**Component Template:**

```dart
import 'package:flutter/material.dart';
import '../../core/design/design_system.dart';

/// CC[ComponentName] - Brief description
/// 
/// Detailed description explaining when and how to use this component.
/// Include any important behavior or constraints.
/// 
/// Example:
/// ```dart
/// CC[ComponentName](
///   requiredProperty: 'value',
///   optionalProperty: true,
///   onAction: () => print('Action triggered'),
/// )
/// ```
class CC[ComponentName] extends StatelessWidget {
  const CC[ComponentName]({
    super.key,
    required this.requiredProperty,
    this.optionalProperty,
    this.onAction,
  });

  final String requiredProperty;
  final bool? optionalProperty;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Implementation using design system tokens
      padding: CCDesignSystem.paddingMedium,
      decoration: BoxDecoration(
        color: CCDesignSystem.backgroundWhite,
        borderRadius: CCDesignSystem.borderRadiusLarge,
      ),
      child: Text(
        requiredProperty,
        style: CCDesignSystem.bodyMedium,
      ),
    );
  }
}
```

## 🎯 Areas for Contribution

### High Priority
- **Backend Integration**: Connect to real data sources
- **Authentication**: Implement user login/signup
- **Real-time Features**: Live updates for likes/comments
- **Performance**: Optimize rendering and memory usage

### Medium Priority
- **Accessibility**: Improve screen reader support
- **Internationalization**: Add multi-language support
- **Dark Mode**: Complete dark theme implementation
- **Animations**: Add smooth transitions and micro-interactions

### Low Priority
- **Testing**: Increase test coverage
- **Documentation**: Improve inline documentation
- **Examples**: Create more component examples
- **Platform Features**: iOS/Android specific optimizations

## 🧪 Testing Guidelines

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Structure
- **Unit Tests**: Test individual functions and classes
- **Widget Tests**: Test widget behavior and rendering
- **Integration Tests**: Test complete user flows

### Writing Tests
```dart
// Widget test example
testWidgets('CCPrimaryButton displays label correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CCPrimaryButton(
          onPressed: () {},
          label: 'Test Button',
        ),
      ),
    ),
  );

  expect(find.text('Test Button'), findsOneWidget);
});
```

## 📝 Commit Message Convention

Use conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Changes to build process or auxiliary tools

**Examples:**
```bash
feat(auth): add user login functionality
fix(profile): resolve card layout overflow issue
docs(readme): update component usage examples
style(buttons): format code according to dart style
refactor(cards): extract common card logic
test(inputs): add tests for CCTextField component
chore(deps): update flutter sdk to latest version
```

## 🔍 Code Review Process

### Before Submitting PR
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] No linting errors
- [ ] Documentation is updated
- [ ] Commit messages are clear

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots of UI changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
```

## 🐛 Bug Reports

Use the GitHub issue template:

```markdown
## Bug Description
Clear description of the bug

## Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- Device: [e.g., iPhone 12, Pixel 5]
- OS: [e.g., iOS 15, Android 12]
- App Version: [e.g., 1.0.0]
- Flutter Version: [e.g., 3.24.0]

## Screenshots
Add screenshots if applicable
```

## 💡 Feature Requests

```markdown
## Feature Description
Clear description of the proposed feature

## Problem/Motivation
What problem does this solve?

## Proposed Solution
Detailed description of the solution

## Alternatives Considered
Other approaches you considered

## Additional Context
Any other context, mockups, or examples
```

## 📚 Resources for Contributors

### Design Resources
- [College Confessions Design System](lib/core/design/design_system.dart)
- [Material Design 3](https://m3.material.io/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Flutter Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

### Development Tools
- [Flutter Inspector](https://docs.flutter.dev/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## ❓ Getting Help

- **GitHub Issues**: For bugs and feature requests
- **Discussions**: For questions and general discussion
- **Discord**: [Join our community](# - link to be added)
- **Email**: For sensitive issues

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Special contributor badge in Discord

Thank you for contributing to College Confessions! 🎓✨