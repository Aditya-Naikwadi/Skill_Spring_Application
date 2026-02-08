import 'package:flutter/material.dart';
import '../../models/project_model.dart';
import '../../models/certificate_model.dart';
import '../../models/user_model.dart';
import 'summary_card.dart';

class StatsSection extends StatelessWidget {
  final UserModel? user;
  final List<ProjectModel>? projects;
  final List<CertificateModel>? certificates;

  const StatsSection({
    super.key,
    required this.user,
    required this.projects,
    required this.certificates,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              // Responsive grid: 1 column on very small, 3 on larger
              int crossAxisCount = width < 600 ? 1 : 3;
              double aspectRatio = width < 600 ? 1.3 : 1.2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: aspectRatio,
                children: [
                  SummaryCard(
                    title: 'In Progress',
                    value: '${user?.enrolledCourses.length ?? 0}',
                    subtitle: 'Enrolled Courses',
                    icon: Icons.auto_stories,
                    color: Colors.blueAccent,
                    onTap: () {},
                  ),
                  SummaryCard(
                    title: 'Available',
                    value: '${projects?.length ?? 0}',
                    subtitle: 'Active Projects',
                    icon: Icons.code,
                    color: Colors.greenAccent,
                    onTap: () {},
                  ),
                  SummaryCard(
                    title: 'Achievements',
                    value: '${certificates?.length ?? 0}',
                    subtitle: 'Certificates Earned',
                    icon: Icons.verified,
                    color: Colors.amberAccent,
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
