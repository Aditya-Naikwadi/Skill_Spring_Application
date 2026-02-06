# 🚀 Quick Start Guide - SkillSpring

## What You Have

A complete Flutter mobile application with:
- ✅ Beautiful authentication screens (Login & Register)
- ✅ Home dashboard with personalized greeting
- ✅ Academics screen with course catalog
- ✅ Leaderboard with rankings
- ✅ User profile with stats
- ✅ Firebase backend integration ready
- ✅ Material Design 3 UI

## Before You Run

### 1. Configure Firebase (REQUIRED)

The app needs Firebase to work. Follow these steps:

```bash
# Install FlutterFire CLI (one-time setup)
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will:
- Prompt you to select/create a Firebase project
- Generate `firebase_options.dart` file
- Configure Android and iOS apps

### 2. Update main.dart

After running `flutterfire configure`, update line 15 in `lib/main.dart`:

**Change from:**
```dart
try {
  await Firebase.initializeApp();
} catch (e) {
  print('Firebase initialization error: $e');
}
```

**Change to:**
```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### 3. Enable Firebase Services

In [Firebase Console](https://console.firebase.google.com/):

1. **Authentication**
   - Go to Authentication → Get started
   - Enable "Email/Password"

2. **Firestore Database**
   - Go to Firestore Database → Create database
   - Start in test mode
   - Choose your region

3. **Storage** (Optional for now)
   - Go to Storage → Get started
   - Start in test mode

## Run the App

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## Test the App

1. **Register a new account**
   - Open the app
   - Click "Sign Up"
   - Fill in the form
   - Create account

2. **Explore the app**
   - Home: View your dashboard
   - Academics: Browse courses
   - Leaderboard: See rankings
   - Profile: View your stats

## Current Limitations

Since this is a fresh setup:
- No courses in the database yet (you'll see placeholder data)
- Leaderboard shows sample users
- Certificates not yet generated

## Add Sample Courses (Optional)

To populate the app with real data, add courses to Firestore:

1. Go to Firebase Console → Firestore Database
2. Create collection: `courses`
3. Add a document with this structure:

```json
{
  "id": "python_basics",
  "title": "Python for Beginners",
  "description": "Learn Python from scratch",
  "category": "Python",
  "difficulty": "beginner",
  "thumbnailUrl": "",
  "modules": [],
  "projects": [],
  "instructorName": "John Doe",
  "estimatedHours": 20,
  "enrolledCount": 0,
  "rating": 4.5,
  "learningOutcomes": ["Learn Python basics"],
  "prerequisites": [],
  "isFeatured": true
}
```

## Troubleshooting

### "Firebase not initialized" error
- Make sure you ran `flutterfire configure`
- Check if `firebase_options.dart` exists
- Verify `Firebase.initializeApp()` is called in main.dart

### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Try again

### Authentication not working
- Check if Email/Password is enabled in Firebase Console
- Verify internet connection

## Next Steps

1. ✅ Configure Firebase
2. ✅ Run the app
3. ✅ Test authentication
4. 📝 Add sample courses
5. 🎨 Customize the UI
6. 🚀 Deploy to app stores

## Need Help?

- Check [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed Firebase setup
- Check [README.md](README.md) for full documentation
- Check [walkthrough.md](.gemini/antigravity/brain/.../walkthrough.md) for implementation details

---

**Ready to code? Let's go! 🚀**
