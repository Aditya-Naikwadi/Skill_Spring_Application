import 'package:flutter/material.dart';
import '../../models/course_model.dart';
import '../course_card.dart';
import 'package:animate_do/animate_do.dart';

class FeaturedCourses extends StatefulWidget {
  final List<CourseModel> courses;
  final Function(CourseModel) onCourseTap;

  const FeaturedCourses({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  State<FeaturedCourses> createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85); // Peek effect
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courses.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInLeft(
                child: const Text(
                  'Featured Courses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              FadeInRight(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 340, // Height for course cards + potential shadow/scaling
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.courses.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                  } else {
                    // Initial state for first item
                    value = index == 0 ? 1.0 : 0.9;
                  }
                  
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 340,
                      width: Curves.easeOut.transform(value) * 400,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CourseCard(
                    title: widget.courses[index].title,
                    description: widget.courses[index].description,
                    duration: widget.courses[index].duration,
                    iconData: _getCourseIcon(widget.courses[index].title),
                    category: widget.courses[index].category,
                    color: _getCourseColor(widget.courses[index].category),
                    onTap: () => widget.onCourseTap(widget.courses[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.courses.length > 5 ? 5 : widget.courses.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: _currentPage == index ? 24 : 8, // Active indicator is wider
              decoration: BoxDecoration(
                color: _currentPage == index 
                    ? Colors.blueAccent 
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helpers
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
