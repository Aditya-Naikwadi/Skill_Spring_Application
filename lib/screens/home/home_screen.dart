import 'package:flutter/material.dart';
import '../../widgets/course_card.dart';
import '../../widgets/common/entry_animation.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/dashboard/summary_card.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../../models/project_model.dart';
import '../../models/certificate_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<CourseModel>> _coursesStream;
  late Stream<List<ProjectModel>> _projectsStream;
  late Stream<List<CertificateModel>> _certificatesStream;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _coursesStream = DatabaseService().getCourses('All');
    _projectsStream = DatabaseService().getProjects('All');
    if (user != null) {
      _certificatesStream = DatabaseService().getUserCertificates(user.uid);
    } else {
      _certificatesStream = Stream.value([]);
    }
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            slivers: [
              // 1. Glassmorphism Sticky Header
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF0D1117).withValues(alpha: 0.85),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.0,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          Helpers.getInitials(user.displayName),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Helpers.getGreeting(),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14, // Increased size slightly for better readability
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              Helpers.getFirstName(user.displayName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24, // Matches design better
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                          const Color(0xFF0D1117),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  _buildHeaderIcon(Icons.search, () {}),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(Icons.notifications_none, () {}),
                  const SizedBox(width: 24),
                ],
              ),

              // 2. Real-Time Counts in Single Row (Responsive)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    delay: const Duration(milliseconds: 100),
                    child: SizedBox(
                      height: 160, // Fixed height for uniformity
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Enrolled Courses (Real-time from User Model)
                          Expanded(
                            child: SummaryCard(
                              title: 'Enrolled',
                              value: '${user.enrolledCourses.length}',
                              subtitle: 'Courses',
                              icon: Icons.auto_stories,
                              color: Colors.blue,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Projects (Real-time Count from DB)
                          Expanded(
                            child: StreamBuilder<List<ProjectModel>>(
                              stream: _projectsStream,
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return SummaryCard(
                                  title: 'Available',
                                  value: '$count',
                                  subtitle: 'Projects', // Or "Active Projects" if we filter
                                  icon: Icons.code,
                                  color: Colors.green,
                                  onTap: () {},
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Certificates (Real-time Count from DB)
                          Expanded(
                            child: StreamBuilder<List<CertificateModel>>(
                              stream: _certificatesStream,
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return SummaryCard(
                                  title: 'Earned',
                                  value: '$count',
                                  subtitle: 'Certificates',
                                  icon: Icons.verified,
                                  color: Colors.amber,
                                  onTap: () {},
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 3. Course Gallery Header
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    delay: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Course Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         // Filter/Sort Option could go here
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white10),
                          ),
                           child: Row(
                             children: [
                               Icon(Icons.filter_list, size: 16, color: Colors.grey[400]),
                               const SizedBox(width: 6),
                               Text('All', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                             ],
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Course Gallery Grid
              StreamBuilder<List<CourseModel>>(
                stream: _coursesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(child: Center(child: Text('Error: ${snapshot.error}')));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                  }

                  final courses = snapshot.data ?? [];
                  if (courses.isEmpty) {
                    return const SliverToBoxAdapter(child: Center(child: Text('No courses available', style: TextStyle(color: Colors.white)))); 
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 350, // Responsive grid
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.85, // Adjust card height ratio
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final course = courses[index];
                          final icon = _getCourseIcon(course.title);
                          final color = _getCourseColor(course.category);
                          
                          return EntryAnimatedWidget(
                            delay: Duration(milliseconds: 100 + (index * 50).clamp(0, 1000)), // Staggered
                            child: CourseCard(
                              title: course.title,
                              description: course.description,
                              duration: course.duration,
                              iconData: icon,
                              category: course.category,
                              color: color,
                              onTap: () {
                                // Navigate to course details
                              },
                            ),
                          );
                        },
                        childCount: courses.length,
                      ),
                    ),
                  );
                },
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
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
