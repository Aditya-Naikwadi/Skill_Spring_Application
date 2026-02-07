import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../screens/onboarding/onboarding_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole>? allowedRoles;

  const AuthGuard({
    super.key,
    required this.child,
    this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // 0. Check if auth check is complete
        if (!auth.isAuthCheckComplete) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 1. Check if authenticated
        if (!auth.isAuthenticated) {
          // If not authenticated, redirect to Onboarding/Login
          return const OnboardingScreen();
        }

        // 2. Check Role (if specified)
        if (allowedRoles != null && allowedRoles!.isNotEmpty) {
          final userRole = auth.currentUser?.role;
          if (userRole == null || !allowedRoles!.contains(userRole)) {
            // User doesn't have required role
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Access Denied',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('You do not have permission to view this page.'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                      child: const Text('Go Home'),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        // 3. Allowed
        return child;
      },
    );
  }
}
