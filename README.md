# SkillSpring - Mobile Learning Platform

![SkillSpring Logo](https://img.shields.io/badge/SkillSpring-Learn%20Coding-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase)

A comprehensive Flutter mobile application designed for college and university students to learn coding languages through free courses, hands-on projects, and interactive materials.

## 🎯 Features

### Core Features
- **🔐 Authentication** - Secure login with multi-tiered persistence fallbacks (Local/Session/None)
- **🎓 Tiered Curriculum** - Expert-designed courses: **Basic**, **Intermediate**, and **Expert** levels
- **🛠️ Project Roadmaps** - Interactive, step-by-step implementation guidance for signature projects
- **📖 Study Materials** - High-quality text and video content across 10 academic subjects
- **🏆 Global Leaderboard** - Live ranking and points system to compete with peers
- **📜 Verified Certificates** - Earn industry-recognized certificates upon course completion
- **✨ Premium UI** - Modern glassmorphic design system with cinematic shimmer effects

### Student Benefits
- ✅ structured learning paths with expert roadmaps
- ✅ Real-world project experience with guided implementation
- ✅ Flexible authentication and offline-ready architecture
- ✅ Seamless progress tracking across devices
- ✅ Premium, ad-free learning environment

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
- Personalized glassmorphic header
- Interactive Bento Grid stats
- One-tap Quick Action cards
- Shimmer-loading featured courses

### Academics
- Subject-based course organization
- Tiered learning (Beginner to Expert)
- Interactive Project Gallery
- Detailed Project Roadmaps & Tasks

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
├── config/             # Theme & App Configuration
├── core/               # Shared logic & base classes
├── data/               # Static Curriculum & Roadmap Data
├── models/             # Business Logic Models
├── providers/          # Dashboard & Auth State Management
├── screens/            # Application Views (Auth, Home, Academics)
├── services/           # Firestore, Auth, & Storage Services
├── utils/              # Helpers & Constants
├── widgets/            # Reusable UI Components (Glass, Shimmer)
└── main.dart           # App Entry & Init Sequence
```

## 🎨 Design

- **Premium Glassmorphism**: Translucent interfaces with real-time blur and glowing accents
- **Material Design 3** base with heavily customized cyberpunk color scheme
- **Dynamic Shimmer Loaders** for all data-driven components
- **Smooth Cinematic Animations** powered by `animate_do`
- **Responsive Adaptive Layouts** (Mobile, Tablet, Desktop)

### Color Palette
- Primary: Deep Blue (#1976D2)
- Secondary: Orange (#FF9800)
- Accent: Green (#4CAF50)
- Background: Light Gray (#F5F7FA)

## 🔧 Technologies Used

- **Framework**: Flutter 3.x (State-of-the-Art)
- **Backend**: Firebase (Auth, Firestore, Cloud Storage)
- **State Management**: Provider with Unified Dashboard synchronization
- **Architecture**: Domain-driven with specific fallbacks for web storage limitations
- **UI System**: Premium Glassmorphism with Dynamic Shimmers

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

- [x] Implement Tiered Curriculum (Basics/Int/Expert)
- [x] Add Interactive Project Roadmaps
- [x] Unified Dashboard State Architecture
- [x] Premium Shimmer Loading System
- [x] Proactive Firestore Resilience (Long Polling/Persistence Fallbacks)
- [ ] Implement AI Course Assistant
- [ ] Add Real-time Group Study Rooms
- [ ] Create Gamified Learning Paths

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
