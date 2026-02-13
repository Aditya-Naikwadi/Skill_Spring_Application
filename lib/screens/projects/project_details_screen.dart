import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/project_model.dart';
import '../../data/curriculum_data.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late List<Map<String, dynamic>> _tasks;

  @override
  void initState() {
    super.initState();
    _initializeTasks();
  }

  void _initializeTasks() {
    final roadmap = CurriculumData.subjects[widget.project.category]?.projectRoadmaps[widget.project.id];
    
    if (roadmap != null && roadmap.isNotEmpty) {
      _tasks = roadmap.map((step) => {'title': step, 'completed': false}).toList();
    } else {
      // Default fallback tasks
      _tasks = [
        {'title': 'Setup Project Environment', 'completed': true},
        {'title': 'Implement Core Logic', 'completed': false},
        {'title': 'Write Unit Tests', 'completed': false},
        {'title': 'Submit for Review', 'completed': false},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Text(widget.project.title),
        backgroundColor: const Color(0xFF161B22),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          
          if (isDesktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Header
                  Expanded(
                    flex: 4,
                    child: FadeInLeft(
                      child: _buildHeaderCard(),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Right Column: Tasks & Actions
                  Expanded(
                    flex: 6,
                    child: FadeInRight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTasksSection(),
                          const SizedBox(height: 32),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Mobile Layout
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(child: _buildHeaderCard()),
                const SizedBox(height: 24),
                FadeInUp(child: _buildTasksSection()),
                const SizedBox(height: 32),
                FadeInUp(delay: const Duration(milliseconds: 200), child: _buildActionButtons()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withValues(alpha: 0.2), const Color(0xFF161B22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(widget.project.iconData, size: 64, color: Colors.purple),
          const SizedBox(height: 16),
          Text(
            widget.project.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.project.description,
            style: TextStyle(color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Countdown Mock
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerItem('02', 'Days'),
              _buildTimerSeparator(),
              _buildTimerItem('14', 'Hours'),
              _buildTimerSeparator(),
              _buildTimerItem('30', 'Mins'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: task['completed'] ? Colors.green.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: CheckboxListTile(
                title: Text(
                  task['title'],
                  style: TextStyle(
                    color: task['completed'] ? Colors.green : Colors.white,
                    decoration: task['completed'] ? TextDecoration.lineThrough : null,
                  ),
                ),
                value: task['completed'],
                activeColor: Colors.green,
                checkColor: Colors.black,
                onChanged: (val) {
                  setState(() {
                    _tasks[index]['completed'] = val;
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.code),
            label: const Text('Open Code Playground'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21262D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description),
            label: const Text('Documentation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21262D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerItem(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.withValues(alpha: 0.5)),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildTimerSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
