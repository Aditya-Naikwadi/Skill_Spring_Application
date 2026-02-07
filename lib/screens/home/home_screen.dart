import 'package:flutter/material.dart';
import '../../widgets/common/hover_scale_button.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/dashboard/summary_card.dart';
import '../../widgets/dashboard/activity_item.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<CourseModel>> _coursesStream;

  @override
  void initState() {
    super.initState();
    // Initialize stream only once with a limit for better performance
    _refreshCourses();
  }

  void _refreshCourses() {
    setState(() {
      _coursesStream = DatabaseService().getCourses('All', limit: 5).timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) {
          sink.addError('Connection timed out. Please check your internet.');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Dark background
      body: CustomScrollView(
        slivers: [
          // Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          Helpers.getInitials(user.displayName),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Helpers.getGreeting(),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Summary Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 170, // Increased height to prevent overflow
                child: Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'In Progress',
                        value: '${user.enrolledCourses.length}',
                        subtitle: 'Courses',
                        icon: Icons.book,
                        color: Colors.blue,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Active',
                        value: '2', // Placeholder for now or fetch from DB
                        subtitle: 'Projects',
                        icon: Icons.code,
                        color: Colors.green,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Earned',
                        value: '12', // Placeholder
                        subtitle: 'Certificates',
                        icon: Icons.verified,
                        color: Colors.amber,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recent Activity Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(color: Colors.blue[400]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recent Activity List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                 ActivityItem( // Mock Data
                  title: 'Completed module: Async/Await',
                  subtitle: 'JavaScript Mastery',
                  time: '2 hours ago',
                  icon: Icons.check_circle_outline,
                  color: Colors.purple,
                ),
                ActivityItem(
                  title: 'Earned badge: Logic Pro',
                  subtitle: 'Python Core',
                  time: 'Yesterday',
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                ),
              ]),
            ),
          ),

           // Recommended Header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            sliver: SliverToBoxAdapter(
              child: const Text(
                'Recommended for You',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Recommended Horizontal List
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: StreamBuilder<List<CourseModel>>(
                stream: _coursesStream, // Use initialized stream
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Connection Error',
                            style: TextStyle(color: Colors.red[300]),
                          ),
                          TextButton(
                            onPressed: _refreshCourses,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final courses = snapshot.data ?? [];
                  if (courses.isEmpty) return const SizedBox.shrink();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 8), // Add bottom padding for shadow
                        child: HoverScaleButton(
                          onPressed: () {
                             // TODO: Navigate to course details
                          },
                          width: 280,
                          height: double.infinity,
                          color: const Color(0xFF161B22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cover Image (or gradient placeholder)
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withValues(alpha: 0.2),
                                      Colors.purple.withValues(alpha: 0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        course.iconData,
                                        size: 48,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    if (course.category == 'Development') // Mock tag
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'FULL STACK', // Mock
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Expanded( // Make valid use of space
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Expanded(
                                        child: Text(
                                          course.description,
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                              const SizedBox(width: 4),
                                              Text(
                                                course.duration,
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(20),
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}
