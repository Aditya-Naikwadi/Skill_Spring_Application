import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user (Note: May be null if using REST auth without custom token sign-in)
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = result.user;
      if (user != null) {
        // Fetch user data from Firestore
        final userParams = await getUserData(user.uid);
        
        if (userParams != null) {
          // Update last login time
          await _firestore.collection('users').doc(user.uid).update({
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
          return userParams;
        }

        // Fallback: Return basic model if Firestore data doesn't exist yet
        return UserModel(
          uid: user.uid,
          email: user.email ?? email,
          displayName: user.displayName ?? 'Student',
          institution: 'Skill Spring University',
          role: UserRole.student,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Login failed: ${e.toString()}';
    }
  }

  // Register new user
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String displayName,
    required String institution,
    String? phoneNumber,
    UserRole role = UserRole.student,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Create user document in Firestore
        final UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          phoneNumber: phoneNumber,
          displayName: displayName,
          role: role,
          institution: institution,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Upload to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        
        // Update display name in Auth
        await user.updateDisplayName(displayName);

        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Registration failed: ${e.toString()}';
    }
  }

  // Sign in with phone number (requires verification)
  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String verificationId, int? resendToken) codeSent,
    Function(FirebaseAuthException e) verificationFailed,
  ) async {
      // Logic unchanged for now, might need REST equiv if SDK fails
      try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: verificationFailed,
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw 'Failed to verify phone number. Please try again.';
    }
  }

  // Verify phone OTP
  Future<UserModel?> verifyPhoneOTP(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential result =
          await _auth.signInWithCredential(credential);

      if (result.user != null) {
        return await getUserData(result.user!.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Invalid verification code. Please try again.';
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 5));

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      // Fallback for demo/testing if firestore fails
      debugPrint('Firestore Error or Timeout: $e'); 
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toMap());
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send reset email. Please try again.';
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        await _firestore.collection('leaderboard').doc(user.uid).delete();

        // Delete user from Firebase Auth
        await user.delete();
      }
    } catch (e) {
      throw 'Failed to delete account. Please try again.';
    }
  }

  // Handle Firebase Auth exceptions (kept for legacy/SDK calls)
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
