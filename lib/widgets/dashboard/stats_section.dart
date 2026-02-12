import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeInLeft(
            child: const Text(
              'Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140, // Fixed height for the scrollable row
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: SummaryCard(
                  title: 'In Progress',
                  value: '${user?.enrolledCourses.length ?? 0}',
                  subtitle: 'Enrolled Courses',
                  icon: Icons.auto_stories,
                  color: Colors.blueAccent,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 500),
                child: SummaryCard(
                  title: 'Available',
                  value: '${projects?.length ?? 0}',
                  subtitle: 'Active Projects',
                  icon: Icons.code,
                  color: Colors.greenAccent,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: SummaryCard(
                  title: 'Achievements',
                  value: '${certificates?.length ?? 0}',
                  subtitle: 'Certificates Earned',
                  icon: Icons.verified,
                  color: Colors.amberAccent,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              FadeInUp(
                 delay: const Duration(milliseconds: 300),
                 duration: const Duration(milliseconds: 500),
                 child: SummaryCard(
                   title: 'Total XP',
                   value: '${user?.points ?? 0}',
                   subtitle: 'Experience Points',
                   icon: Icons.bolt,
                   color: Colors.purpleAccent,
                   onTap: () {},
                 ),
               ),
            ],
          ),
        ),
      ],
    );
  }
}
