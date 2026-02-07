import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Learn to Code\nSmarter',
      description:
          'Master modern programming languages with interactive, bite-sized lessons designed for the future of engineering.',
      icon: Icons.code, // Placeholder for 3D asset
      accentColor: const Color(0xFF2196F3), // Blue
    ),
    OnboardingContent(
      title: 'Practice Anywhere',
      description:
          'Our mobile-first IDE and interactive playground let you write, test, and run code right from your pocket.',
      icon: Icons.terminal, // Placeholder for 3D asset
      accentColor: const Color(0xFF03A9F4), // Light Blue
    ),
    OnboardingContent(
      title: 'Track Your Progress',
      description:
          'Earn gamified rewards as you complete lessons and climb the global leaderboards with developers worldwide.',
      icon: Icons.emoji_events, // Placeholder for 3D asset
      accentColor: const Color(0xFF2196F3), // Blue
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Dark background
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1117),
                  Color(0xFF161B22),
                ],
              ),
            ),
          ),

          // Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              return _buildPage(_contents[index]);
            },
          ),

          // Check for "Skip" button
          Positioned(
            top: 50,
            right: 20,
            child: FadeInRight(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _contents.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: _currentPage == index ? 24 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF2196F3)
                            : Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Button
                FadeInUp(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: const Color(0xFF2196F3).withValues(alpha: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _contents.length - 1
                                ? 'Get Started'
                                : 'Continue',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (_currentPage == _contents.length - 1) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.rocket_launch, size: 20),
                          ] else ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final double imageSize = isSmallScreen ? 240.0 : 300.0;
    final double iconSize = isSmallScreen ? 80.0 : 100.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height - 100, // Account for bottom controls/padding
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isSmallScreen ? 40 : 80), // Top spacing
            
            // Image / Icon Placeholder with Glassmorphism
            ZoomIn(
              duration: const Duration(milliseconds: 800),
              child: SizedBox(
                height: imageSize,
                width: imageSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                     // Glow effect
                    Container(
                      width: imageSize * 0.7,
                      height: imageSize * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: content.accentColor.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: content.accentColor.withValues(alpha: 0.4),
                            blurRadius: 100,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    // Glass Card simulation
                    GlassmorphicContainer(
                      width: imageSize * 0.8,
                      height: imageSize * 1.06,
                      borderRadius: 20,
                      blur: 20,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          content.icon,
                          size: iconSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Floating elements for "3D" feel
                     Positioned(
                      top: 20,
                      right: 20,
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.code, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                     Positioned(
                      bottom: 40,
                      left: -10,
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 600),
                         child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                             border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: const Icon(Icons.data_object, color: Colors.cyanAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 32 : 64),
            
            // Title
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Text(
                content.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                content.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : 16,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
             SizedBox(height: isSmallScreen ? 80 : 120), // Bottom spacing for controls
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
