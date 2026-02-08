import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/academics/folder_card.dart';
import '../../widgets/common/entry_animation.dart';
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
      backgroundColor: const Color(0xFF0D1117), // Dark Background
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. Branding Header
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0D1117).withValues(alpha: 0.9), // High opacity for readability
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                centerTitle: false,
                title: const Text(
                  'Academics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Adjusted for Collapsed state
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.15),
                        const Color(0xFF0D1117),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                _buildHeaderIcon(Icons.search, () {}),
                const SizedBox(width: 12),
                _buildHeaderIcon(Icons.filter_list, () {}),
                const SizedBox(width: 24),
              ],
            ),

            // 2. Persistent Tab Bar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey[500],
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  tabs: _sections.map((section) => Tab(text: section)).toList(),
                  dividerColor: Colors.white10,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _sections.map((section) {
            return _buildSubjectFolders(section);
          }).toList(),
        ),
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

    return Scrollbar(
      thumbVisibility: true, // Always show scrollbar for better UX
      child: CustomScrollView(
        key: PageStorageKey<String>(type), // Persist scroll position
        primary: false, // Resolve PrimaryScrollController conflict
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280, // Responsive Width
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.9, // Almost square but slightly taller
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return EntryAnimatedWidget(
                    delay: Duration(milliseconds: 50 + (index * 50).clamp(0, 500)), // Staggered
                    child: FolderCard(
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
                    ),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
          // Bottom Padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
  
  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// Delegate for Sticky Tab Bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0D1117), // Match background to cover scrolling content
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
