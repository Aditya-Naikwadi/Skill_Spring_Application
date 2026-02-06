# SkillSpring - Mobile Learning Platform

![SkillSpring Logo](https://img.shields.io/badge/SkillSpring-Learn%20Coding-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase)

A comprehensive Flutter mobile application designed for college and university students to learn coding languages through free courses, hands-on projects, and interactive materials.

## 🎯 Features

### Core Features
- **🔐 Authentication** - Email/Phone + Password with role-based access control
- **📚 Course Catalog** - Browse courses by category (Python, Java, JavaScript, Web Dev, etc.)
- **📖 Study Materials** - Text-based learning content and video courses
- **🛠️ Hands-on Projects** - Step-by-step project guides with real-world applications
- **🏆 Leaderboard** - Compete with peers and track your ranking
- **📜 Free Certificates** - Earn certificates upon course completion
- **👤 User Profile** - Track progress, view certificates, and manage account

### Student Benefits
- ✅ Free access to all courses
- ✅ Downloadable study materials
- ✅ Industry-recognized certificates
- ✅ Progress tracking and analytics
- ✅ Community support
- ✅ Career guidance resources

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/skillspring.git
   cd skillspring
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```
   
   Follow the detailed setup in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

4. **Run the app**
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

## 📱 Screenshots

### Authentication
- Beautiful gradient login screen
- Registration with password strength indicator
- Role-based access control

### Home Screen
- Personalized greeting
- Progress overview with stats
- Quick action cards
- Featured courses

### Academics
- Course catalog with categories
- Search functionality
- Course details with enrollment
- Study materials and video player

### Leaderboard
- Top 3 podium display
- Weekly/Monthly/All-time rankings
- User rank card
- Achievement badges

### Profile
- User statistics
- Certificates gallery
- Student benefits
- Settings and preferences

## 🏗️ Project Structure

```
lib/
├── config/
│   ├── theme.dart              # App theme and styling
│   └── routes.dart             # Navigation routes
├── models/
│   ├── user_model.dart         # User data model
│   ├── course_model.dart       # Course data model
│   ├── certificate_model.dart  # Certificate model
│   └── leaderboard_entry.dart  # Leaderboard model
├── services/
│   ├── auth_service.dart       # Firebase Authentication
│   ├── firestore_service.dart  # Firestore operations
│   └── storage_service.dart    # Firebase Storage
├── providers/
│   ├── auth_provider.dart      # Auth state management
│   ├── course_provider.dart    # Course state management
│   └── leaderboard_provider.dart
├── screens/
│   ├── auth/                   # Login & Registration
│   ├── home/                   # Home screen
│   ├── academics/              # Course catalog & details
│   ├── leaderboard/            # Rankings
│   └── profile/                # User profile
├── widgets/
│   ├── common/                 # Reusable widgets
│   └── course_card.dart        # Course card widget
├── utils/
│   ├── constants.dart          # App constants
│   ├── validators.dart         # Form validators
│   └── helpers.dart            # Helper functions
└── main.dart                   # App entry point
```

## 🎨 Design

- **Material Design 3** with custom color scheme
- **Cupertino widgets** for iOS native feel
- **Google Fonts** (Poppins) for typography
- **Gradient backgrounds** and smooth animations
- **Responsive layouts** for all screen sizes

### Color Palette
- Primary: Deep Blue (#1976D2)
- Secondary: Orange (#FF9800)
- Accent: Green (#4CAF50)
- Background: Light Gray (#F5F7FA)

## 🔧 Technologies Used

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Storage
- **State Management**: Provider
- **Navigation**: Material Navigation
- **UI Components**: Material Design 3 + Cupertino

## 📦 Dependencies

```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.16.0
cloud_firestore: ^4.14.0
firebase_storage: ^11.6.0
provider: ^6.1.1
google_fonts: ^6.1.0
video_player: ^2.8.2
flutter_pdfview: ^1.3.2
```

See [pubspec.yaml](pubspec.yaml) for complete list.

## 🔐 Security

- Firebase Authentication for secure user management
- Firestore Security Rules for data protection
- Role-based access control (Student, Instructor, Admin)
- Password strength validation
- Secure data transmission

## 🚧 Roadmap

- [ ] Implement video course player
- [ ] Add quiz functionality
- [ ] Create discussion forums
- [ ] Add push notifications
- [ ] Implement offline mode
- [ ] Add social sharing
- [ ] Create instructor dashboard
- [ ] Add payment integration for premium courses

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Fonts for typography
- Material Design for UI guidelines

## 📞 Support

For support, email support@skillspring.com or join our Slack channel.

---

Made with ❤️ for students worldwide
