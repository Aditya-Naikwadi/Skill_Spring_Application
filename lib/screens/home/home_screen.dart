import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';
import '../../models/project_model.dart';
import '../../models/certificate_model.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/stats_section.dart';
import '../../widgets/dashboard/continue_learning.dart';
import '../../widgets/dashboard/featured_courses.dart';
import '../../widgets/dashboard/recent_projects.dart';
import '../../widgets/dashboard/quick_actions_card.dart';

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

    // Use LayoutBuilder to handle responsive collage
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        // Allow scrolling only if content overflows viewport
        physics: const BouncingScrollPhysics(), 
        child: Column(
          children: [
            // 1. Fixed Header (Glassmorphic)
            const DashboardHeader(),
            
            const SizedBox(height: 24),

            // 2. Bento Grid Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Row 1: Stats Overview (Full Width)
                  StreamBuilder<List<ProjectModel>>(
                    stream: _projectsStream,
                    builder: (context, projectSnapshot) {
                      return StreamBuilder<List<CertificateModel>>(
                        stream: _certificatesStream,
                        builder: (context, certificateSnapshot) {
                          return StatsSection(
                            user: user,
                            projects: projectSnapshot.data,
                            certificates: certificateSnapshot.data,
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Row 2: Main Content Area (Split View)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Desktop/Tablet: Split Row
                      if (constraints.maxWidth > 900) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Courses & Projects) - Flex 2
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                   _buildFeaturedCoursesStream(),
                                   const SizedBox(height: 24),
                                   _buildRecentProjectsStream(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right Column (Continue Learning & Quick Actions) - Flex 1
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  const QuickActionsCard(),
                                  const SizedBox(height: 24),
                                  _buildContinueLearningStream(user),
                                ],
                              ),
                            ),
                          ],
                        );
                      } 
                      
                      // Mobile: Stacked Column
                      else {
                        return Column(
                          children: [
                            _buildFeaturedCoursesStream(),
                            const SizedBox(height: 24),
                            const QuickActionsCard(),
                            const SizedBox(height: 24),
                            _buildContinueLearningStream(user),
                            const SizedBox(height: 24),
                            _buildRecentProjectsStream(),
                            const SizedBox(height: 40), // Bottom padding
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCoursesStream() {
    return StreamBuilder<List<CourseModel>>(
      stream: _coursesStream,
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];
        return FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: FeaturedCourses(
            courses: courses,
            onCourseTap: (course) {
              // Navigator.pushNamed(context, '/course', arguments: course);
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentProjectsStream() {
    return StreamBuilder<List<ProjectModel>>(
      stream: _projectsStream,
      builder: (context, snapshot) {
        final projects = snapshot.data ?? [];
        // Limit to 3 projects for the collage view
        final displayProjects = projects.take(3).toList();
        return FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: RecentProjects(
            projects: displayProjects,
            onProjectTap: (project) {},
          ),
        );
      },
    );
  }

  Widget _buildContinueLearningStream(user) {
    return StreamBuilder<List<CourseModel>>(
      stream: _coursesStream,
      builder: (context, snapshot) {
        return FadeInUp(
           delay: const Duration(milliseconds: 300),
           child: ContinueLearning(
            user: user,
            allCourses: snapshot.data ?? [],
          ),
        );
      },
    );
  }
}


