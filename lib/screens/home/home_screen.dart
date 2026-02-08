import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import '../../widgets/dashboard/recent_certificates.dart';
import '../../widgets/common/entry_animation.dart';

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
      backgroundColor: const Color(0xFF0D1117),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // 1. Sticky Header
              SliverAppBar(
                expandedHeight: 160.0,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF0D1117).withValues(alpha: 0.95),
                flexibleSpace: const FlexibleSpaceBar(
                  background: DashboardHeader(),
                ),
              ),

              // 2. Stats Section
              SliverPadding(
                padding: const EdgeInsets.only(top: 24),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    child: StreamBuilder<List<ProjectModel>>(
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
                  ),
                ),
              ),

              // 3. Continue Learning
              SliverToBoxAdapter(
                child: EntryAnimatedWidget(
                  delay: const Duration(milliseconds: 100),
                  child: StreamBuilder<List<CourseModel>>(
                    stream: _coursesStream,
                    builder: (context, snapshot) {
                      return ContinueLearning(
                        user: user,
                        allCourses: snapshot.data ?? [],
                      );
                    },
                  ),
                ),
              ),

              // 4. Featured Courses (Horizontal Gallery)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    delay: const Duration(milliseconds: 200),
                    child: StreamBuilder<List<CourseModel>>(
                      stream: _coursesStream,
                      builder: (context, snapshot) {
                        final courses = snapshot.data ?? [];
                        return FeaturedCourses(
                          courses: courses,
                          onCourseTap: (course) {
                            // Navigate to course details
                            // Navigator.pushNamed(context, '/course', arguments: course);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 5. Recent Projects
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    delay: const Duration(milliseconds: 300),
                    child: StreamBuilder<List<ProjectModel>>(
                      stream: _projectsStream,
                      builder: (context, snapshot) {
                        return RecentProjects(
                          projects: snapshot.data ?? [],
                          onProjectTap: (project) {
                            // Navigate to project details
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 6. Recent Certificates
              SliverPadding(
                padding: const EdgeInsets.only(top: 24, bottom: 40),
                sliver: SliverToBoxAdapter(
                  child: EntryAnimatedWidget(
                    delay: const Duration(milliseconds: 400),
                    child: StreamBuilder<List<CertificateModel>>(
                      stream: _certificatesStream,
                      builder: (context, snapshot) {
                        return RecentCertificates(
                          certificates: snapshot.data ?? [],
                          onCertificateTap: (certificate) {
                            // View certificate
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 7. Spacer for bottom nav
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
    );
  }
}


