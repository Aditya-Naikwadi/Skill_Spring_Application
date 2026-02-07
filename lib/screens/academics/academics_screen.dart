import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.courseCategories.length,
      vsync: this,
    );
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
      appBar: AppBar(
        title: const Text('Academics'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Category Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.primaryColor,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.textSecondary,
                tabs: AppConstants.courseCategories
                    .map((category) => Tab(text: category))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: AppConstants.courseCategories.map((category) {
          return _buildCourseList(category);
        }).toList(),
      ),
    );
  }

  Widget _buildCourseList(String category) {
    // Placeholder courses
    final courses = _getPlaceholderCourses(category);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course);
      },
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    course['icon'] as IconData,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      course['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      course['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Info Row
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.signal_cellular_alt,
                          course['difficulty'] as String,
                          AppTheme.successColor,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.access_time,
                          course['duration'] as String,
                          AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.people_outline,
                          course['enrolled'] as String,
                          AppTheme.secondaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Enroll Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Enroll Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPlaceholderCourses(String category) {
    if (category == 'All') {
      return [
        {
          'title': 'Python for Beginners',
          'description': 'Learn Python programming from scratch with hands-on projects',
          'difficulty': 'Beginner',
          'duration': '8 weeks',
          'enrolled': '1.2K',
          'icon': Icons.code,
        },
        {
          'title': 'Web Development Bootcamp',
          'description': 'Master HTML, CSS, JavaScript and build real-world websites',
          'difficulty': 'Intermediate',
          'duration': '12 weeks',
          'enrolled': '2.5K',
          'icon': Icons.web,
        },
        {
          'title': 'Data Structures & Algorithms',
          'description': 'Master DSA concepts and ace coding interviews',
          'difficulty': 'Advanced',
          'duration': '10 weeks',
          'enrolled': '890',
          'icon': Icons.account_tree,
        },
      ];
    }
    
    // Return category-specific courses
    return [
      {
        'title': '$category Fundamentals',
        'description': 'Learn the basics of $category programming',
        'difficulty': 'Beginner',
        'duration': '6 weeks',
        'enrolled': '500',
        'icon': Icons.code,
      },
      {
        'title': 'Advanced $category',
        'description': 'Deep dive into advanced $category concepts',
        'difficulty': 'Advanced',
        'duration': '8 weeks',
        'enrolled': '300',
        'icon': Icons.code,
      },
    ];
  }
}
