import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/exceptions/auth_failure.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthService();

  // Initialize Auth Persistence (Call this before other ops)
  Future<void> initialize() async {
    if (kIsWeb) {
       try {
        await _auth.setPersistence(Persistence.LOCAL);
      } catch (e) {
        debugPrint('Auth Persistence Error: $e');
      }
    }
  }

  // Get current user (Note: May be null if using REST auth without custom token sign-in)
  User? get currentUser => _auth.currentUser;

  // ... (rest of the file until getUserData)

  // Get user data from Firestore with Fallback
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 4)); // Reduced timeout

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Firestore Error or Timeout: $e');
      // FALLBACK: Do not return null (which logs user out).
      // Return a basic model derived from FirebaseAuth info so user stays logged in.
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
         return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'Student',
          institution: 'Skill Spring University', // Default
          role: UserRole.student, // Default
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
      }
    }
    return null;
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
  AuthFailure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthFailure('No user found with this email.', e.code);
      case 'wrong-password':
        return AuthFailure('Incorrect password. Please try again.', e.code);
      case 'email-already-in-use':
        return AuthFailure('An account already exists with this email.', e.code);
      case 'invalid-email':
        return AuthFailure('Please enter a valid email address.', e.code);
      case 'weak-password':
        return AuthFailure('Password is too weak. Please use a stronger password.', e.code);
      case 'user-disabled':
        return AuthFailure('This account has been disabled.', e.code);
      case 'too-many-requests':
        return AuthFailure('Too many attempts. Please try again later.', e.code);
      case 'operation-not-allowed':
        return AuthFailure('This sign-in method is not enabled.', e.code);
      case 'invalid-verification-code':
        return AuthFailure('Invalid verification code. Please try again.', e.code);
      case 'invalid-verification-id':
        return AuthFailure('Invalid verification ID. Please try again.', e.code);
      default:
        return AuthFailure('An error occurred. Please try again.', e.code);
    }
  }
}
