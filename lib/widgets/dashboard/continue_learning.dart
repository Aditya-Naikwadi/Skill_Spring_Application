import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/course_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ContinueLearning extends StatelessWidget {
  final UserModel? user;
  final List<CourseModel> allCourses;

  const ContinueLearning({
    super.key,
    required this.user,
    required this.allCourses,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null || user!.enrolledCourses.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the last enrolled course (mock logic: just take the first one or latest)
    // Ideally we'd have a 'lastAccessed' timestamp.
    final lastCourseId = user!.enrolledCourses.last; 
    final course = allCourses.firstWhere(
      (c) => c.id == lastCourseId,
      orElse: () => CourseModel(
        id: '', 
        title: 'Unknown Course', 
        description: '', 
        duration: '', 
        category: '', 
        difficulty: 'Beginner',
        iconCode: '57347',
        createdAt: DateTime.now(),
      ),
    );

    if (course.id.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Continue Learning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1C2128),
                   const Color(0xFF161B22),
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Course Icon/Image Placeholder
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 30),
                ),
                const SizedBox(width: 16),
                
                // Course Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Progress Bar
                       ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.45, // Mock progress
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                          minHeight: 6,
                        ),
                      ),
                       const SizedBox(height: 6),
                      Text(
                        '45% Completed',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Play Button
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      // Navigate to course
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
