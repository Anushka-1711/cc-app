# # Anonymous Confessions - College Edition

A Flutter-based anonymous social platform for college students to share confessions, thoughts, and connect with their community safely and privately.

## 🚀 Features

# College Confessions

An exact clone of the cc-web GitHub repository, bu# College Confessions App 🎓

A modern, anonymous confession platform for college students built with Flutter, featuring Instagram-style UI and Reddit-inspired community features.

## 🚀 Features

- **Anonymous & Public Confessions**: Share your thoughts anonymously or publicly
- **Community Categories**: 10+ specialized confession categories
- **Modern UI**: Instagram-inspired design with Material Design 3
- **Cross-Platform**: Optimized for both iOS and Android
- **Responsive**: Adaptive icons and platform-specific UI elements
- **Design System**: Comprehensive design tokens and reusable components

## 📱 Screenshots

*Screenshots will be added here*

## 🛠 Architecture

### Project Structure

```
lib/
├── core/                          # Core utilities and configurations
│   ├── design/                    # Design system and theming
│   │   ├── design_system.dart     # Design tokens (colors, typography, spacing)
│   │   └── theme.dart             # Material Theme configuration
│   └── utils/                     # Utility classes
│       ├── adaptive_icons.dart    # Platform-adaptive icon mappings
│       └── platform_utils.dart    # Platform detection utilities
├── screens/                       # Application screens
│   ├── auth/                      # Authentication screens
│   ├── communities/               # Communities/categories screen
│   ├── create_post/               # Post creation screen
│   ├── home/                      # Home feed screen
│   ├── notifications/             # Activity/notifications screen
│   ├── profile/                   # User profile screen
│   └── main_app_screen.dart       # Bottom navigation wrapper
├── widgets/                       # Reusable UI components
│   ├── common/                    # Common widget components
│   │   ├── cc_buttons.dart        # Button components
│   │   ├── cc_cards.dart          # Card components
│   │   └── cc_inputs.dart         # Input field components
│   └── cc_widgets.dart            # Widget library exports
├── app.dart                       # Main app configuration
└── main.dart                      # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: `#0095F6` (Instagram Blue)
- **Text Primary**: `#262626` (Dark Gray)
- **Text Secondary**: `#8E8E8E` (Light Gray)
- **Background**: `#FFFFFF` (White)
- **Anonymous**: `#262626` (Dark)
- **Public**: `#0095F6` (Blue)

### Typography
- **Heading 1**: 32px, Bold
- **Heading 2**: 24px, Bold
- **Heading 3**: 20px, SemiBold
- **Body Large**: 16px, Regular
- **Body Medium**: 15px, Regular
- **Body Small**: 14px, Regular

### Spacing
Based on 8px grid system:
- `space4`: 4px
- `space8`: 8px
- `space16`: 16px
- `space24`: 24px
- `space32`: 32px

## 🧩 Component Library

### Buttons
```dart
// Primary action button
CCPrimaryButton(
  onPressed: () {},
  label: 'Submit Confession',
  icon: AdaptiveIcons.send,
)

// Secondary button
CCSecondaryButton(
  onPressed: () {},
  label: 'Cancel',
)

// Text button
CCTextButton(
  onPressed: () {},
  label: 'Skip',
)
```

### Cards
```dart
// Basic card
CCCard(
  child: Text('Content'),
)

// Confession card
CCConfessionCard(
  content: 'Confession text...',
  isAnonymous: true,
  community: 'Academic Stress',
  timeAgo: '2h',
  likes: 45,
  comments: 12,
  onLike: () {},
  onComment: () {},
  onShare: () {},
)
```

### Inputs
```dart
// Text field
CCTextField(
  controller: controller,
  label: 'Username',
  hintText: 'Enter your username',
)

// Text area for long text
CCTextArea(
  controller: controller,
  label: 'Your Confession',
  hintText: 'Share your thoughts...',
  maxLength: 500,
)

// Anonymous/Public toggle
CCToggle(
  value: isAnonymous,
  onChanged: (value) => setState(() => isAnonymous = value),
  activeLabel: 'Anonymous',
  inactiveLabel: 'Public',
  activeIcon: AdaptiveIcons.lock,
  inactiveIcon: AdaptiveIcons.public,
)
```

## 🔧 Development Setup

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / Xcode
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Anushka-1711/cc-app.git
cd cc-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Development Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run on specific device
flutter run -d <device-id>

# Build for release
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Code Style
- Follow Dart/Flutter conventions
- Use the existing design system components
- Add documentation for new components
- Write meaningful commit messages

### Component Guidelines
1. **Use Design System**: Always use `CCDesignSystem` tokens for colors, spacing, typography
2. **Platform Adaptive**: Use `AdaptiveIcons` for cross-platform icons
3. **Reusable**: Create components that can be reused across the app
4. **Documented**: Add comprehensive documentation and examples

### Pull Request Process
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the style guidelines
4. Add tests if applicable
5. Update documentation
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Adding New Components

When creating new reusable components:

1. Place them in `lib/widgets/common/`
2. Use the design system tokens:
```dart
import '../../core/design/design_system.dart';

// Use design tokens
color: CCDesignSystem.primaryBlue,
padding: CCDesignSystem.paddingMedium,
textStyle: CCDesignSystem.bodyMedium,
```

3. Add to the widget library exports in `cc_widgets.dart`
4. Document usage examples

### Component Template
```dart
import 'package:flutter/material.dart';
import '../../core/design/design_system.dart';

/// [ComponentName] - Brief description
/// 
/// Detailed description of when and how to use this component.
/// 
/// Example:
/// ```dart
/// ComponentName(
///   property: value,
///   onAction: () {},
/// )
/// ```
class ComponentName extends StatelessWidget {
  const ComponentName({
    super.key,
    required this.requiredProperty,
    this.optionalProperty,
  });

  final String requiredProperty;
  final String? optionalProperty;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Implementation using design system
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

## 🚦 Project Status

- ✅ Core UI Implementation
- ✅ Design System & Component Library
- ✅ Platform-Adaptive Icons
- ✅ Authentication Screens (UI)
- ✅ Main Navigation
- ✅ Profile Screen with Card Layout
- ✅ Create Post Screen
- 🔄 Backend Integration (In Progress)
- 🔄 Real-time Features (Planned)
- 🔄 Push Notifications (Planned)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Instagram and Reddit for UI/UX patterns
- Contributors and beta testers

## 📞 Contact

For questions or suggestions, please open an issue on GitHub.

---

Made with ❤️ for college students by college students..

## Features

- **Anonymous Confessions**: Share thoughts anonymously with your college community
- **Communities**: Join and interact with different college communities
- **Real-time Feed**: Instagram-style feed with likes, comments, and reactions
- **User Profiles**: Manage your anonymous identity and settings
- **Educational Onboarding**: Select student type (College/School/Coaching), institution, and campus branch
- **Campus Branch System**: Support for multiple physical campus locations per institution
- **Multi-platform**: Runs on Android and iOS

## Screenshots

### Authentication & Onboarding
- Login with social accounts (Google, Facebook, Apple) or email/password  
- Signup with comprehensive educational onboarding flow
- Student type selection (College/School/Coaching)
- Institution search and selection with filtering
- Campus branch selection for different physical locations

### Main Features
- **Home Feed**: Browse anonymous confessions with engagement features
- **Communities**: Join communities like CS, Mental Health, Dorm Life, etc.
- **Create Post**: Share anonymous confessions with community selection
- **Notifications**: Stay updated with likes, comments, and community activity
- **Profile**: Manage account settings and view your stats

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Design**: Material Design with Instagram-inspired UI
- **Architecture**: Clean Architecture with proper separation of concerns

## Color Scheme

- Primary: #0095F6 (Instagram Blue)
- Background: #FAFAFA  
- Text: #262626
- Muted: #8E8E8E
- Gradients: Blue to Purple to Pink

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart              # Main app configuration
└── screens/
    ├── auth/             # Login & Signup screens
    ├── home/             # Home feed screen
    ├── onboarding/       # Onboarding flow
    └── main_app_screen.dart # Main navigation with 5 tabs
```

## Exact GitHub Repository Clone

This Flutter app is an **exact replica** of the cc-web GitHub repository, featuring:
- Identical color schemes and typography
- Same user interface patterns and layouts  
- Matching navigation and user experience
- All features from the original web version

---

Built with ❤️ using Flutterts**: Share your thoughts without revealing your identity
- **Community-Based**: Connect with your college/university community
- **Real-time Updates**: See new confessions as they happen
- **Secure**: Built with Supabase for reliable backend services
- **Cross-Platform**: Works on Android, iOS, and Web

## 📱 Screenshots

*[Add screenshots here when app is ready for demo]*

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.35.4+
- **Backend**: Supabase
- **State Management**: Provider
- **Navigation**: GoRouter
- **UI**: Material Design 3
- **Responsive Design**: ScreenUtil & Responsive Framework

## 📋 Project Structure

```
lib/
├── core/
│   ├── config/          # Configuration files (Supabase, etc.)
│   ├── constants/       # App-wide constants
│   ├── router/          # Navigation setup
│   └── theme/           # App theming and styles
├── models/              # Data models
├── providers/           # State management (Provider pattern)
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   ├── communities/    # Community browsing
│   ├── create_post/    # Post creation
│   ├── home/           # Home feed
│   ├── post_detail/    # Individual post view
│   └── profile/        # User profile
├── services/           # Business logic and API calls
└── widgets/            # Reusable UI components
```

## 🏗️ Setup & Installation

### Prerequisites

- Flutter 3.35.4 or higher
- Android Studio (for Android development)
- VS Code or your preferred IDE
- Git

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd college_confessions
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a new Supabase project
   - Update `lib/core/config/supabase_config.dart` with your credentials
   - Set up the database schema (see Database Setup below)

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**Web:**
```bash
flutter build web --release
```

## 🗄️ Database Setup

The app uses Supabase as the backend. You'll need to create the following tables:

### Tables Schema

1. **users** - User profiles
2. **communities** - College/University communities  
3. **posts** - Anonymous confessions/posts
4. **comments** - Post comments
5. **reactions** - Likes/reactions to posts

*Note: Detailed SQL scripts will be provided in `database/` folder*

## 🔧 Configuration

### Environment Setup

1. Copy `lib/core/config/supabase_config.dart.example` to `supabase_config.dart`
2. Fill in your Supabase credentials:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   }
   ```

### Android Configuration

- Update package name in `android/app/build.gradle`
- Configure app signing for release builds
- Update app name and icon as needed

## 👥 Team Collaboration

### Code Style

- Follow Flutter's official style guide
- Use meaningful variable and function names
- Comment complex logic
- Run `flutter analyze` before committing

### Git Workflow

1. Create feature branches from `main`
2. Make small, focused commits
3. Write descriptive commit messages
4. Create pull requests for code review
5. Merge only after approval and testing

### Development Workflow

1. **Feature Development**:
   ```bash
   git checkout -b feature/your-feature-name
   flutter pub get
   # Develop your feature
   flutter test
   flutter analyze
   git commit -m "Add: your feature description"
   git push origin feature/your-feature-name
   ```

2. **Testing**: Run tests before submitting PRs
   ```bash
   flutter test
   flutter integration_test
   ```

## 🐛 Common Issues & Solutions

### Build Issues
- Clean build: `flutter clean && flutter pub get`
- Clear cache: Delete `.dart_tool/` and `build/` folders

### Android Issues  
- Ensure Android SDK and NDK are properly installed
- Check `flutter doctor` for any missing components

### Dependencies
- If dependencies conflict, try `flutter pub deps` to analyze
- Update gradually: `flutter pub upgrade --major-versions`

## 📚 Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider State Management](https://pub.dev/packages/provider)
- [GoRouter Navigation](https://pub.dev/packages/go_router)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Add tests if applicable
5. Ensure code passes all checks
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For questions or issues:
- Create an issue on GitHub
- Contact the team lead
- Check the documentation first

## 🎯 Roadmap

- [ ] User authentication system
- [ ] Real-time notifications
- [ ] Image/media sharing
- [ ] Advanced privacy controls
- [ ] Moderation system
- [ ] Analytics dashboard

---

**Happy Coding! 🚀**

*Built with ❤️ by the College Confessions Team*android

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
