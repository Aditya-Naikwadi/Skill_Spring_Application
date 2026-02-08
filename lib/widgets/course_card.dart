import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common/hover_scale_button.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final IconData iconData;
  final String category;
  final Color color;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.iconData,
    required this.category,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverScaleButton(
        onPressed: onTap,
        width: null, // Flexible width for Grid
        height: null, // Flexible height
        color: const Color(0xFF161B22), // Dark card background
        isOutlined: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image Area
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.8),
                    color.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Icon as background graphic pattern
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      iconData,
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  // Centered Icon
                  Center(
                    child: Icon(
                      iconData,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  // Category Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Footer: Duration & Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Enroll',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
