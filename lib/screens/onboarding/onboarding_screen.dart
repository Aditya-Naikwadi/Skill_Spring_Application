import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/hover_scale_button.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth > 800; // Define breakpoint for "wide" screens
          return Stack(
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

              // Animated Particles/Background Elements (Optional enhancement)
              // We could add animated circles here for more visuals if requested.

              // Content
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    children: [
                      if (isWide)
                        // On wide screens, maybe show image on left/right or keep centered?
                        // For now, keeping the PageView centered but constrained is safer.
                        // Actually, let's keep the PageView full width but constrained max width.
                        const Spacer(),
                      
                      Expanded(
                        flex: isWide ? 8 : 1,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _contents.length,
                          itemBuilder: (context, index) {
                            return _buildPage(_contents[index], constraints);
                          },
                        ),
                      ),
                      
                      if (isWide) const Spacer(),
                    ],
                  ),
                ),
              ),

              // Skip Button
              Positioned(
                top: 40,
                right: 32,
                child: FadeInRight(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Controls
              Positioned(
                bottom: isWide ? 60 : 40,
                left: 0,
                right: 0,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Page Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _contents.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: _currentPage == index ? 32 : 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? const Color(0xFF2196F3)
                                      : Colors.grey.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: _currentPage == index
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF2196F3)
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Action Button
                          FadeInUp(
                            key: ValueKey('btn_$_currentPage'), // Re-animate on page change? No, better keep static
                            child: SizedBox(
                              width: isWide ? 300 : double.infinity,
                              height: 56,
                              child: HoverScaleButton(
                                onPressed: _onNext,
                                color: const Color(0xFF2196F3),
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
                                    const SizedBox(width: 12),
                                    Icon(
                                      _currentPage == _contents.length - 1
                                          ? Icons.rocket_launch
                                          : Icons.arrow_forward,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPage(OnboardingContent content, BoxConstraints constraints) {
    final isWebOrLarge = constraints.maxWidth > 600;
    final double imageSize = isWebOrLarge ? 380.0 : 280.0;
    final double iconSize = isWebOrLarge ? 120.0 : 90.0;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: 24.0, vertical: isWebOrLarge ? 40 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                      borderRadius: 24,
                      blur: 30,
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
                        child: index == 0 
                          ? Image.asset(
                              'assets/images/logo.png',
                              width: imageSize * 0.6,
                              height: imageSize * 0.6,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              content.icon,
                              size: iconSize,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ),
                    // Floating elements for "3D" feel
                    Positioned(
                      top: 30,
                      right: 30,
                      child: FadeInDown(
                        delay: const Duration(milliseconds: 400),
                        child: FloatingItem(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Icon(Icons.code,
                                color: Colors.blueAccent, size: 28),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        child: FloatingItem(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Icon(Icons.data_object,
                                color: Colors.cyanAccent, size: 28),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 64),

            // Title
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isWebOrLarge ? 42 : 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                        color: content.accentColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Description
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isWebOrLarge ? 18 : 16,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120), // Bottom spacing for controls
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



class FloatingItem extends StatefulWidget {
  final Widget child;
  const FloatingItem({super.key, required this.child});

  @override
  State<FloatingItem> createState() => _FloatingItemState();
}

class _FloatingItemState extends State<FloatingItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}

