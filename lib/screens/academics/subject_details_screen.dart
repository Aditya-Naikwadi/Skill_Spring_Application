import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';
import '../../models/project_model.dart';
import '../../models/certificate_program_model.dart';
import '../courses/course_details_screen.dart';
import '../projects/project_details_screen.dart'; // Import

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
      appBar: AppBar(
        title: Text('$category - $type'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (type) {
      case 'Courses':
        return StreamBuilder<List<CourseModel>>(
          stream: DatabaseService().getCourses(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const Center(child: Text('No courses available yet.'));

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) => _buildCourseCard(context, items[index]),
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
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            final items = snapshot.data ?? [];
            if (items.isEmpty) return const Center(child: Text('No projects available yet.'));

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

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          child: Icon(course.iconData, color: AppTheme.primaryColor),
        ),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(course.description),
            const SizedBox(height: 8),
            Row(
              children: [
                _chip(course.difficulty, Colors.orange),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.withValues(alpha: 0.1),
          child: Icon(project.iconData, color: Colors.purple),
        ),
        title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: 4),
            Text(project.description),
            const SizedBox(height: 8),
             Row(
              children: [
                _chip(project.difficulty, Colors.orange),
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

  Widget _buildCertificateCard(CertificateProgramModel cert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withValues(alpha: 0.1),
          child: Icon(cert.iconData, color: Colors.amber[800]),
        ),
        title: Text(cert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const SizedBox(height: 4),
            Text(cert.description),
            const SizedBox(height: 4),
            Text('Provider: ${cert.provider}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
             const SizedBox(height: 8),
             Row(
              children: [
                 _chip(cert.duration, Colors.blue),
              ],
            ),
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
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
