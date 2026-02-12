import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import 'access_denied_view.dart';

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
            return const AccessDeniedView();
          }
        }

        // 3. Allowed
        return child;
      },
    );
  }
}
