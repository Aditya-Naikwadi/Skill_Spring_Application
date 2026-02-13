import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/course_model.dart';
import '../../models/project_model.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/stats_section.dart';
import '../../widgets/dashboard/continue_learning.dart';
import '../../widgets/dashboard/featured_courses.dart';
import '../../widgets/dashboard/recent_projects.dart';
import '../../widgets/dashboard/quick_actions_card.dart';
import '../../widgets/common/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = Provider.of<AuthProvider>(context).currentUser;
      if (user != null) {
        Provider.of<DashboardProvider>(context, listen: false).initialize(user.uid);
        _isInitialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), 
        child: Column(
          children: [
            const DashboardHeader(),
            const SizedBox(height: 24),

            if (dashboardProvider.status == DashboardStatus.loading)
              const DashboardShimmer()
            else if (dashboardProvider.status == DashboardStatus.error)
              _buildErrorState(dashboardProvider.errorMessage)
            else
              _buildDashboardContent(user, dashboardProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(UserModel user, DashboardProvider dashboard) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          StatsSection(
            user: user,
            projects: dashboard.projects,
            certificates: dashboard.certificates,
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                           _buildFeaturedCourses(dashboard.courses),
                           const SizedBox(height: 24),
                           _buildRecentProjects(dashboard.projects),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const QuickActionsCard(),
                          const SizedBox(height: 24),
                          _buildContinueLearning(user, dashboard.courses),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildFeaturedCourses(dashboard.courses),
                    const SizedBox(height: 24),
                    const QuickActionsCard(),
                    const SizedBox(height: 24),
                    _buildContinueLearning(user, dashboard.courses),
                    const SizedBox(height: 24),
                    _buildRecentProjects(dashboard.projects),
                    const SizedBox(height: 40),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses(List<CourseModel> courses) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: FeaturedCourses(
        courses: courses,
        onCourseTap: (course) {},
      ),
    );
  }

  Widget _buildRecentProjects(List<ProjectModel> projects) {
    final displayProjects = projects.take(3).toList();
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: RecentProjects(
        projects: displayProjects,
        onProjectTap: (project) {},
      ),
    );
  }

  Widget _buildContinueLearning(UserModel user, List<CourseModel> courses) {
    return FadeInUp(
       delay: const Duration(milliseconds: 300),
       child: ContinueLearning(
        user: user,
        allCourses: courses,
      ),
    );
  }

  Widget _buildErrorState(String? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              error ?? 'An unexpected error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
                if (user != null) {
                  Provider.of<DashboardProvider>(context, listen: false).initialize(user.uid);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}


