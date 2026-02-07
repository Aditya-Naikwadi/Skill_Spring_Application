import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/academics/folder_card.dart';
import 'subject_details_screen.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Define the 3 main sections
  final List<String> _sections = ['Courses', 'Projects', 'Certificates'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Academics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              tabs: _sections.map((section) => Tab(text: section)).toList(),
              dividerColor: Colors.transparent, // Remove divider
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _sections.map((section) {
          return _buildSubjectFolders(section);
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectFolders(String type) {
    // Map categories to icons and colors for visual distinction
    final List<Map<String, dynamic>> categories = AppConstants.courseCategories.map((category) {
      IconData icon;
      Color color;

      // Assign distinct icons and colors based on category name
      if (category.contains('Programming')) {
        icon = Icons.code;
        color = Colors.blue;
      } else if (category.contains('Data Structures')) {
        icon = Icons.account_tree;
        color = Colors.orange;
      } else if (category.contains('Architecture')) {
        icon = Icons.memory;
        color = Colors.purple;
      } else if (category.contains('Operating Systems')) {
        icon = Icons.settings_system_daydream;
        color = Colors.teal;
      } else if (category.contains('Database')) {
        icon = Icons.storage;
        color = Colors.green;
      } else if (category.contains('Networks')) {
        icon = Icons.router;
        color = Colors.cyan;
      } else if (category.contains('Discrete')) {
        icon = Icons.calculate;
        color = Colors.indigo;
      } else if (category.contains('Software')) {
        icon = Icons.engineering;
        color = Colors.red;
      } else if (category.contains('Computation')) {
        icon = Icons.functions;
        color = Colors.deepPurple;
      } else if (category.contains('Object-Oriented')) {
        icon = Icons.data_object;
        color = Colors.pink;
      } else {
        icon = Icons.folder;
        color = Colors.blueGrey;
      }

      return {
        'name': category,
        'description': AppConstants.categoryDescriptions[category] ?? 'Explore $category',
        'icon': icon,
        'color': color,
      };
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85, // Adjust aspect ratio for card content
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return FolderCard(
          title: category['name'],
          subtitle: category['description'],
          icon: category['icon'],
          color: category['color'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetailsScreen(
                  category: category['name'],
                  type: type,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
