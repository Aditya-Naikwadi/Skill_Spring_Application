import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../utils/helpers.dart';
import '../../providers/auth_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) return const SizedBox.shrink();

    return GlassmorphicContainer(
      width: double.infinity,
      height: 140 + MediaQuery.of(context).padding.top,
      borderRadius: 0,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF161B22).withValues(alpha: 0.8),
          const Color(0xFF161B22).withValues(alpha: 0.6),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.01),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24, 
          MediaQuery.of(context).padding.top + 20, 
          24, 
          24
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with Pulse Animation
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Glowing background effect
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF21262D),
                    child: Text(
                      Helpers.getInitials(user.displayName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FadeIn(
                      delay: const Duration(milliseconds: 800),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF161B22),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withValues(alpha: 0.5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Greeting & Motivation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      Helpers.getGreeting(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Welcome back, ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins', 
                            ),
                          ),
                          TextSpan(
                            text: Helpers.getFirstName(user.displayName),
                            style: const TextStyle(
                              color: Colors.blueAccent, // Highlight name
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Notification / Search Actions
            FadeInRight(
              duration: const Duration(milliseconds: 600),
              child: Row(
                children: [
                  _buildGlassButton(
                    icon: Icons.search_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _buildGlassButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {},
                    hasBadge: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return Stack(
      children: [
        GlassmorphicContainer(
          width: 44,
          height: 44,
          borderRadius: 12,
          blur: 10,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
