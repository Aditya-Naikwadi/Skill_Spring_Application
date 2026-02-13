import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';
import '../../models/project_model.dart';
import '../../models/certificate_program_model.dart';
import '../courses/course_details_screen.dart';
import '../projects/project_details_screen.dart';
import '../../data/curriculum_data.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final String category;
  final String type; // 'Courses', 'Projects', 'Certificates'

  const SubjectDetailsScreen({
    super.key,
    required this.category,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Text('$category - $type'),
        backgroundColor: const Color(0xFF161B22),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final curriculum = CurriculumData.subjects[category];

    switch (type) {
      case 'Courses':
        return StreamBuilder<List<CourseModel>>(
          stream: DatabaseService().getCourses(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            // Use local curriculum as priority/fallback
            final List<CourseModel> items = [];
            if (curriculum != null) {
              items.addAll(curriculum.courses);
            }
            
            // Add Firestore data (avoiding duplicates by title)
            if (snapshot.hasData) {
              for (var course in snapshot.data!) {
                if (!items.any((e) => e.title == course.title)) {
                  items.add(course);
                }
              }
            }

            if (items.isEmpty) return const Center(child: Text('No courses available yet.', style: TextStyle(color: Colors.white)));

            // Sort by difficulty: Beginner -> Intermediate -> Expert
            items.sort((a, b) {
              const weights = {'Beginner': 0, 'Basic': 0, 'Intermediate': 1, 'Expert': 2};
              return (weights[a.difficulty] ?? 3).compareTo(weights[b.difficulty] ?? 3);
            });

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final course = items[index];
                final isCurriculum = curriculum?.courses.any((c) => c.title == course.title) ?? false;
                return _buildCourseCard(context, course, isCurriculum);
              },
            );
          },
        );
      case 'Projects':
        return StreamBuilder<List<ProjectModel>>(
          stream: DatabaseService().getProjects(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<ProjectModel> items = [];
            if (curriculum != null) {
              items.addAll(curriculum.projects);
            }

            if (snapshot.hasData) {
              for (var project in snapshot.data!) {
                if (!items.any((e) => e.title == project.title)) {
                  items.add(project);
                }
              }
            }

            if (items.isEmpty) return const Center(child: Text('No projects available yet.', style: TextStyle(color: Colors.white)));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildProjectCard(context, items[index]),
            );
          },
        );
      case 'Certificates':
        return StreamBuilder<List<CertificateProgramModel>>(
          stream: DatabaseService().getCertificatePrograms(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const Center(child: Text('No certificate programs available yet.'));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildCertificateCard(items[index]),
            );
          },
        );
      default:
        return const Center(child: Text('Invalid Type'));
    }
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course, bool isCurriculum) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurriculum ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.white10,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(course.iconData, color: AppTheme.primaryColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                course.title,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            if (isCurriculum)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Expert-Led', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10)),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(course.description, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 12),
            Row(
              children: [
                _chip(course.difficulty, _getDifficultyColor(course.difficulty)),
                const SizedBox(width: 8),
                _chip(course.duration, Colors.blue),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsScreen(course: course),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(project.iconData, color: Colors.purple),
        ),
        title: Text(
          project.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(project.description, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 12),
            Row(
              children: [
                _chip(project.difficulty, _getDifficultyColor(project.difficulty)),
                const SizedBox(width: 8),
                _chip(project.estimatedTime, Colors.green),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailsScreen(project: project),
            ),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
      case 'basic':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'expert':
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildCertificateCard(CertificateProgramModel cert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withValues(alpha: 0.1),
          child: Icon(cert.iconData, color: Colors.amber[800]),
        ),
        title: Text(cert.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(cert.description, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 4),
            Text('Provider: ${cert.provider}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 8),
            _chip(cert.duration, Colors.blue),
          ],
        ),
        onTap: () {
          // Navigate to certificate details
        },
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
