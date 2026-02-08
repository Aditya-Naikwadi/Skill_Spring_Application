import 'package:flutter/material.dart';
import '../../models/course_model.dart';
import '../course_card.dart';

class FeaturedCourses extends StatelessWidget {
  final List<CourseModel> courses;
  final Function(CourseModel) onCourseTap;

  const FeaturedCourses({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Courses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full gallery
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320, // Height for course cards
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final course = courses[index];
              return SizedBox(
                width: 260, // Fixed width for horizontal list
                child: CourseCard(
                  title: course.title,
                  description: course.description,
                  duration: course.duration,
                  iconData: _getCourseIcon(course.title),
                  category: course.category,
                  color: _getCourseColor(course.category),
                  onTap: () => onCourseTap(course),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helpers (Duplicated from HomeScreen for now, could be moved to utils)
  IconData _getCourseIcon(String title) {
    if (title.contains('React')) return Icons.code;
    if (title.contains('Python')) return Icons.terminal;
    if (title.contains('Design')) return Icons.brush;
    return Icons.school;
  }

  Color _getCourseColor(String category) {
    if (category == 'Development') return Colors.blue;
    if (category == 'Design') return Colors.purple;
    if (category == 'Business') return Colors.orange;
    return Colors.teal;
  }
}
