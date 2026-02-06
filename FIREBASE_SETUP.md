# SkillSpring - Firebase Setup Guide

## Prerequisites
- Flutter SDK installed
- Firebase account created
- Firebase CLI installed (`npm install -g firebase-tools`)
- FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **SkillSpring**
4. Enable Google Analytics (optional)
5. Create project

## Step 2: Configure Firebase for Flutter

Run the following command in your project directory:

```bash
flutterfire configure
```

This will:
- Create `firebase_options.dart` file
- Configure Firebase for Android and iOS
- Add necessary configuration files

## Step 3: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get started"
3. Enable sign-in methods:
   - **Email/Password** - Enable
   - **Phone** - Enable (optional, requires additional setup)

## Step 4: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose a location closest to your users
5. Click "Enable"

### Firestore Security Rules (for development):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Courses collection
    match /courses/{courseId} {
      allow read: if true; // Public read
      allow write: if request.auth != null; // Authenticated write
    }
    
    // Leaderboard collection
    match /leaderboard/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Progress collection
    match /progress/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Certificates collection
    match /certificates/{certId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Step 5: Set Up Firebase Storage

1. In Firebase Console, go to **Storage**
2. Click "Get started"
3. Start in **test mode** (for development)
4. Click "Done"

### Storage Security Rules (for development):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile_pictures/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /certificates/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /course_thumbnails/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    match /course_videos/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /study_materials/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Step 6: Add Sample Data to Firestore

You can add sample courses manually through Firebase Console or use the following structure:

### Sample Course Document (courses collection):

```json
{
  "id": "python_beginners",
  "title": "Python for Beginners",
  "description": "Learn Python programming from scratch with hands-on projects",
  "category": "Python",
  "difficulty": "beginner",
  "thumbnailUrl": "",
  "modules": [
    {
      "id": "module_1",
      "title": "Introduction to Python",
      "description": "Get started with Python basics",
      "order": 1,
      "durationMinutes": 120,
      "topics": ["Variables", "Data Types", "Operators"]
    }
  ],
  "projects": [
    {
      "id": "project_1",
      "title": "Calculator App",
      "description": "Build a simple calculator",
      "difficulty": "Beginner",
      "estimatedHours": 2,
      "steps": ["Create UI", "Add logic", "Test"],
      "resources": []
    }
  ],
  "instructorName": "Dr. John Smith",
  "estimatedHours": 40,
  "enrolledCount": 1200,
  "rating": 4.8,
  "learningOutcomes": [
    "Understand Python syntax",
    "Write basic programs",
    "Work with data structures"
  ],
  "prerequisites": [],
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z",
  "isFeatured": true
}
```

## Step 7: Update main.dart

After running `flutterfire configure`, update your `main.dart`:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## Step 8: Test the App

1. Run the app:
   ```bash
   flutter run
   ```

2. Test authentication:
   - Register a new user
   - Login with credentials
   - Check Firebase Console > Authentication for the new user

3. Verify Firestore:
   - Check if user document is created in `users` collection
   - Check if leaderboard entry is created

## Troubleshooting

### Common Issues:

1. **Firebase not initialized error**
   - Make sure `flutterfire configure` was run successfully
   - Check if `firebase_options.dart` exists
   - Verify Firebase.initializeApp() is called before runApp()

2. **Authentication errors**
   - Verify Email/Password is enabled in Firebase Console
   - Check internet connection
   - Review error messages in console

3. **Firestore permission denied**
   - Update security rules to allow read/write
   - Make sure user is authenticated

4. **Android build errors**
   - Update `android/app/build.gradle` minSdkVersion to 21
   - Add `multiDexEnabled true` if needed

## Production Deployment

Before deploying to production:

1. **Update Security Rules** - Make them more restrictive
2. **Enable App Check** - Protect against abuse
3. **Set up Billing** - Monitor usage and costs
4. **Add Indexes** - For complex queries
5. **Enable Crashlytics** - Monitor app crashes

## Next Steps

- Add more sample courses to Firestore
- Implement course enrollment functionality
- Add video player for course videos
- Implement certificate generation
- Set up push notifications

## Support

For issues or questions:
- Firebase Documentation: https://firebase.google.com/docs
- FlutterFire Documentation: https://firebase.flutter.dev/
- SkillSpring GitHub Issues: [Your repo URL]
