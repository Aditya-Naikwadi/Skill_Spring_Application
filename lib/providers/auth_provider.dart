import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/exceptions/auth_failure.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAuthCheckComplete = false;
  bool _isRegistrationInProgress = false; // Flag to prevent race condition
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthCheckComplete => _isAuthCheckComplete;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _authService.initialize();
    _initAuth();
  }

  // Initialize auth state listener
  void _initAuth() {
    bool initialCheckCompleted = false;

    // Safety timeout: if Firebase doesn't respond in 10 seconds, assume offline/logged out
    Future.delayed(const Duration(seconds: 10), () {
      if (!initialCheckCompleted) {
        _isAuthCheckComplete = true;
        initialCheckCompleted = true;
        notifyListeners();
      }
    });

    _authService.authStateChanges.listen((User? user) async {
      if (_isRegistrationInProgress) return; // Skip listener during explicit registration

      if (initialCheckCompleted) {
        // Just update user if check already completed via timeout or previous event
        if (user != null) {
          await _loadUserData(user.uid);
        } else {
          _currentUser = null;
        }
        notifyListeners();
        return;
      }

      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
      }
      _isAuthCheckComplete = true;
      initialCheckCompleted = true;
      notifyListeners();
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

  int _loginAttempts = 0;
  DateTime? _lockoutUntil;

  // Sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    if (_lockoutUntil != null && DateTime.now().isBefore(_lockoutUntil!)) {
      _error = 'Too many attempts. Try again later.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmail(email, password);
      _isLoading = false;
      _loginAttempts = 0; // Reset on success
      _lockoutUntil = null;
      notifyListeners();
      return _currentUser != null;
    } on AuthFailure catch (e) {
      // Logic for lockout handling remains similar or can use e.code
      _loginAttempts++;
      if (_loginAttempts >= 5) {
        _lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
        _error = 'Too many failed attempts. Locked for 5 minutes.';
      } else {
        _error = e.message;
      }
      _isLoading = false;
      notifyListeners();
      return false;
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
    _isRegistrationInProgress = true; // Start critical section
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
    } finally {
      _isRegistrationInProgress = false; // End critical section
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
