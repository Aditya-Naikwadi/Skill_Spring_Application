import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initAuth();
  }

  // Initialize auth state listener
  void _initAuth() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Load user data
  Future<void> _loadUserData(String uid) async {
    try {
      _currentUser = await _authService.getUserData(uid);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String displayName,
    required String institution,
    String? phoneNumber,
    UserRole role = UserRole.student,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.registerUser(
        email: email,
        password: password,
        displayName: displayName,
        institution: institution,
        phoneNumber: phoneNumber,
        role: role,
      );
      _isLoading = false;
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
